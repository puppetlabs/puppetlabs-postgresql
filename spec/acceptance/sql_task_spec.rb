# run a test task
require 'spec_helper_acceptance'

describe 'postgresql task' do
  describe 'sql task' do
    pp = <<-MANIFEST
        class { 'postgresql::server': } ->
        postgresql::server::db { 'spec1':
          user     => 'root1',
          password => postgresql_password('root1', 'password'),
        }
    MANIFEST

    it 'sets up a postgres db' do
      apply_manifest(pp, catch_failures: true)
    end

    it 'execute some sql' do
      # equates to 'psql -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'information_schema';"  --password --host localhost --dbname=spec1 --username root1'
      result = run_bolt_task('postgresql::sql', 'sql' => 'SELECT count(table_name) FROM information_schema.tables;', 'host' => 'localhost',
                                                'user' => 'root1', 'password' => 'password', 'database' => 'spec1')
      expect(result.stdout).to contain(%r{(1 row)})
    end
  end
end
