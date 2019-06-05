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

    it 'is expected to run idempotently' do
      idempotent_apply(pp_test)
      expect(run_shell('cat /tmp/postgresql.conf').stdout).to match "unix_socket_directories = '/var/socket/, /root/'"
    end
  end
end
