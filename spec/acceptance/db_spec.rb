require 'spec_helper_acceptance'

describe 'postgresql::server::db' do
  it 'creates a database' do
    begin
      tmpdir = run_shell('mktemp').stdout
      pp = <<-MANIFEST
        class { 'postgresql::server':
          postgres_password => 'space password',
        }
        postgresql::server::tablespace { 'postgresql-test-db':
          location => '#{tmpdir}',
        } ->
        postgresql::server::db { 'postgresql-test-db':
          comment    => 'testcomment',
          user       => 'test-user',
          password   => 'test1',
          tablespace => 'postgresql-test-db',
        }
      MANIFEST

      idempotent_apply(pp)

      # Verify that the postgres password works
      run_shell("echo 'localhost:*:*:postgres:\'space password\'' > /root/.pgpass")
      run_shell('chmod 600 /root/.pgpass')
      run_shell("psql -U postgres -h localhost --command='\\l'")

      result = psql('--command="select datname from pg_database" "postgresql-test-db"')
      expect(result.stdout).to match(%r{postgresql-test-db})
      expect(result.stderr).to eq('')

      result = psql('--command="SELECT 1 FROM pg_roles WHERE rolname=\'test-user\'"')
      expect(result.stdout).to match(%r{\(1 row\)})
      comment_information_function = if Gem::Version.new(postgresql_version) > Gem::Version.new('8.1')
                                       'shobj_description'
                                     else
                                       'obj_description'
                                     end
      result = psql("--dbname postgresql-test-db --command=\"SELECT pg_catalog.#{comment_information_function}(d.oid, 'pg_database') FROM pg_catalog.pg_database d WHERE datname = 'postgresql-test-db' AND pg_catalog.#{comment_information_function}(d.oid, 'pg_database') = 'testcomment'\"") # rubocop:disable Metrics/LineLength
      expect(result.stdout).to match(%r{\(1 row\)})
    ensure
      psql('--command=\'drop database "postgresql-test-db"\'')
    end
  end
end
