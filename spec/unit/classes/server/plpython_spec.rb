# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::plpython', type: :class do
  let :facts do
    {
      os: {
        family: 'RedHat',
        name: 'CentOS',
        release: { 'full' => '6.8', 'major' => '6' },
        selinux: { 'enabled' => true },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      selinux: true,
    }
  end

  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  describe 'on RedHat with no parameters' do
    it { is_expected.to contain_class('postgresql::server::plpython') }
    it 'creates package' do
      is_expected.to contain_package('postgresql-plpython').with(ensure: 'present',
                                                                 tag: 'puppetlabs-postgresql')
    end
  end

  describe 'with parameters' do
    let :params do
      {
        package_ensure: 'absent',
        package_name: 'mypackage',
      }
    end

    it { is_expected.to contain_class('postgresql::server::plpython') }
    it 'creates package with correct params' do
      is_expected.to contain_package('postgresql-plpython').with(ensure: 'absent',
                                                                 name: 'mypackage',
                                                                 tag: 'puppetlabs-postgresql')
    end
  end
end
