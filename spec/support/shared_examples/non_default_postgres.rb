require 'support/postgres_test_utils'
require 'support/shared_contexts/pg_vm_context'

shared_examples :non_default_postgres do
  include PostgresTestUtils
  include_context :pg_vm_context

  # this method is required by the pg_vm shared context
  def install_postgres
    #sudo_and_log(vm, 'puppet apply -e "include postgresql::server"')
    # TODO: implement
  end

  it "doesn't have any tests yet'" do
  end
end