require 'spec_helper_acceptance'

describe 'postgresql_conn_validator', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:install_pp) do
    <<-MANIFEST
      class { 'postgresql::server':
        postgres_password => 'space password',
      }->
      postgresql::server::role { 'testuser':
        password_hash => postgresql_password('testuser','test1'),
      }->
      postgresql::server::database { 'testdb':
        owner   => 'testuser',
        require => Postgresql::Server::Role['testuser']
      }->
      postgresql::server::database_grant { 'allow connect for testuser':
        privilege => 'ALL',
        db        => 'testdb',
        role      => 'testuser',
      }
    MANIFEST
  end

  context 'local connection' do
    it 'validates successfully with defaults' do # rubocop:disable RSpec/ExampleLength
      pp = <<-MANIFEST
        #{install_pp}->
        postgresql_conn_validator { 'validate this':
          db_name     => 'testdb',
          db_username => 'testuser',
          db_password => 'test1',
          host        => 'localhost',
          psql_path   => '/usr/bin/psql',
        }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'works with connect settings hash' do # rubocop:disable RSpec/ExampleLength
      pp = <<-MANIFEST
        #{install_pp}->
        postgresql_conn_validator { 'validate this':
          connect_settings => {
            'PGDATABASE' => 'testdb',
            'PGPORT'     => '5432',
            'PGUSER'     => 'testuser',
            'PGPASSWORD' => 'test1',
            'PGHOST'     => 'localhost'
          },
          psql_path => '/usr/bin/psql'
        }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    it 'fails gracefully' do # rubocop:disable RSpec/ExampleLength
      pp = <<-MANIFEST
        #{install_pp}->
        postgresql_conn_validator { 'validate this':
          psql_path => '/usr/bin/psql',
          tries     => 3
        }
      MANIFEST

      result = apply_manifest(pp)
      expect(result.stderr).to match %r{Unable to connect to PostgreSQL server}
    end
  end
end
