# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::config_entry' do
  include_examples 'Debian 11'

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
    let(:params) { { ensure: 'present', name: 'port_spec', value: '5432' } }

    context 'redhat 7' do
      include_examples 'RedHat 7'

      it 'stops postgresql and changes the port #file' do
        expect(subject).to contain_file('/etc/systemd/system/postgresql.service.d/postgresql.conf')
      end
    end
  end

  context 'passes values through appropriately' do
    let(:params) { { ensure: 'present', name: 'check_function_bodies', value: 'off' } }

    it 'with no quotes' do
      expect(subject).to contain_postgresql_conf('check_function_bodies').with(name: 'check_function_bodies',
                                                                               value: 'off')
    end
  end

  context 'passes a string value through appropriately' do
    let(:params) { { ensure: 'present', name: 'string_value', value: 'entry_test' } }

    it 'and adds string value to config' do
      expect(subject).to contain_postgresql_conf('string_value').with(name: 'string_value',
                                                                      value: 'entry_test')
    end
  end

  context 'passes an integer value through appropriately' do
    let(:params) { { ensure: 'present', name: 'integer_value', value: 40 } }

    it 'and adds integer value to config' do
      expect(subject).to contain_postgresql_conf('integer_value').with(name: 'integer_value',
                                                                       value: 40)
    end
  end

  context 'passes a float value through appropriately' do
    let(:params) { { ensure: 'present', name: 'floating_point_value', value: 4.0 } }

    it 'and adds float value to config' do
      expect(subject).to contain_postgresql_conf('floating_point_value').with(name: 'floating_point_value',
                                                                              value: 4.0)
    end
  end

  context 'unix_socket_directories' do
    let(:params) { { ensure: 'present', name: 'unix_socket_directories', value: '/var/pgsql, /opt/postgresql, /root/' } }

    it 'restarts the server and change unix_socket_directories to the provided list' do
      expect(subject).to contain_postgresql_conf('unix_socket_directories')
        .with(name: 'unix_socket_directories',
              value: '/var/pgsql, /opt/postgresql, /root/')
        .that_notifies('Postgresql::Server::Instance::Service[main]')
    end
  end
end
