require 'spec_helper_acceptance'

describe 'postgresql::server::db', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  # rubocop:disable RSpec/ExampleLength
  # rubocop:disable RSpec/MultipleExpectations
  # rubocop:disable Metrics/LineLength
  it 'creates a database' do
    begin
      tmpdir = default.tmpdir('postgresql')
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

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)

      # Verify that the postgres password works
      shell("echo 'localhost:*:*:postgres:\'space password\'' > /root/.pgpass")
      shell('chmod 600 /root/.pgpass')
      shell("psql -U postgres -h localhost --command='\\l'")

      psql('--command="select datname from pg_database" "postgresql-test-db"') do |r|
        expect(r.stdout).to match(%r{postgresql-test-db})
        expect(r.stderr).to eq('')
      end

      psql('--command="SELECT 1 FROM pg_roles WHERE rolname=\'test-user\'"') do |r|
        expect(r.stdout).to match(%r{\(1 row\)})
      end

      result = shell('psql --version')
      version = result.stdout.match(%r{\s(\d\.\d)})[1]
      comment_information_function = if version > '8.1'
                                       'shobj_description'
                                     else
                                       'obj_description'
                                     end
      psql("--dbname postgresql-test-db --command=\"SELECT pg_catalog.#{comment_information_function}(d.oid, 'pg_database') FROM pg_catalog.pg_database d WHERE datname = 'postgresql-test-db' AND pg_catalog.#{comment_information_function}(d.oid, 'pg_database') = 'testcomment'\"") do |r|
        expect(r.stdout).to match(%r{\(1 row\)})
      end
    ensure
      psql('--command=\'drop database "postgresql-test-db" postgres\'')
      psql('--command="DROP USER test"')
    end
  end
end
