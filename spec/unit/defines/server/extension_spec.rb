require 'spec_helper'

describe 'postgresql::server::extension', type: :define do # rubocop:disable RSpec/MultipleDescribes
  let :pre_condition do
    "class { 'postgresql::server': }
     postgresql::server::database { 'template_postgis':
       template   => 'template1',
     }"
  end

  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('postgis'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let(:title) { 'postgis' }
  let(:params) do
    {
      database: 'template_postgis',
    }
  end

  context 'with mandatory arguments only' do
    it {
      is_expected.to contain_postgresql_psql('template_postgis: CREATE EXTENSION "postgis"')
        .with(db: 'template_postgis', command: 'CREATE EXTENSION "postgis"').that_requires('Postgresql::Server::Database[template_postgis]')
    }
  end

  context 'when schema is specified' do
    let(:params) do
      super().merge(schema: 'pg_catalog')
    end

    it {
      is_expected.to contain_postgresql_psql('template_postgis: ALTER EXTENSION "postgis" SET SCHEMA "pg_catalog"')
    }
  end

  context 'when setting package name' do
    let(:params) do
      super().merge(package_name: 'postgis')
    end

    it {
      is_expected.to contain_package('postgis')
        .with(ensure: 'present', name: 'postgis').that_comes_before('Postgresql_psql[template_postgis: CREATE EXTENSION "postgis"]')
    }
  end

  context 'when ensuring absence' do
    let(:params) do
      super().merge(ensure: 'absent',
                    package_name: 'postgis')
    end

    it {
      is_expected.to contain_postgresql_psql('template_postgis: DROP EXTENSION "postgis"')
        .with(db: 'template_postgis', command: 'DROP EXTENSION "postgis"').that_requires('Postgresql::Server::Database[template_postgis]')
    }

    it {
      is_expected.to contain_package('postgis').with(ensure: 'absent',
                                                     name: 'postgis')
    }

    context 'when keeping package installed' do
      let(:params) do
        super().merge(package_ensure: 'present')
      end

      it {
        is_expected.to contain_postgresql_psql('template_postgis: DROP EXTENSION "postgis"')
          .with(db: 'template_postgis', command: 'DROP EXTENSION "postgis"').that_requires('Postgresql::Server::Database[template_postgis]')
      }

      it {
        is_expected.to contain_package('postgis')
          .with(ensure: 'present', name: 'postgis').that_requires('Postgresql_psql[template_postgis: DROP EXTENSION "postgis"]')
      }
    end
  end

  context 'when extension version is specified' do
    let(:params) do
      super().merge(ensure: 'absent',
                    package_name: 'postgis',
                    version: '99.99.99')
    end

    it {
      is_expected.to contain_postgresql_psql('template_postgis: ALTER EXTENSION "postgis" UPDATE TO \'99.99.99\'')
        .with(db: 'template_postgis', unless: "SELECT 1 FROM pg_extension WHERE extname='postgis' AND extversion='99.99.99'").that_requires('Postgresql::Server::Database[template_postgis]')
    }
  end

  context 'when extension version is latest' do
    let(:params) do
      super().merge(ensure: 'absent',
                    package_name: 'postgis',
                    version: 'latest')
    end

    it {
      is_expected.to contain_postgresql_psql('template_postgis: ALTER EXTENSION "postgis" UPDATE')
        .with(db: 'template_postgis',
              unless: "SELECT 1 FROM pg_available_extensions WHERE name = 'postgis' AND default_version = installed_version").that_requires('Postgresql::Server::Database[template_postgis]')
    }
  end
end

describe 'postgresql::server::extension', type: :define do
  let :pre_condition do
    "class { 'postgresql::server': }
     postgresql::server::database { 'template_postgis2':
       template   => 'template1',
     }"
  end

  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '6.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('postgis'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let(:title) { 'postgis_db2' }
  let(:params) do
    {
      database: 'template_postgis2',
      extension: 'postgis',
    }
  end

  it { is_expected.to contain_file('/var/lib/postgresql/8.4/main') } # FIXME: be more precise
  it { is_expected.to contain_concat('/etc/postgresql/8.4/main/pg_hba.conf') } # FIXME: be more precise
  it { is_expected.to contain_concat('/etc/postgresql/8.4/main/pg_ident.conf') } # FIXME: be more precise

  context 'with mandatory arguments only' do
    it {
      is_expected.to contain_postgresql_psql('template_postgis2: CREATE EXTENSION "postgis"')
        .with(db: 'template_postgis2', command: 'CREATE EXTENSION "postgis"').that_requires('Postgresql::Server::Database[template_postgis2]')
    }
  end
end

describe 'postgresql::server::extension', type: :define do
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '6.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('postgis'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let(:title) { 'pg_repack' }
  let(:params) do
    {
      database: 'postgres',
      extension: 'pg_repack',
    }
  end

  context 'without including postgresql::server' do
    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it {
      is_expected.to contain_postgresql_psql('postgres: CREATE EXTENSION "pg_repack"')
        .with(db: 'postgres', command: 'CREATE EXTENSION "pg_repack"')
    }
  end

  context 'default port' do
    let :params do
      {
        database: 'postgres',
        extension: 'pg_repack',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql_psql('postgres: CREATE EXTENSION "pg_repack"').with_port('5432') }
  end

  context 'port overriden by explicit parameter' do
    let :params do
      {
        database: 'postgres',
        extension: 'pg_repack',
        port: 1234,
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql_psql('postgres: CREATE EXTENSION "pg_repack"').with_port('1234') }
  end

  context 'with specific db connection settings' do
    let :params do
      {
        database: 'postgres',
        extension: 'pg_repack',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT' => '1234' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_postgresql_psql('postgres: CREATE EXTENSION "pg_repack"')
        .with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGPORT' => '1234')
        .with_port(nil)
    }
  end

  context 'with specific db connection settings - port overriden by explicit parameter' do
    let :params do
      {
        database: 'postgres',
        extension: 'pg_repack',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT' => '1234' },
        port: 5678,
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it {
      is_expected.to contain_postgresql_psql('postgres: CREATE EXTENSION "pg_repack"')
        .with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGPORT' => '1234')
        .with_port('5678')
    }
  end
end
