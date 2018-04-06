require 'spec_helper_acceptance'

# These tests are designed to ensure that the module, when ran overrides,
# sets up everything correctly and allows us to connect to Postgres.
describe 'postgresql::server', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  pp = <<-MANIFEST
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

  it 'with additional hiera entries' do
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe port(5432) do
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('--command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end

  it 'can connect with psql as testusername' do
    shell('PGPASSWORD=supersecret psql -U testusername -h localhost --command="\l"') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end
end
