# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::plpython' do
  include_examples 'RedHat 8'

  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  describe 'on RedHat with no parameters' do
    it { is_expected.to contain_class('postgresql::server::plpython') }

    it 'creates package' do
      expect(subject).to contain_package('postgresql-plpython').with(ensure: 'present',
                                                                     tag: 'puppetlabs-postgresql')
    end
  end

  describe 'with parameters' do
    let :params do
      {
        package_ensure: 'absent',
        package_name: 'mypackage'
      }
    end

    it { is_expected.to contain_class('postgresql::server::plpython') }

    it 'creates package with correct params' do
      expect(subject).to contain_package('postgresql-plpython').with(ensure: 'absent',
                                                                     name: 'mypackage',
                                                                     tag: 'puppetlabs-postgresql')
    end
  end
end
