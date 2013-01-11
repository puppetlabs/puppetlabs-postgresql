require 'support/postgres_test_utils'
require 'support/shared_contexts/pg_vm_context'

shared_examples :system_default_postgres do
  include PostgresTestUtils
  include_context :pg_vm_context

  # this method is required by the pg_vm shared context
  def install_postgres
    sudo_and_log(vm, 'puppet apply -e "include postgresql::server"')
  end

  describe 'postgresql::initdb' do
    it "should idempotently create a working --pgdata directory so postgres can run" do
      @logger.info("starting")

      # A bare-minimum class to initdb the specified dir
      test_class = 'class {"postgresql_tests::system_default::test_initdb": }'

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
      test_class = 'class {"postgresql_tests::system_default::test_db": db => "postgresql_test_db" }'

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
      test_class = 'class {"postgresql_tests::system_default::test_psql": command => "SELECT * FROM pg_datbase limit 1", unless => "SELECT 1 WHERE 1=1" }'

      data = sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'; [ $? == 2 ]")

      data.should match /postgresql::psql is deprecated/

    end
  end

  describe 'postgresql_psql' do
    it 'should run some SQL when the unless query returns no rows' do
      test_class = 'class {"postgresql_tests::system_default::test_ruby_psql": command => "SELECT 1", unless => "SELECT 1 WHERE 1=2" }'

      # Run once to get all packages set up
      sudo_and_log(vm, "puppet apply -e '#{test_class}'")

      # Check for exit code 2
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}' ; [ $? == 2 ]")
    end

    it 'should not run SQL when the unless query returns rows' do
      test_class = 'class {"postgresql_tests::system_default::test_ruby_psql": command => "SELECT * FROM pg_datbase limit 1", unless => "SELECT 1 WHERE 1=1" }'

      # Run once to get all packages set up
      sudo_and_log(vm, "puppet apply -e '#{test_class}'")

      # Check for exit code 0
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")
    end

  end

  describe 'postgresql::user' do
    it 'should idempotently create a user who can log in' do
      test_class = 'class {"postgresql_tests::system_default::test_user": user => "postgresql_test_user", password => "postgresql_test_password" }'

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
      test_class = 'class {"postgresql_tests::system_default::test_grant_create": db => "postgres", user => "psql_grant_tester", password => "psql_grant_pw" }'

      # Run once to check for crashes
      sudo_and_log(vm, "puppet apply -e '#{test_class}'")

      # Run again to check for idempotence
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_class}'")

      # Check that the user can create a table in the database
      sudo_psql_and_log(vm, '--command="create table foo (foo int)" postgres', 'psql_grant_tester')

      sudo_psql_and_log(vm, '--command="drop table foo" postgres', 'psql_grant_tester')
    end
  end

  describe 'postgresql::validate_db_connections' do
    it 'should run puppet with no changes declared if database connectivity works' do
      # Setup
      setup_class = 'class {"postgresql_tests::system_default::test_db": db => "foo" }'
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{setup_class}'; [ $? == 2 ]")

      # Run test
      test_pp = "postgresql::validate_db_connection {'foo': database_host => 'localhost', database_name => 'foo', database_username => 'foo', database_password => 'foo' }"
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_pp}'")
    end

    it 'should fail catalogue if database connectivity fails' do
      # Run test
      test_pp = "postgresql::validate_db_connection {'foo': database_host => 'localhost', database_name => 'foo', database_username => 'foo', database_password => 'foo' }"
      sudo_and_log(vm, "puppet apply --detailed-exitcodes -e '#{test_pp}'; [ $? == 4 ]")
    end
  end
end
