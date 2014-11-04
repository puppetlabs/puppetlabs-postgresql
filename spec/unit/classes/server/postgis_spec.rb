require 'spec_helper'

describe 'postgresql::server::postgis', :type => :class do
  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('postgis'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  describe 'when setting package' do
    let(:params) do
      {
        :package_name => 'mypackage',
        :package_ensure => 'absent',
      }
    end

    it 'should create package with correct params' do
      is_expected.to contain_package('postgresql-postgis').with({
        :ensure => 'absent',
        :name => 'mypackage',
        :tag => 'postgresql',
      })
    end
  end

  describe 'when setting up template' do
    let(:params) do
      {
        :template => true,
      }
    end

    it 'should create the template database' do
      is_expected.to contain_postgresql__server__database('postgis template').with({
        :dbname     => 'template_postgis',
        :istemplate => true,
        :template   => 'template1',
      })
    end

    it 'should create database extensions' do
      is_expected.to contain_postgresql__server__extension('postgis').with({
        :database => 'template_postgis',
      })
      is_expected.to contain_postgresql__server__extension('postgis_topology').with({
        :database => 'template_postgis',
      })
    end
  end

  describe 'with no parameters' do
    it 'should create package with postgresql tag' do
      is_expected.to contain_package('postgresql-postgis').with({
        :tag => 'postgresql',
      })
    end
  end
end
