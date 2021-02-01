# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::plperl', type: :class do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '8.0', 'major' => '8' },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  describe 'with no parameters' do
    it { is_expected.to contain_class('postgresql::server::plperl') }
    it 'creates package' do
      is_expected.to contain_package('postgresql-plperl').with(ensure: 'present',
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

    it { is_expected.to contain_class('postgresql::server::plperl') }
    it 'creates package with correct params' do
      is_expected.to contain_package('postgresql-plperl').with(ensure: 'absent',
                                                               name: 'mypackage',
                                                               tag: 'puppetlabs-postgresql')
    end
  end
end
