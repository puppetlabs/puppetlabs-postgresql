# frozen_string_literal: true

require 'spec_helper'
require 'spec_helper_acceptance'

describe 'postgresql::server::default_privileges', type: :define do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '9.0', 'major' => '9' },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  context 'with unsupported PostgreSQL version' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: { 'full' => '8.0', 'major' => '8' },
        },
        kernel: 'Linux',
        id: 'root',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end

    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': }"
    end

    it { is_expected.to compile.and_raise_error(%r{Default_privileges is only useable with PostgreSQL >= 9.6}m) }
  end

  context 'case insensitive object_type and privilege match' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'aLl',
        object_type: 'TaBlEs',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_postgresql__server__default_privileges('test') }
      it do
        is_expected.to contain_postgresql_psql('default_privileges:test')
          .with_command('ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "test"')
      end
    end
  end

  context 'invalid object_type' do
    context 'tables' do
      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'wrong_type',
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
        it { is_expected.to compile.and_raise_error(%r{parameter 'object_type' expects a match for Pattern}) }
      end
    end
  end

  context 'valid object_type' do
    context 'supported privilege' do
      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'tables',
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_postgresql__server__default_privileges('test') }
        it do
          # rubocop:disable Layout/LineLength
          is_expected.to contain_postgresql_psql('default_privileges:test')
            .with_command('ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "test"')
            .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=arwdDxt' = ANY (defaclacl) AND nspname = 'public' and defaclobjtype = 'r')")
          # rubocop:enable Layout/LineLength
        end
      end
    end

    context 'unsupported privilege' do
      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'wrong_privilege',
          object_type: 'tables',
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
        it { is_expected.to compile.and_raise_error(%r{Illegal value for \$privilege parameter}) }
      end
    end
  end

  context 'with specific db connection settings - default port' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.6' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }
    it { is_expected.to contain_postgresql_psql('default_privileges:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.6').with_port(5432) }
  end

  context 'with specific db connection settings - including port' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.6',
                            'PGPORT'    => '1234' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }
    it { is_expected.to contain_postgresql_psql('default_privileges:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.6', 'PGPORT' => '1234') }
  end

  context 'with specific db connection settings - port overriden by explicit parameter' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.6',
                            'PGPORT' => '1234' },
        port: 5678,
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }
    it { is_expected.to contain_postgresql_psql('default_privileges:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.6', 'PGPORT' => '1234').with_port('5678') }
  end

  context 'with specific schema name' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
        schema: 'my_schema'
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_postgresql__server__default_privileges('test') }
      it do
        # rubocop:disable Layout/LineLength
        is_expected.to contain_postgresql_psql('default_privileges:test')
          .with_command('ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT ALL ON TABLES TO "test"')
          .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=arwdDxt' = ANY (defaclacl) AND nspname = 'my_schema' and defaclobjtype = 'r')")
        # rubocop:enable Layout/LineLength
      end
    end
  end

  context 'with a role defined' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
      }
    end

    let :pre_condition do
      <<-EOS
      class {'postgresql::server':}
      postgresql::server::role { 'test': }
      EOS
    end

    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_postgresql__server__default_privileges('test') }
      it { is_expected.to contain_postgresql__server__role('test') }
      it do
        is_expected.to contain_postgresql_psql('default_privileges:test') \
          .that_requires(['Class[postgresql::server::service]', 'Postgresql::Server::Role[test]'])
      end
    end
  end

  context 'standalone not managing server' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'execute',
        object_type: 'functions',
        group: 'postgresql',
        psql_path: '/usr/bin',
        psql_user: 'postgres',
        psql_db: 'db',
        port: 1542,
        connect_settings: { 'DBVERSION' => '9.6' },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_class('postgresql::server') }
  end
end
