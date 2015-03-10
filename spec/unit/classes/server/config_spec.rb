require 'spec_helper'

describe 'postgresql::server::config', :type => :class do
  let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'RedHat',
      :operatingsystemrelease => '6.4',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  context 'with postgresql::server defaults' do
    let :pre_condition do
      "class {'postgresql::server': }"
    end

    it 'should reload the service when changing pg_hba.conf' do
      is_expected.to contain_concat('/var/lib/pgsql/data/pg_hba.conf').that_notifies('Class[postgresql::server::reload]')
    end

    it 'should reload the service when changing pg_ident.conf' do
      is_expected.to contain_concat('/var/lib/pgsql/data/pg_ident.conf').that_notifies('Class[postgresql::server::reload]')
    end
  end

  context 'with postgresql::server, restart => true' do
    let :pre_condition do
      "class {'postgresql::server': restart => true}"
    end

    it 'should restart the service when changing pg_hba.conf' do
      is_expected.to contain_concat('/var/lib/pgsql/data/pg_hba.conf').that_notifies('Class[postgresql::server::service]')
    end

    it 'should restart the service when changing pg_ident.conf' do
      is_expected.to contain_concat('/var/lib/pgsql/data/pg_ident.conf').that_notifies('Class[postgresql::server::service]')
    end
  end

  context 'with postgresql::server, restart => false' do
    let :pre_condition do
      "class {'postgresql::server': restart => false}"
    end

    it 'should reload the service when changing pg_hba.conf' do
      is_expected.to contain_concat('/var/lib/pgsql/data/pg_hba.conf').that_notifies('Class[postgresql::server::reload]')
    end

    it 'should reload the service when changing pg_ident.conf' do
      is_expected.to contain_concat('/var/lib/pgsql/data/pg_ident.conf').that_notifies('Class[postgresql::server::reload]')
    end
  end
end
