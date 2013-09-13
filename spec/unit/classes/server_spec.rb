require 'spec_helper'

describe 'postgresql::server', :type => :class do
  let :facts do
    {
      :postgres_default_version => '8.4',
      :osfamily => 'Debian',
      :concat_basedir => tmpfilename('server'),
    }
  end
  let(:params) {{
      :manage_service => true,
  }}

  it { should include_class("postgresql::server") }

  it 'when manage_service set to true' do
    should contain_service('postgresqld')
    should contain_exec('reload_postgresql')
  end

  describe 'manage_service' do
    let :params do {
        :manage_service => false,
    }
    end

    it 'when manage_service set to false' do
      should_not contain_service('postgresqld')
      should_not contain_exec('reload_postgresql')
    end
  end

  describe 'uninstallation' do
    let :params do
      {
        :ensure => 'absent',
        :datadir => 'config_dir',
      }
    end

    it { should contain_service('postgresqld').with_ensure('stopped') }
    it { should contain_package('postgresql-server').with_ensure('purged') }
    it { should contain_file('config_dir').with({:ensure => 'absent', :recurse => true, :force => true}) }
  end
end

