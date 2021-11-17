# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::contrib', type: :class do
  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  let :facts do
    {
      os: {
        family: 'RedHat',
        name: 'RedHat',
        release: { 'major' => '8' },
        selinux: {
          enabled: false,
        },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  describe 'with parameters' do
    let(:params) do
      {
        package_name: 'mypackage',
        package_ensure: 'absent',
      }
    end

    it 'creates package with correct params' do
      is_expected.to contain_package('postgresql-contrib').with(ensure: 'absent',
                                                                name: 'mypackage',
                                                                tag: 'puppetlabs-postgresql')
    end
  end

  describe 'with no parameters' do
    it 'creates package with postgresql tag' do
      is_expected.to contain_package('postgresql-contrib').with(tag: 'puppetlabs-postgresql')
    end
  end

  describe 'on Gentoo' do
    let :facts do
      {
        os: {
          family: 'Gentoo',
          name: 'Gentoo',
        },
      }
    end

    it 'postgresql-contrib should not be installed' do
      is_expected.to compile
      is_expected.not_to contain_package('postgresql-contrib')
    end
  end

  describe 'on Debian' do
    let :facts do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: { 'full' => '8.0', 'major' => '8' },
        },
      }
    end

    it 'postgresql-contrib should not be installed' do
      is_expected.to compile
      is_expected.not_to contain_package('postgresql-contrib')
    end
  end
end
