# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::contrib' do
  include_examples 'RedHat 8'

  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  describe 'with parameters' do
    let(:params) do
      {
        package_name: 'mypackage',
        package_ensure: 'absent',
      }
    end

    it 'creates package with correct params' do
      expect(subject).to contain_package('postgresql-contrib').with(ensure: 'absent',
                                                                    name: 'mypackage',
                                                                    tag: 'puppetlabs-postgresql')
    end
  end

  describe 'with no parameters' do
    it 'creates package with postgresql tag' do
      expect(subject).to contain_package('postgresql-contrib').with(tag: 'puppetlabs-postgresql')
    end
  end

  describe 'on Gentoo' do
    include_examples 'Gentoo'

    it 'postgresql-contrib should not be installed' do
      expect(subject).to compile
      expect(subject).not_to contain_package('postgresql-contrib')
    end
  end

  describe 'on Debian 11' do
    include_examples 'Debian 11'

    it 'postgresql-contrib should not be installed' do
      expect(subject).to compile
      expect(subject).not_to contain_package('postgresql-contrib')
    end
  end
end
