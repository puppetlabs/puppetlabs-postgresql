# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::config_entry', type: :define do
  let :facts do
    {
      os: {
        family: 'RedHat',
        name: 'RedHat',
        release: {
          'full'  => '6.4',
          'major' => '6',
          'minor' => '4',
        },
        selinux: { 'enabled' => true },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      selinux: true,
    }
  end

  let(:title) { 'config_entry' }

  let :target do
    tmpfilename('postgresql_conf')
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  context 'syntax check' do
    let(:params) { { ensure: 'present' } }

    it { is_expected.to contain_postgresql__server__config_entry('config_entry') }
  end

  context 'ports' do
    context 'redhat 6' do
      let :facts do
        {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: { 'full' => '6.4', 'major' => '6' },
            selinux: { 'enabled' => true },
          },
          kernel: 'Linux',
          id: 'root',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          selinux: true,
        }
      end
      let(:params) { { ensure: 'present', name: 'port_spec', value: '5432' } }

      it 'stops postgresql and changes the port #exec' do
        is_expected.to contain_exec('postgresql_stop_port')
      end
      it 'stops postgresql and changes the port #augeas' do
        is_expected.to contain_augeas('override PGPORT in /etc/sysconfig/pgsql/postgresql')
      end
    end
    context 'redhat 7' do
      let :facts do
        {
          os: {
            family: 'RedHat',
            name: 'RedHat',
            release: {
              'full'  => '7.9.2009',
              'major' => '7',
              'minor' => '9',
            },
            selinux: { 'enabled' => true },
          },
          kernel: 'Linux',
          id: 'root',
          path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          selinux: true,
          service_provider: 'systemd',
        }
      end
      let(:params) { { ensure: 'present', name: 'port_spec', value: '5432' } }

      it 'stops postgresql and changes the port #file' do
        is_expected.to contain_file('systemd-override')
      end
    end
  end

  context 'data_directory' do
    let(:params) { { ensure: 'present', name: 'data_directory_spec', value: '/var/pgsql' } }

    it 'stops postgresql and changes the data directory #exec' do
      is_expected.to contain_exec('postgresql_data_directory')
    end
    it 'stops postgresql and changes the data directory #augeas' do
      is_expected.to contain_augeas('override PGDATA in /etc/sysconfig/pgsql/postgresql')
    end
  end

  context 'passes values through appropriately' do
    let(:params) { { ensure: 'present', name: 'check_function_bodies', value: 'off' } }

    it 'with no quotes' do
      is_expected.to contain_postgresql_conf('check_function_bodies').with(name: 'check_function_bodies',
                                                                           value: 'off')
    end
  end

  context 'unix_socket_directories' do
    let :facts do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { 'full' => '7.0', 'major' => '7' },
          selinux: { 'enabled' => true },
        },
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        selinux: true,
      }
    end
    let(:params) { { ensure: 'present', name: 'unix_socket_directories', value: '/var/pgsql, /opt/postgresql, /root/' } }

    it 'restarts the server and change unix_socket_directories to the provided list' do
      is_expected.to contain_postgresql_conf('unix_socket_directories')
        .with(name: 'unix_socket_directories',
              value: '/var/pgsql, /opt/postgresql, /root/')
        .that_notifies('Class[postgresql::server::service]')
    end
  end
end
