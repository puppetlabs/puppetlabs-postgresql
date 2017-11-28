# run a test task
require 'spec_helper_acceptance'

describe 'postgresql tasks' do
  describe 'execute some sql', if: pe_install? && puppet_version =~ %r{(5\.\d\.\d)} do
    pp = <<-EOS
        class { 'postgresql::server': } ->
        postgresql::server::db { 'spec1':
          user     => 'root1',
          password => postgresql_password('root1', 'password'),
        }
    EOS

    it 'sets up a postgresql instance' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'execute arbitary psql' do
      result = run_task(task_name: 'postgresql::psql', params: 'sql="SELECT table_name FROM information_schema.tables WHERE table_schema = \'information_schema\';" host=localhost user=root1 password=password')
      expect_multiple_regexes(result: result, regexes: [%r{columns}, %r{tables}, %r{Job completed. 1/1 nodes succeeded}])
    end
  end
end
