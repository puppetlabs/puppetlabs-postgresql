# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::plperl' do
  include_examples 'Debian 11'

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
