# puppet-postgresql
# For all details and documentation:
# http://github.com/inkling/puppet-postgresql
#
# Copyright 2012- Inkling Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'logger'
require 'vagrant'

# VM-based tests for postgresql::* defined resource types.
#
# The general structure is:
#  
#  - Roll back the VM
#  - Apply a minimal puppet config for the type and fail only on crashes
#  - Apply it again and fail if there were any new changes reported
#  - Check the state of the system

describe "postgresql" do

  # Tests are pretty slow w/sahara, and when we destroy the VMs at the beginning
  #  of the test run.  This can be a hindrance for development but is very
  #  valuable for final testing.  This constant allows you to toggle between
  #  strict testing and less strict testing--the latter being useful for
  #  development purposes.
  HardCoreTesting = false


  if HardCoreTesting
    # this will just make sure that we throw an error if the user tries to
    # run w/o having Sahara installed
    require 'sahara'
  end


  def sudo_and_log(vm, cmd)
    @logger.debug("Running command: '#{cmd}'")
    result = ""
    @env.vms[vm].channel.sudo(cmd) do |ch, data|
      result << data
      @logger.debug(data)
    end
    result
  end

  before(:all) do
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG # TODO: get from environment or rspec?

    vagrant_dir = File.dirname(__FILE__)
    @env = Vagrant::Environment::new(:cwd => vagrant_dir)

    # Sahara ignores :cwd so we have to chdir for now, see https://github.com/jedi4ever/sahara/issues/9
    Dir.chdir(vagrant_dir)
  end

  basic_testing_vms = [:lucid]

  basic_testing_vms.each do |vm|
    describe "basic (system default postgres) tests (vm: #{vm})" do
      before (:all) do
        if HardCoreTesting
          @env.cli("destroy", vm.to_s, "--force") # Takes too long
        end
        @env.cli("up", vm.to_s)

        # We are not testing the "package" resource type, so pull stuff in in advance
        sudo_and_log(vm, 'apt-get update')
        sudo_and_log(vm, 'apt-get install --yes --download-only postgresql-8.4')
        if HardCoreTesting
          @env.cli("sandbox", "on", vm.to_s)
        end
      end

      after(:each) do
        if HardCoreTesting
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

          sudo_and_log(vm, "service postgresql-8.4 restart")

          # Connect to it and list the databases
          sudo_and_log(vm, 'sudo -n -u postgres /usr/lib/postgresql/8.4/bin/psql --list --tuples-only')
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
            sudo_and_log(vm, 'sudo -u postgres psql postgresql_test_db --command="select datname from pg_database limit 1"')
          ensure
            sudo_and_log(vm, 'sudo -u postgres psql --command="drop database postgresql_test_db" postgres')
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
          sudo_and_log(vm, 'sudo -u postgresql_test_user psql --command="select datname from pg_database limit 1" postgres')
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
          sudo_and_log(vm, 'sudo -u psql_grant_tester psql --command="create table foo (foo int)" postgres')

          sudo_and_log(vm, 'sudo -u psql_grant_tester psql --command="drop table foo" postgres')
        end
      end
    end
  end

  non_default_testing_vms = [:cent6]

  non_default_testing_vms.each do |vm|
    describe "non-system-default postgres version tests (vm: #{vm})" do
      before (:all) do
        if HardCoreTesting
          @env.cli("destroy", vm.to_s, "--force") # Takes too long
        end
        @env.cli("up", vm.to_s)

        if HardCoreTesting
          @env.cli("sandbox", "on", vm.to_s)
        end
      end

      after(:each) do
        if HardCoreTesting
          @env.cli("sandbox", "rollback", vm.to_s)
        end
      end


      it "should have the echo command" do
        sudo_and_log(vm, 'echo "hi"')
      end
    end
  end
end

