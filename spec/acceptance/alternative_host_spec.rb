require 'spec_helper_acceptance'

# These tests ensure that postgres commands can be specified by host
# TODO: Setup Postgres on different server and try remote connetions
describe 'postgresql_psql', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'with a host parameter' do
    setup_postgres = <<-EOS
      class { 'postgresql::server':
        pg_hba_conf_defaults => false,
      }

      # For ease of testing, allow anyone to access Postgres
      # NEVER DO THIS IN THE REAL WORLD!
      postgresql::server::pg_hba_rule { 'allow full yolo access local':
        type        => 'local',
        database    => 'all',
        user        => 'all',
        auth_method => 'ident',
        order       => '000',
      }

      postgresql::server::pg_hba_rule { 'allow full yolo access host':
        type        => 'host',
        database    => 'all',
        user        => 'all',
        address     => '127.0.0.1/32',
        auth_method => 'trust',
        order       => '001',
      }
    EOS

    run_different_host = <<-EOS
    postgresql_psql { 'run against different host':
      db            => 'postgres',
      host          => '127.0.0.1',
      command       => 'select 1',
    }
    EOS

    apply_manifest(setup_postgres, :catch_failures => true)
    apply_manifest(run_different_host, :catch_failures => true)
  end

end