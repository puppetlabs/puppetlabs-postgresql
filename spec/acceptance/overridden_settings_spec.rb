require 'spec_helper_acceptance'

# These tests are designed to ensure that the module, when ran overrides,
# sets up everything correctly and allows us to connect to Postgres.
describe 'postgresql::server' do
  let(:pp) do
    <<-MANIFEST
    class { 'postgresql::server':
      roles          => {
        'testusername' => {
          password_hash => postgresql_password('testusername', 'supersecret'),
          createdb      => true,
        },
      },
      config_entries => {
        max_connections => 21,
      },
      pg_hba_rules   => {
        'from_remote_host' => {
          type        => 'host',
          database    => 'mydb',
          user        => 'myuser',
          auth_method => 'md5',
          address     => '192.0.2.100/32',
        },
      },
    }

    postgresql::server::database { 'testusername':
      owner => 'testusername',
    }
  MANIFEST
  end

  it 'with additional hiera entries' do
    idempotent_apply(pp)
    expect(port(5432)).to be_listening
    expect(psql('--command="\l" postgres', 'postgres').stdout).to match(%r{List of databases})
    expect(run_shell('PGPASSWORD=supersecret psql -U testusername -h localhost --command="\l"').stdout).to match 'List of databases'
  end
end
