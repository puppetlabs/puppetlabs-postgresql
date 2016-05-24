require 'spec_helper'

describe 'postgresql::server', :type => :class do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :lsbdistid => 'Debian',
      :lsbdistcodename => 'jessie',
      :operatingsystemrelease => '8.0',
      :concat_basedir => tmpfilename('server'),
      :kernel => 'Linux',
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  describe 'with no parameters' do
    it { is_expected.to contain_class("postgresql::params") }
    it { is_expected.to contain_class("postgresql::server") }
    it { is_expected.to contain_exec('postgresql_reload').with({
      'command' => 'service postgresql reload',
    })
    }
    it 'should validate connection' do
      is_expected.to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
  end

  describe 'service_ensure => running' do
    let(:params) do
      {
        :service_ensure    => 'running',
        :postgres_password => 'new-p@s$word-to-set'
      }
    end
    it { is_expected.to contain_class("postgresql::params") }
    it { is_expected.to contain_class("postgresql::server") }
    it { is_expected.to contain_class("postgresql::server::passwd") }
    it 'should validate connection' do
      is_expected.to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
    it 'should set postgres password' do
      is_expected.to contain_exec('set_postgres_postgrespw').with({
        'command'     => '/usr/bin/psql -c "ALTER ROLE \"postgres\" PASSWORD ${NEWPASSWD_ESCAPED}"',
        'user'        => 'postgres',
        'environment' => [
          "PGPASSWORD=new-p@s$word-to-set",
          "PGPORT=5432",
          "NEWPASSWD_ESCAPED=$$new-p@s$word-to-set$$"
        ],
        'unless'      => "/usr/bin/psql -h localhost -p 5432 -c 'select 1' > /dev/null",
      })
    end
  end

  describe 'service_ensure => stopped' do
    let(:params) {{ :service_ensure => 'stopped' }}
    it { is_expected.to contain_class("postgresql::params") }
    it { is_expected.to contain_class("postgresql::server") }
    it 'shouldnt validate connection' do
      is_expected.not_to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
  end

  describe 'service_restart_on_change => false' do
    let(:params) {{ :service_restart_on_change => false }}
    it { is_expected.to contain_class("postgresql::params") }
    it { is_expected.to contain_class("postgresql::server") }
    it { is_expected.to_not contain_Postgresql_conf('data_directory').that_notifies('Class[postgresql::server::service]')
    }
    it 'should validate connection' do
      is_expected.to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
  end

  describe 'service_restart_on_change => true' do
    let(:params) {{ :service_restart_on_change => true }}
    it { is_expected.to contain_class("postgresql::params") }
    it { is_expected.to contain_class("postgresql::server") }
    it { is_expected.to contain_Postgresql_conf('data_directory').that_notifies('Class[postgresql::server::service]')
    }
    it 'should validate connection' do
      is_expected.to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
  end

  describe 'service_reload => /bin/true' do
    let(:params) {{ :service_reload => '/bin/true' }}
    it { is_expected.to contain_class("postgresql::params") }
    it { is_expected.to contain_class("postgresql::server") }
    it { is_expected.to contain_exec('postgresql_reload').with({
      'command' => '/bin/true',
    })
    }
    it 'should validate connection' do
      is_expected.to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
  end

  describe 'service_manage => true' do
    let(:params) {{ :service_manage => true }}
    it { is_expected.to contain_service('postgresqld') }
  end

  describe 'service_manage => false' do
    let(:params) {{ :service_manage => false }}
    it { is_expected.not_to contain_service('postgresqld') }
    it 'shouldnt validate connection' do
      is_expected.not_to contain_postgresql__validate_db_connection('validate_service_is_running')
    end
  end

  describe 'package_ensure => absent' do
    let(:params) do
      {
        :package_ensure => 'absent',
      }
    end

    it 'should remove the package' do
      is_expected.to contain_package('postgresql-server').with({
        :ensure => 'purged',
      })
    end

    it 'should still enable the service' do
      is_expected.to contain_service('postgresqld').with({
        :ensure => 'running',
      })
    end
  end

  describe 'needs_initdb => true' do
    let(:params) do
      {
        :needs_initdb => true,
      }
    end

    it 'should contain proper initdb exec' do
      is_expected.to contain_exec('postgresql_initdb')
    end
  end

  describe 'postgresql_version' do
    let(:pre_condition) do
      <<-EOS
      class { 'postgresql::globals':
        manage_package_repo => true,
        version             => '99.5',
        before              => Class['postgresql::server'],
      }
      EOS
    end
    it 'contains the correct package version' do
      is_expected.to contain_class('postgresql::repo').with_version('99.5')
    end
  end

  describe 'create config entries' do
    let(:params) {{ 'config_entries' => {'example_config' => {'ensure' => 'present', 'value' => 'is_set'}}}}
    it 'changes the config file' do
      is_expected.to contain_postgresql_conf('example_config')
    end
  end

  describe 'create database entries' do
    let(:params) {{ 'databases' => {'test' => {'comment' => 'test comment'}} }}

    it { is_expected.to contain_postgresql_psql("COMMENT ON DATABASE \"test\" IS 'test comment'").with_connect_settings( {} ) }
  end

  describe 'create database_grant entries' do
    let(:params) {{ 'database_grants' => {'test' => {'privilege' => 'ALL', 'db' => 'test', 'role' => 'test'}} }}

    it { is_expected.to contain_postgresql__server__database_grant('test') }
    it { is_expected.to contain_postgresql__server__grant('database:test') }
  end

  describe 'create db entries' do
    let(:params) {{ 'dbs' => {'test' => {'user' => 'test', 'password' => 'test', 'owner' => 'tester'}} }}

    it { is_expected.to contain_postgresql__server__db('test') }
    it { is_expected.to contain_postgresql__server__database('test').with_owner('tester') }
    it { is_expected.to contain_postgresql__server__role('test').that_comes_before('Postgresql::Server::Database[test]') }
    it { is_expected.to contain_postgresql__server__database_grant('GRANT test - ALL - test') }
  end

  describe 'manage extension entries' do
    let(:params) {{ 'extensions' => {'postgis' => {'database' => 'template_postgis'}} }}

    it {
      is_expected.to contain_postgresql_psql('Add postgis extension to template_postgis').with({
        :db      => 'template_postgis',
        :command => 'CREATE EXTENSION "postgis"',
        :unless  => "SELECT t.count FROM (SELECT count(extname) FROM pg_extension WHERE extname = 'postgis') as t WHERE tt
.count = 1",
      }).that_requires('Postgresql::Server::Database[template_postgis]')
    }

  describe 'create pg_hba_rule entries' do
    let(:params) {{ 'pg_hba_rules' => {'test' => {'type' => 'host', 'database' => 'all', 'user' => 'all', 'address' => '1.1.1.1/24', 'auth_method' => 'md5', 'target' => tmpfilename('pg_hba_rule')}} }}

    it { is_expected.to contain_concat__fragment('pg_hba_rule_test') }
  end

  describe 'create pg_ident_rule entries' do
    let(:params) {{ 'pg_ident_rules' => {'test' => {'map_name' => 'thatsmymap', 'system_username' => 'systemuser', 'database_username' => 'dbuser', }} }}

    it { is_expected.to contain_concat__fragment('pg_ident_rule_test') }
  end

  describe 'create recovery entries' do
    let(:params) {{ 'recovery' => {'test' => {'restore_command' => 'restore_command', 'recovery_target_timeline' => 'recovery_target_timeline' }}, 'manage_recovery_conf' => true }}

    it { is_expected.to contain_concat__fragment('recovery.conf') }
  end

  describe 'create role entries' do
    let(:params) {{ 'roles' => {'test' => {'password_hash' => 'new-pa$s'}} }}

    it { is_expected.to contain_postgresql__server__role('test') }
  end

  describe 'create schema entries' do
    let(:params) {{ 'schemas' => {'test' => {'owner' => 'jane', 'db' => 'janedb' }} }}

    it { should contain_postgresql__server__schema('test') }
  end

  describe 'create table_grant entries' do
    let(:params) {{ 'table_grants' => {'test' => {'privilege' => 'ALL', 'db' => 'test', 'role' => 'test', 'table' => 'foo',}} }}

    it { is_expected.to contain_postgresql__server__table_grant('test') }
    it { is_expected.to contain_postgresql__server__grant('table:test') }
  end

  describe 'create tablespace entries' do
    let(:params) {{ 'tablespaces' => {'test' => {'location' => '/srv/data/foo'}} }}

    it { is_expected.to contain_postgresql__server__tablespace('test') }
  end

end
