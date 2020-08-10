require 'spec_helper'

describe 'postgresql::server', type: :class do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: {
          full: '8.0',
          major: '8',
        },
      },
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      lsbdistid: 'Debian',
      lsbdistcodename: 'jessie',
      operatingsystemrelease: '8.0',
      concat_basedir: tmpfilename('server'),
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  describe 'with no parameters' do
    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_file('/var/lib/postgresql/9.4/main') }
    it {
      is_expected.to contain_exec('postgresql_reload').with('command' => 'service postgresql reload')
    }
    it 'validates connection' do
      is_expected.to contain_postgresql_conn_validator('validate_service_is_running')
    end
  end

  describe 'service_ensure => running' do
    let(:params) do
      {
        service_ensure: 'running',
        postgres_password: 'new-p@s$word-to-set',
      }
    end

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_class('postgresql::server::passwd') }
    it 'validates connection' do
      is_expected.to contain_postgresql_conn_validator('validate_service_is_running')
    end
    it 'sets postgres password' do
      is_expected.to contain_exec('set_postgres_postgrespw').with('command' => '/usr/bin/psql -c "ALTER ROLE \"postgres\" PASSWORD ${NEWPASSWD_ESCAPED}"',
                                                                  'user'        => 'postgres',
                                                                  'environment' => ['PGPASSWORD=new-p@s$word-to-set', 'PGPORT=5432', 'NEWPASSWD_ESCAPED=$$new-p@s$word-to-set$$'],
                                                                  'unless' => "/usr/bin/psql -h localhost -p 5432 -c 'select 1' > /dev/null")
    end
  end

  describe 'service_ensure => true' do
    let(:params) do
      {
        service_ensure: true,
        postgres_password: 'new-p@s$word-to-set',
      }
    end

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_class('postgresql::server::passwd') }
    it 'validates connection' do
      is_expected.to contain_postgresql_conn_validator('validate_service_is_running')
    end
    it 'sets postgres password' do
      is_expected.to contain_exec('set_postgres_postgrespw').with('command' => '/usr/bin/psql -c "ALTER ROLE \"postgres\" PASSWORD ${NEWPASSWD_ESCAPED}"',
                                                                  'user'        => 'postgres',
                                                                  'environment' => ['PGPASSWORD=new-p@s$word-to-set', 'PGPORT=5432', 'NEWPASSWD_ESCAPED=$$new-p@s$word-to-set$$'],
                                                                  'unless' => "/usr/bin/psql -h localhost -p 5432 -c 'select 1' > /dev/null")
    end
  end

  describe 'service_ensure => stopped' do
    let(:params) { { service_ensure: 'stopped' } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it 'shouldnt validate connection' do
      is_expected.not_to contain_postgresql_conn_validator('validate_service_is_running')
    end
  end

  describe 'service_restart_on_change => false' do
    let(:params) { { service_restart_on_change: false } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it {
      is_expected.not_to contain_Postgresql_conf('data_directory').that_notifies('Class[postgresql::server::service]')
    }
    it 'validates connection' do
      is_expected.to contain_postgresql_conn_validator('validate_service_is_running')
    end
  end

  describe 'service_restart_on_change => true' do
    let(:params) { { service_restart_on_change: true } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it {
      is_expected.to contain_Postgresql_conf('data_directory').that_notifies('Class[postgresql::server::service]')
    }
    it 'validates connection' do
      is_expected.to contain_postgresql_conn_validator('validate_service_is_running')
    end
  end

  describe 'service_reload => /bin/true' do
    let(:params) { { service_reload: '/bin/true' } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it {
      is_expected.to contain_exec('postgresql_reload').with('command' => '/bin/true')
    }
    it 'validates connection' do
      is_expected.to contain_postgresql_conn_validator('validate_service_is_running')
    end
  end

  describe 'service_manage => true' do
    let(:params) { { service_manage: true } }

    it { is_expected.to contain_service('postgresqld') }
  end

  describe 'service_manage => false' do
    let(:params) { { service_manage: false } }

    it { is_expected.not_to contain_service('postgresqld') }
    it 'shouldnt validate connection' do
      is_expected.not_to contain_postgresql_conn_validator('validate_service_is_running')
    end
  end

  describe 'package_ensure => absent' do
    let(:params) do
      {
        package_ensure: 'absent',
      }
    end

    it 'removes the package' do
      is_expected.to contain_package('postgresql-server').with(ensure: 'purged')
    end

    it 'stills enable the service' do
      is_expected.to contain_service('postgresqld').with(ensure: 'running')
    end
  end

  describe 'needs_initdb => true' do
    let(:params) do
      {
        needs_initdb: true,
      }
    end

    it 'contains proper initdb exec' do
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
      is_expected.to contain_file('/var/lib/postgresql/99.5/main') # FIXME: be more precise
      is_expected.to contain_concat('/etc/postgresql/99.5/main/pg_hba.conf') # FIXME: be more precise
      is_expected.to contain_concat('/etc/postgresql/99.5/main/pg_ident.conf') # FIXME: be more precise
    end
  end

  describe 'additional roles' do
    let(:params) do
      {
        roles: {
          username: { createdb: true },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__role('username').with_createdb(true) }
  end

  describe 'additional config_entries' do
    let(:params) do
      {
        config_entries: {
          fsync: 'off',
          checkpoint_segments: '20',
          remove_me: :undef,
        },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__config_entry('fsync').with_value('off').with_ensure('present') }
    it { is_expected.to contain_postgresql__server__config_entry('checkpoint_segments').with_value('20').with_ensure('present') }
    it { is_expected.to contain_postgresql__server__config_entry('remove_me').with_value(nil).with_ensure('absent') }
  end

  describe 'additional pg_hba_rules' do
    let(:params) do
      {
        pg_hba_rules: {
          from_remote_host: {
            type: 'host',
            database: 'mydb',
            user: 'myuser',
            auth_method: 'md5',
            address: '192.0.2.100',
          },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }
    it do
      is_expected.to contain_postgresql__server__pg_hba_rule('from_remote_host')
        .with_type('host')
        .with_database('mydb')
        .with_user('myuser')
        .with_auth_method('md5')
        .with_address('192.0.2.100')
    end
  end
end
