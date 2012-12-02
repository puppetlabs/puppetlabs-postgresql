require 'logger'
require 'vagrant'
require 'support/test_config'

shared_examples :system_default_postgres do

  if TestConfig::HardCoreTesting
    # this will just make sure that we throw an error if the user tries to
    # run w/o having Sahara installed
    require 'sahara'
  end

  def sudo_and_log(vm, cmd)
    @logger.debug("Running command: '#{cmd}'")
    result = ""
    @env.vms[vm].channel.sudo("cd /tmp && #{cmd}") do |ch, data|
      result << data
      @logger.debug(data)
    end
    result
  end

  def sudo_psql_and_log(vm, psql_cmd, user = 'postgres')
    sudo_and_log(vm, "su #{user} -c 'psql #{psql_cmd}'")
  end

  before(:all) do
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG # TODO: get from environment or rspec?

    @env = Vagrant::Environment::new(:cwd => vagrant_dir)
  end

  after(:all) do
    if TestConfig::SuspendVMsAfterSuite
       @logger.debug("Suspending VM")
       @env.cli("suspend", vm.to_s)
    end
  end

  describe "basic (system default postgres) tests" do
    before (:all) do
      if TestConfig::HardCoreTesting
        @env.cli("destroy", vm.to_s, "--force") # Takes too long
      end

      @env.cli("up", vm.to_s)

      if TestConfig::HardCoreTesting
        sudo_and_log(vm, '[ "$(facter osfamily)" == "Debian" ] && apt-get update')
      end

      sudo_and_log(vm, 'puppet apply -e "include postgresql::server"')

      if TestConfig::HardCoreTesting
        # Sahara ignores :cwd so we have to chdir for now, see https://github.com/jedi4ever/sahara/issues/9
        Dir.chdir(vagrant_dir)
        @env.cli("sandbox", "on", vm.to_s)
      end
    end

    after(:each) do
      if TestConfig::HardCoreTesting
        @env.cli("sandbox", "rollback", vm.to_s)
      end
    end

    describe 'postgresql::initdb' do
      it "should idempotently create a working --pgdata directory so postgres can run" do
        @logger.info("starting")

        # A bare-minimum class to initdb the specified dir
        test_class = 'class {"postgresql_tests::test_initdb": }'

        # Run once to check for crashes
        sudo_and_log(vm, "puppet apply -e '#{test_class}'")

        # Run again to check for idempotence via --detailed-exitcodes
        sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")

        sudo_and_log(vm, "service #{service_name} restart")

        # Connect to it and list the databases
        sudo_psql_and_log(vm, '--list --tuples-only')
      end
    end

    describe 'postgresql::db' do
      it 'should idempotently create a db that we can connect to' do

        # A bare-minimum class to add a DB to postgres, which will be running due to ubuntu
        test_class = 'class {"postgresql_tests::test_db": db => "postgresql_test_db" }'

        begin
          # Run once to check for crashes
          sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'; [ $? == 2 ]")

          # Run again to check for idempotence
          sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")

          # Check that the database name is present
          sudo_psql_and_log(vm, 'postgresql_test_db --command="select datname from pg_database limit 1"')
        ensure
          sudo_psql_and_log(vm, '--command="drop database postgresql_test_db" postgres')
        end
      end
    end

    describe 'postgresql::psql' do
      it 'should emit a deprecation warning' do
        test_class = 'class {"postgresql_tests::test_psql": command => "SELECT * FROM pg_datbase limit 1", unless => "SELECT 1 WHERE 1=1" }'

        data = sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'; [ $? == 2 ]")

        data.should match /postgresql::psql is deprecated/

      end
    end

    describe 'postgresql_psql' do
      it 'should run some SQL when the unless query returns no rows' do
        test_class = 'class {"postgresql_tests::test_ruby_psql": command => "SELECT 1", unless => "SELECT 1 WHERE 1=2" }'

        # Run once to get all packages set up
        sudo_and_log(vm, "puppet apply -e '#{test_class}'")

        # Check for exit code 2
        sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}' ; [ $? == 2 ]")
      end

      it 'should not run SQL when the unless query returns rows' do
        test_class = 'class {"postgresql_tests::test_ruby_psql": command => "SELECT * FROM pg_datbase limit 1", unless => "SELECT 1 WHERE 1=1" }'

        # Run once to get all packages set up
        sudo_and_log(vm, "puppet apply -e '#{test_class}'")

        # Check for exit code 0
        sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")
      end

    end

    describe 'postgresql::user' do
      it 'should idempotently create a user who can log in' do
        test_class = 'class {"postgresql_tests::test_user": user => "postgresql_test_user", password => "postgresql_test_password" }'

        # Run once to check for crashes
        sudo_and_log(vm, "puppet apply -e '#{test_class}'")

        # Run again to check for idempotence
        sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")

        # Check that the user can log in
        sudo_psql_and_log(vm, '--command="select datname from pg_database limit 1" postgres', 'postgresql_test_user')
      end
    end

    describe 'postgresql::grant' do
      it 'should grant access so a user can create in a database' do
        test_class = 'class {"postgresql_tests::test_grant_create": db => "postgres", user => "psql_grant_tester", password => "psql_grant_pw" }'

        # Run once to check for crashes
        sudo_and_log(vm, "puppet apply -e '#{test_class}'")

        # Run again to check for idempotence
        sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")

        # Check that the user can create a table in the database
        sudo_psql_and_log(vm, '--command="create table foo (foo int)" postgres', 'psql_grant_tester')

        sudo_psql_and_log(vm, '--command="drop table foo" postgres', 'psql_grant_tester')
      end
    end
  end

end