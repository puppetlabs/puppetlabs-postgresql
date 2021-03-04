# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::client', type: :class do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '8.0', 'major' => '8' },
      },
    }
  end

  describe 'with parameters' do
    let :params do
      {
        validcon_script_path: '/opt/bin/my-validate-con.sh',
        package_ensure: 'absent',
        package_name: 'mypackage',
        file_ensure: 'file',
      }
    end

    it 'modifies package' do
      is_expected.to contain_package('postgresql-client').with(ensure: 'absent',
                                                               name: 'mypackage',
                                                               tag: 'puppetlabs-postgresql')
    end

    it 'has specified validate connexion' do
      is_expected.to contain_file('/opt/bin/my-validate-con.sh').with(ensure: 'file',
                                                                      owner: 0,
                                                                      group: 0,
                                                                      mode: '0755')
    end
  end

  describe 'with no parameters' do
    it 'creates package with postgresql tag' do
      is_expected.to contain_package('postgresql-client').with(tag: 'puppetlabs-postgresql')
    end
  end

  describe 'with manage_dnf_module true' do
    let(:pre_condition) do
      <<-PUPPET
      class { 'postgresql::globals':
        manage_dnf_module => true,
      }
      PUPPET
    end

    it { is_expected.to contain_package('postgresql dnf module').that_comes_before('Package[postgresql-client]') }
  end

  describe 'with client package name explicitly set undef' do
    let :params do
      {
        package_name: 'UNSET',
      }
    end

    it 'does not manage postgresql-client package' do
      is_expected.not_to contain_package('postgresql-client')
    end
  end
end
