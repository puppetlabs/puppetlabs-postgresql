require 'support/postgres_test_utils'
require 'support/shared_contexts/pg_vm_context'

shared_examples :non_default_postgres do
  include PostgresTestUtils
  include_context :pg_vm_context

  # this method is required by the pg_vm shared context
  def install_postgres
    sudo_and_log(vm, 'puppet apply -e "include postgresql_tests::non_default::test_install"')
  end

  describe 'postgresql::db' do
    it 'should idempotently create a db that we can connect to' do

      # A bare-minimum class to add a DB to postgres, which will be running due to ubuntu
      test_class = 'class {"postgresql_tests::non_default::test_db": db => "postgresql_test_db" }'

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
end
