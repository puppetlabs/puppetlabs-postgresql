# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::default_privileges' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  context 'with unsupported PostgreSQL version' do
    include_examples 'RedHat 7'

    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables'
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
        object_type: 'TaBlEs'
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }

    it do
      expect(subject).to contain_postgresql_psql('default_privileges:test')
        .with_command('ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "test"')
    end
  end

  context 'invalid object_type' do
    context 'tables' do
      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'wrong_type'
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      it { is_expected.to compile.and_raise_error(%r{parameter 'object_type' expects a match for Pattern}) }
    end
  end

  context 'valid object_type' do
    context 'supported privilege' do
      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'tables'
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_postgresql__server__default_privileges('test') }

      it do
        # rubocop:disable Layout/LineLength
        expect(subject).to contain_postgresql_psql('default_privileges:test')
          .with_command('ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "test"')
          .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da LEFT JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=arwdDxt' = ANY (defaclacl) AND nspname = 'public' and defaclobjtype = 'r')")
        # rubocop:enable Layout/LineLength
      end
    end

    context 'unsupported privilege' do
      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'wrong_privilege',
          object_type: 'tables'
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      it { is_expected.to compile.and_raise_error(%r{Illegal value for \$privilege parameter}) }
    end

    context 'schemas on postgres < 9.6' do
      include_examples 'RedHat 7'

      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'schemas',
          schema: ''
        }
      end

      let :pre_condition do
        "class {'postgresql::server':}"
      end

      it { is_expected.to compile.and_raise_error(%r{Default_privileges is only useable with PostgreSQL >= 9.6}m) }
    end

    context 'schemas on postgres >= 10.0' do
      include_examples 'Debian 11'

      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'schemas',
          schema: ''
        }
      end

      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::globals':
            version => '10.0',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_postgresql__server__default_privileges('test') }

      it do
        # rubocop:disable Layout/LineLength
        expect(subject).to contain_postgresql_psql('default_privileges:test')
          .with_command('ALTER DEFAULT PRIVILEGES GRANT ALL ON SCHEMAS TO "test"')
          .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da LEFT JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=UC' = ANY (defaclacl) AND nspname IS NULL and defaclobjtype = 'n')")
        # rubocop:enable Layout/LineLength
      end
    end

    context 'nested schemas are invalid' do
      include_examples 'Debian 11'

      let :params do
        {
          db: 'test',
          role: 'test',
          privilege: 'all',
          object_type: 'schemas',
          schema: 'public'
        }
      end

      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::globals':
            version => '10.0',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      it { is_expected.to compile.and_raise_error(%r{Cannot alter default schema permissions within a schema}) }
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
                            'DBVERSION' => '9.6' }
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
                            'PGPORT' => '1234' }
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
        port: 5678
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }
    it { is_expected.to contain_postgresql_psql('default_privileges:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.6', 'PGPORT' => '1234').with_port('1234') }
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

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }

    it do
      # rubocop:disable Layout/LineLength
      expect(subject).to contain_postgresql_psql('default_privileges:test')
        .with_command('ALTER DEFAULT PRIVILEGES IN SCHEMA my_schema GRANT ALL ON TABLES TO "test"')
        .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da LEFT JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=arwdDxt' = ANY (defaclacl) AND nspname = 'my_schema' and defaclobjtype = 'r')")
      # rubocop:enable Layout/LineLength
    end
  end

  context 'with unset schema name' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables',
        schema: ''
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }

    it do
      # rubocop:disable Layout/LineLength
      expect(subject).to contain_postgresql_psql('default_privileges:test')
        .with_command('ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO "test"')
        .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da LEFT JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=arwdDxt' = ANY (defaclacl) AND nspname IS NULL and defaclobjtype = 'r')")
      # rubocop:enable Layout/LineLength
    end
  end

  context 'with a role defined' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables'
      }
    end

    let :pre_condition do
      <<-EOS
      class {'postgresql::server':}
      postgresql::server::role { 'test': }
      EOS
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }
    it { is_expected.to contain_postgresql__server__role('test') }

    it do
      expect(subject).to contain_postgresql_psql('default_privileges:test') \
        .that_requires(['Service[postgresqld_instance_main]', 'Postgresql::Server::Role[test]'])
    end
  end

  context 'with a target role' do
    let :params do
      {
        target_role: 'target',
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_type: 'tables'
      }
    end

    let :pre_condition do
      <<-EOS
      class {'postgresql::server':}
      postgresql::server::role { 'target': }
      EOS
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__default_privileges('test') }
    it { is_expected.to contain_postgresql__server__role('target') }

    it do
      # rubocop:disable Layout/LineLength
      expect(subject).to contain_postgresql_psql('default_privileges:test')
        .with_command('ALTER DEFAULT PRIVILEGES FOR ROLE target IN SCHEMA public GRANT ALL ON TABLES TO "test"')
        .with_unless("SELECT 1 WHERE EXISTS (SELECT * FROM pg_default_acl AS da LEFT JOIN pg_namespace AS n ON da.defaclnamespace = n.oid WHERE 'test=arwdDxt/target' = ANY (defaclacl) AND nspname = 'public' and defaclobjtype = 'r')")
      # rubocop:enable Layout/LineLength
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
        connect_settings: { 'DBVERSION' => '9.6' }
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_class('postgresql::server') }
  end
end
