require 'spec_helper'

describe 'postgresql::config::beforeservice', :type => :class do
  let :facts do
    {
      :postgres_default_version => '8.4',
      :osfamily => 'Debian',
      :concat_basedir => tmpfilename('config'),
    }
  end
  let :params do
    {
      :pg_hba_conf_path     => tmpfilename('hba_conf'),
      :postgresql_conf_path => tmpfilename('pg_conf'),
      :manage_pg_hba_conf   => true,
      :manage_service       => true,
    }
  end
  it { should include_class("postgresql::config::beforeservice") }

  describe 'pg_hba_conf notifies the service' do
    it { should contain_Postgresql__pg_hba('main').with_notify('Exec[reload_postgresql]') }
    it { should contain_File_line('postgresql.conf#listen_addresses').with_notify('Service[postgresqld]') }
    it { should contain_File_line('postgresql.conf#include').with_notify('Service[postgresqld]') }
  end


  describe 'pg_hba_conf does not notifies the service' do
    let :params do
      {
          :pg_hba_conf_path     => tmpfilename('hba_conf'),
          :postgresql_conf_path => tmpfilename('pg_conf'),
          :manage_pg_hba_conf   => true,
          :manage_service       => false,
      }
    end

    it { should_not contain_Postgresql__pg_hba('main').with_notify('Exec[reload_postgresql]') }
    it { should_not contain_File_line('postgresql.conf#listen_addresses').with_notify('Service[postgresqld]') }
    it { should_not contain_File_line('postgresql.conf#include').with_notify('Service[postgresqld]') }
  end
end
