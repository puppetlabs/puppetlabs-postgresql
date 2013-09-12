require 'spec_helper'

describe 'postgresql::contrib', :type => :class do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
    }
  end

  describe 'with parameters' do
    let(:params) do
      {
        :package_name => 'mypackage',
        :package_ensure => 'absent',
      }
    end

    it 'should create package with correct params' do
      should contain_package('postgresql-contrib').with({
        :ensure => 'absent',
        :name => 'mypackage',
        :tag => 'postgresql',
      })
    end
  end

  describe 'with no parameters' do
    it 'should create package with postgresql tag' do
      should contain_package('postgresql-contrib').with({
        :tag => 'postgresql',
      })
    end
  end
end
