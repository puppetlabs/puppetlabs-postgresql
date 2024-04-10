# frozen_string_literal: true

# run a test task
require 'spec_helper_acceptance'

describe 'postgresql instance test1', if: os[:family] == 'redhat' && os[:release].start_with?('8') do
  pp = <<-MANIFEST
  # set global defaults
  class { 'postgresql::globals':
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
  }
  # define instance test1
  postgresql::server_instance { 'test1':
    instance_user        => 'ins_test1',
    instance_group       => 'ins_test1',
    instance_directories => {
      '/opt/pgsql'              => { 'ensure' => 'directory' },
      '/opt/pgsql/backup'       => { 'ensure' => 'directory' },
      '/opt/pgsql/data'         => { 'ensure' => 'directory' },
      '/opt/pgsql/data/13'      => { 'ensure' => 'directory' },
      '/opt/pgsql/data/home'    => { 'ensure' => 'directory' },
      '/opt/pgsql/wal'          => { 'ensure' => 'directory' },
      '/opt/pgsql/log'          => { 'ensure' => 'directory' },
      '/opt/pgsql/log/13'       => { 'ensure' => 'directory' },
      '/opt/pgsql/log/13/test1' => { 'ensure' => 'directory' },
    },
    config_settings      => {
      'pg_hba_conf_path'     => '/opt/pgsql/data/13/test1/pg_hba.conf',
      'postgresql_conf_path' => '/opt/pgsql/data/13/test1/postgresql.conf',
      'pg_ident_conf_path'   => '/opt/pgsql/data/13/test1/pg_ident.conf',
      'datadir'              => '/opt/pgsql/data/13/test1',
      'service_name'         => 'postgresql@13-test1',
      'port'                 => 5433,
      'pg_hba_conf_defaults' => false,
      'manage_selinux'       => true,
    },
    service_settings     => {
      'service_name'   => 'postgresql@13-test1',
      'service_status' => 'systemctl status postgresql@13-test1.service',
      'service_ensure' => 'running',
      'service_enable' => true,
    },
    initdb_settings      => {
      'auth_local'     => 'peer',
      'auth_host'      => 'md5',
      'needs_initdb'   => true,
      'datadir'        => '/opt/pgsql/data/13/test1',
      'encoding'       => 'UTF-8',
      'lc_messages'    => 'en_US.UTF8',
      'locale'         => 'en_US.UTF8',
      'data_checksums' => false,
      'group'          => 'postgres',
      'user'           => 'postgres',
      'username'       => 'ins_test1',
    },
    config_entries       => {
      'authentication_timeout'         => {
        'value'   => '1min',
        'comment' => 'a test',
      },
      'log_statement_stats'            => { 'value' => 'off' },
      'autovacuum_vacuum_scale_factor' => { 'value' => 0.3 },
    },
    databases            => {
      'testdb1' => {
        'encoding' => 'UTF8',
        'locale'   => 'en_US.UTF8',
        'owner'    => 'dba_test1',
      },
      'testdb2' => {
        'encoding' => 'UTF8',
        'locale'   => 'en_US.UTF8',
        'owner'    => 'dba_test1',
      },
    },
    roles                => {
      'ins_test1' => {
        'superuser' => true,
        'login'     => true,
      },
      'dba_test1' => {
        'createdb' => true,
        'login'    => true,
      },
      'app_test1' => { 'login' => true },
      'rep_test1' => {
        'replication' => true,
        'login'       => true,
      },
      'rou_test1' => { 'login' => true },
    },
    pg_hba_rules         => {
      'local all INSTANCE user'                 => {
        'type'        => 'local',
        'database'    => 'all',
        'user'        => 'ins_test1',
        'auth_method' => 'peer',
        'order'       => 1,
      },
      'local all DB user'                       => {
        'type'        => 'local',
        'database'    => 'all',
        'user'        => 'dba_test1',
        'auth_method' => 'peer',
        'order'       => 2,
      },
      'local all APP user'                      => {
        'type'        => 'local',
        'database'    => 'all',
        'user'        => 'app_test1',
        'auth_method' => 'peer',
        'order'       => 3,
      },
      'local all READONLY user'                 => {
        'type'        => 'local',
        'database'    => 'all',
        'user'        => 'rou_test1',
        'auth_method' => 'peer',
        'order'       => 4,
      },
      'remote all INSTANCE user PGADMIN server' => {
        'type'        => 'host',
        'database'    => 'all',
        'user'        => 'ins_test1',
        'address'     => '192.168.22.131/32',
        'auth_method' => 'md5',
        'order'       => 5,
      },
      'local replication INSTANCE user'         => {
        'type'        => 'local',
        'database'    => 'replication',
        'user'        => 'ins_test1',
        'auth_method' => 'peer',
        'order'       => 6,
      },
      'local replication REPLICATION user'      => {
        'type'        => 'local',
        'database'    => 'replication',
        'user'        => 'rep_test1',
        'auth_method' => 'peer',
        'order'       => 7,
      },
    },
  }
  MANIFEST

  it 'installs postgres instance test1' do
    export_locales('en_US.UTF-8 ')
    idempotent_apply(pp)
  end
end
