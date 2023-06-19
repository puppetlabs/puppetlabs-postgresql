# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::config_entry' do
  before(:all) do
    LitmusHelper.instance.run_shell("cd /tmp; su 'postgres' -c 'pg_ctl stop -D /var/lib/pgsql/data/ -m fast'", acceptable_exit_codes: [0, 1]) unless os[:family].match?(%r{debian|ubuntu})
  end

  context 'unix_socket_directories' do
    let(:pp_test) do
      <<-MANIFEST
      class { 'postgresql::server':
        postgresql_conf_path => '/etc/postgresql-puppet.conf',
      }

      postgresql::server::config_entry { 'unix_socket_directories':
        value => '/var/socket/, /root/'
      }
      MANIFEST
    end

    it 'is expected to run idempotently' do
      idempotent_apply(pp_test)
      expect(run_shell('cat /etc/postgresql-puppet.conf').stdout).to match "unix_socket_directories = '/var/socket/, /root/'"
    end
  end
end
