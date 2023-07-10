# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::role' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  context 'with Password Datatype String' do
    let :params do
      {
        password_hash: 'new-pa$s'
      }
    end

    it { is_expected.to contain_postgresql__server__role('test') }

    it 'has create role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(CREATE ROLE "test" ENCRYPTED PASSWORD 'new-pa$s' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1)),
              'sensitive' => 'true',
              'unless' => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
              'port' => '5432')
    end

    it 'has alter role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(ALTER ROLE "test" ENCRYPTED PASSWORD 'md5b6f7fcbbabb4befde4588a26c1cfd2fa')),
              'sensitive' => 'true',
              'unless' => sensitive(%(SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa')),
              'port' => '5432')
    end
  end

  context 'with Password Datatype Sensitive[String]' do
    let :params do
      {
        password_hash: sensitive('new-pa$s')
      }
    end

    it { is_expected.to contain_postgresql__server__role('test') }

    it 'has create role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(CREATE ROLE "test" ENCRYPTED PASSWORD 'new-pa$s' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1)),
              'sensitive' => 'true',
              'unless' => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
              'port' => '5432')
    end

    it 'has alter role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(ALTER ROLE "test" ENCRYPTED PASSWORD 'Sensitive [value redacted]')),
              # FIXME: This is obviously wrong                               ^^^^^^^^^^^^^^^^^^^^^^^^^^
              'sensitive' => 'true',
              'unless' => sensitive(%(SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'Sensitive [value redacted]')),
              # FIXME: This is obviously wrong                                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^
              'port' => '5432')
    end
  end

  context 'with specific db connection settings - default port' do
    let :params do
      {
        password_hash: 'new-pa$s',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGUSER' => 'login-user',
                            'PGPASSWORD' => 'login-pass' }
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }

    it 'has create role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
        .with_command(sensitive(%(CREATE ROLE "test" ENCRYPTED PASSWORD 'new-pa$s' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1)))
        .with_sensitive('true')
        .with_unless("SELECT 1 FROM pg_roles WHERE rolname = 'test'")
        .with_port(5432)
        .with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass')
        .that_requires('Service[postgresqld]')
    end

    it 'has alter role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(ALTER ROLE "test" ENCRYPTED PASSWORD 'md5b6f7fcbbabb4befde4588a26c1cfd2fa')), 'sensitive' => 'true',
              'unless' => sensitive(%(SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa')), 'port' => '5432',
              'connect_settings' => { 'PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1',
                                      'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass' })
    end
  end

  context 'with specific db connection settings - including port' do
    let :params do
      {
        password_hash: 'new-pa$s',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT' => '1234',
                            'PGUSER' => 'login-user',
                            'PGPASSWORD' => 'login-pass' }
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }

    it 'has create role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(CREATE ROLE "test" ENCRYPTED PASSWORD 'new-pa$s' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1)),
              'sensitive' => 'true', 'unless' => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
              'connect_settings' => { 'PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1',
                                      'PGPORT' => '1234', 'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass' })
    end

    it 'has alter role for "test" user with password as ****' do
      expect(subject).to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => sensitive(%(ALTER ROLE "test" ENCRYPTED PASSWORD 'md5b6f7fcbbabb4befde4588a26c1cfd2fa')), 'sensitive' => 'true',
              'unless' => sensitive(%(SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa')),
              'connect_settings' => { 'PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1',
                                      'PGPORT' => '1234', 'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass' })
    end
  end

  context 'with update_password set to false' do
    let :params do
      {
        password_hash: 'new-pa$s',
        update_password: false
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it 'does not have alter role for "test" user with password as **** if update_password is false' do
      expect(subject).not_to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
    end
  end

  context 'with ensure set to absent' do
    let :params do
      {
        ensure: 'absent'
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it 'has drop role for "test" user if ensure absent' do
      expect(subject).to contain_postgresql_psql('DROP ROLE "test"').that_requires('Service[postgresqld]')
    end
  end

  context 'without including postgresql::server' do
    it { is_expected.to compile }
    it { is_expected.to contain_postgresql__server__role('test') }
  end

  context 'standalone not managing server' do
    let :params do
      {
        password_hash: 'new-pa$s',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT' => '1234',
                            'PGUSER' => 'login-user',
                            'PGPASSWORD' => 'login-pass' },
        psql_user: 'postgresql',
        psql_group: 'postgresql',
        psql_path: '/usr/bin',
        module_workdir: '/tmp',
        db: 'db'
      }
    end

    let :pre_condition do
      ''
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_class('postgresql::server') }
  end
end
