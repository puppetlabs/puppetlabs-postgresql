require 'spec_helper_acceptance'

describe 'postgresql::server::config_entry' do
  context 'unix_socket_directories' do
    let(:pp_test) do
      <<-MANIFEST
      class { 'postgresql::server':
        postgresql_conf_path => '/tmp/postgresql.conf',
      }

      postgresql::server::config_entry { 'unix_socket_directories':
        value => '/var/socket/, /root/'
      }
      MANIFEST
    end

    # get postgresql version
    apply_manifest("class { 'postgresql::server': }")
    result = shell('psql --version')
    version = result.stdout.match(%r{\s(\d{1,2}\.\d)})[1]

    if version >= '9.3'
      it 'is expected to run idempotently' do
        idempotent_apply(default, pp_test)
      end

      it 'is expected to contain directories' do
        shell('cat /tmp/postgresql.conf') do |output|
          expect(output.stdout).to contain("unix_socket_directories = '/var/socket/, /root/'")
        end
      end
    end
  end
end
