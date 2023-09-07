# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server_instance' do
  include_examples 'RedHat 8'

  let :pre_condition do
    "class { 'postgresql::globals':
      encoding            => 'UTF-8',
      locale              => 'en_US.UTF-8',
      manage_package_repo => false,
      manage_dnf_module   => true,
      needs_initdb        => true,
      version             => '13',
  }
  # stop default main instance
  class { 'postgresql::server':
    service_ensure => 'stopped',
    service_enable => false,
  }"
  end
  let(:title) { 'test1' }
  let(:params) do
    {
      'instance_user': 'ins_test1',
      'instance_group': 'ins_test1',
      'instance_directories': { '/opt/pgsql': { 'ensure' => 'directory' },
                                '/opt/pgsql/backup': { 'ensure' => 'directory' },
                                '/opt/pgsql/data': { 'ensure' => 'directory' },
                                '/opt/pgsql/data/13': { 'ensure' => 'directory' },
                                '/opt/pgsql/data/home': { 'ensure' => 'directory' },
                                '/opt/pgsql/wal': { 'ensure' => 'directory' },
                                '/opt/pgsql/log': { 'ensure' => 'directory' },
                                '/opt/pgsql/log/13': { 'ensure' => 'directory' },
                                '/opt/pgsql/log/13/test1': { 'ensure' => 'directory' }, },
      'config_settings': { 'pg_hba_conf_path' => '/opt/pgsql/data/13/test1/pg_hba.conf',
                           'postgresql_conf_path' => '/opt/pgsql/data/13/test1/postgresql.conf',
                           'pg_ident_conf_path' => '/opt/pgsql/data/13/test1/pg_ident.conf',
                           'datadir' => '/opt/pgsql/data/13/test1',
                           'service_name' => 'postgresql@13-test1',
                           'port' => 5433,
                           'pg_hba_conf_defaults' => false },
      'service_settings': { 'service_name' => 'postgresql@13-test1',
                            'service_status' => 'systemctl status postgresql@13-test1.service',
                            'service_ensure' => 'running',
                            'service_enable' => true },
      'initdb_settings': { 'auth_local' => 'peer',
                           'auth_host' => 'md5',
                           'needs_initdb' => true,
                           'datadir' => '/opt/pgsql/data/13/test1',
                           'encoding' => 'UTF-8',
                           'lc_messages' => 'en_US.UTF8',
                           'locale' => 'en_US.UTF8',
                           'data_checksums' => false,
                           'group' => 'postgres',
                           'user' => 'postgres',
                           'username' => 'ins_test1' },
      'config_entries': { 'authentication_timeout': { 'value' => '1min',
                                                      'comment' => 'a test' },
                          'log_statement_stats': { 'value' => 'off' },
                          'autovacuum_vacuum_scale_factor': { 'value' => 0.3 }, },
      'databases': { 'testdb1': { 'encoding' => 'UTF8',
                                  'locale' => 'en_US.UTF8',
                                  'owner' => 'dba_test1' },
                      'testdb2': { 'encoding' => 'UTF8',
                                   'locale' => 'en_US.UTF8',
                                   'owner' => 'dba_test1' }, },
      'roles': { 'ins_test1': { 'superuser' => true,
                                'login' => true,  },
                 'dba_test1': { 'createdb' => true,
                                'login' => true,  },
                 'app_test1': { 'login' => true },
                 'rep_test1': { 'replication' => true,
                                'login' => true },
                 'rou_test1': { 'login' => true }, },
      'pg_hba_rules': { 'local all INSTANCE user': { 'type' => 'local',
                                                     'database' => 'all',
                                                     'user' => 'ins_test1',
                                                     'auth_method' => 'peer',
                                                     'order' => 1 },
                        'local all DB user': { 'type' => 'local',
                                               'database' => 'all',
                                               'user' => 'dba_test1',
                                               'auth_method' => 'peer',
                                               'order' => 2 },
                        'local all APP user': { 'type' => 'local',
                                                'database' => 'all',
                                                'user' => 'app_test1',
                                                'auth_method' => 'peer',
                                                'order' => 3 },
                        'local all READONLY user': { 'type' => 'local',
                                                'database' => 'all',
                                                'user' => 'rou_test1',
                                                'auth_method' => 'peer',
                                                'order' => 4 },
                        'remote all INSTANCE user PGADMIN server': { 'type' => 'host',
                                                                     'database' => 'all',
                                                                     'user' => 'ins_test1',
                                                                     'address' => '192.168.22.131/32',
                                                                     'auth_method' => 'md5',
                                                                     'order' => 5 },
                        'local replication INSTANCE user': { 'type' => 'local',
                                                             'database' => 'replication',
                                                             'user' => 'ins_test1',
                                                             'auth_method' => 'peer',
                                                             'order' => 6 },
                        'local replication REPLICATION user': { 'type' => 'local',
                                                                'database' => 'replication',
                                                                'user' => 'rep_test1',
                                                                'auth_method' => 'peer',
                                                                'order' => 7 },  },
    }
  end

  context 'with postgresql instance test1' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server_instance('test1') }
    it { is_expected.to contain_user('ins_test1') }
    it { is_expected.to contain_group('ins_test1') }
    it { is_expected.to contain_service('postgresqld_instance_test1').with_name('postgresql@13-test1').with_status('systemctl status postgresql@13-test1.service') }
    it { is_expected.to contain_systemd__dropin_file('postgresql@13-test1.conf') }
    it { is_expected.to contain_postgresql_conn_validator('validate_service_is_running_instance_test1') }
    it { is_expected.to contain_postgresql_conf('port_for_instance_test1') }
    it { is_expected.to contain_postgresql_conf('log_statement_stats_test1') }
    it { is_expected.to contain_postgresql_conf('data_directory_for_instance_test1') }
    it { is_expected.to contain_postgresql_conf('autovacuum_vacuum_scale_factor_test1') }
    it { is_expected.to contain_postgresql_conf('authentication_timeout_test1') }
    it { is_expected.to contain_postgresql__server__role('app_test1') }
    it { is_expected.to contain_postgresql__server__role('dba_test1') }
    it { is_expected.to contain_postgresql__server__role('ins_test1') }
    it { is_expected.to contain_postgresql__server__role('rep_test1') }
    it { is_expected.to contain_postgresql__server__role('rou_test1') }
    it { is_expected.to contain_anchor('postgresql::server::service::begin::test1') }
    it { is_expected.to contain_anchor('postgresql::server::service::end::test1') }
    it { is_expected.to contain_class('Postgresql::Dnfmodule') }
    it { is_expected.to contain_class('Postgresql::Server::Install') }
    it { is_expected.to contain_class('Postgresql::Server::Reload') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_local all APP user for instance test1') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_local all DB user for instance test1') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_local all INSTANCE user for instance test1') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_local all READONLY user for instance test1') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_local replication INSTANCE user for instance test1') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_local replication REPLICATION user for instance test1') }
    it { is_expected.to contain_concat__fragment('pg_hba_rule_remote all INSTANCE user PGADMIN server for instance test1') }
    it { is_expected.to contain_concat('/opt/pgsql/data/13/test1/pg_hba.conf') }
    it { is_expected.to contain_concat('/opt/pgsql/data/13/test1/pg_ident.conf') }
    it { is_expected.to contain_exec('postgresql_initdb_instance_test1') }
    it { is_expected.to contain_file('/opt/pgsql/backup') }
    it { is_expected.to contain_file('/opt/pgsql/data/13/test1/postgresql.conf') }
    it { is_expected.to contain_file('/opt/pgsql/data/13/test1') }
    it { is_expected.to contain_file('/opt/pgsql/data/13') }
    it { is_expected.to contain_file('/opt/pgsql/data/home') }
    it { is_expected.to contain_file('/opt/pgsql/data') }
    it { is_expected.to contain_file('/opt/pgsql/log/13/test1') }
    it { is_expected.to contain_file('/opt/pgsql/log/13') }
    it { is_expected.to contain_file('/opt/pgsql/log') }
    it { is_expected.to contain_file('/opt/pgsql/wal') }
    it { is_expected.to contain_file('/opt/pgsql') }
    it { is_expected.to contain_postgresql__server__config_entry('authentication_timeout_test1') }
    it { is_expected.to contain_postgresql__server__config_entry('autovacuum_vacuum_scale_factor_test1') }
    it { is_expected.to contain_postgresql__server__config_entry('data_directory_for_instance_test1') }
    it { is_expected.to contain_postgresql__server__config_entry('log_statement_stats_test1') }
    it { is_expected.to contain_postgresql__server__config_entry('password_encryption_for_instance_test1') }
    it { is_expected.to contain_postgresql__server__config_entry('port_for_instance_test1') }
    it { is_expected.to contain_postgresql__server__database('testdb1') }
    it { is_expected.to contain_postgresql__server__database('testdb2') }
    it { is_expected.to contain_postgresql__server__instance__config('test1') }
    it { is_expected.to contain_postgresql__server__instance__initdb('test1') }
    it { is_expected.to contain_postgresql__server__instance__passwd('test1') }
    it { is_expected.to contain_postgresql__server__instance__service('test1') }
    it { is_expected.to contain_postgresql__server__instance__systemd('test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('local all APP user for instance test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('local all DB user for instance test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('local all INSTANCE user for instance test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('local all READONLY user for instance test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('local replication INSTANCE user for instance test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('local replication REPLICATION user for instance test1') }
    it { is_expected.to contain_postgresql__server__pg_hba_rule('remote all INSTANCE user PGADMIN server for instance test1') }
    it { is_expected.to contain_postgresql_psql('ALTER DATABASE "testdb1" OWNER TO "dba_test1"') }
    it { is_expected.to contain_postgresql_psql('ALTER DATABASE "testdb2" OWNER TO "dba_test1"') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" CONNECTION LIMIT -1') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" INHERIT') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" LOGIN') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" NOCREATEDB') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" NOCREATEROLE') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" NOREPLICATION') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "app_test1" NOSUPERUSER') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" CONNECTION LIMIT -1') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" CREATEDB') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" INHERIT') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" LOGIN') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" NOCREATEROLE') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" NOREPLICATION') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "dba_test1" NOSUPERUSER') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" CONNECTION LIMIT -1') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" INHERIT') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" LOGIN') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" NOCREATEDB') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" NOCREATEROLE') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" NOREPLICATION') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "ins_test1" SUPERUSER') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" CONNECTION LIMIT -1') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" INHERIT') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" LOGIN') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" NOCREATEDB') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" NOCREATEROLE') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" NOSUPERUSER') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rep_test1" REPLICATION') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" CONNECTION LIMIT -1') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" INHERIT') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" LOGIN') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" NOCREATEDB') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" NOCREATEROLE') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" NOREPLICATION') }
    it { is_expected.to contain_postgresql_psql('ALTER ROLE "rou_test1" NOSUPERUSER') }
    it { is_expected.to contain_postgresql_psql('CREATE ROLE app_test1 ENCRYPTED PASSWORD ****') }
    it { is_expected.to contain_postgresql_psql('CREATE ROLE dba_test1 ENCRYPTED PASSWORD ****') }
    it { is_expected.to contain_postgresql_psql('CREATE ROLE ins_test1 ENCRYPTED PASSWORD ****') }
    it { is_expected.to contain_postgresql_psql('CREATE ROLE rep_test1 ENCRYPTED PASSWORD ****') }
    it { is_expected.to contain_postgresql_psql('CREATE ROLE rou_test1 ENCRYPTED PASSWORD ****') }
  end
end
