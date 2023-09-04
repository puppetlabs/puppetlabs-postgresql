# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server' do
  include_examples 'Debian 11'

  describe 'with no parameters' do
    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_file('/var/lib/postgresql/13/main') }

    it {
      expect(subject).to contain_exec('postgresql_reload_main').with('command' => 'systemctl reload postgresql')
    }

    it 'validates connection' do
      expect(subject).to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end
  end

  describe 'with manage_dnf_module true' do
    include_examples 'RedHat 8'

    let(:pre_condition) do
      <<-PUPPET
      class { 'postgresql::globals':
        manage_dnf_module => true,
      }
      PUPPET
    end

    it { is_expected.to contain_package('postgresql dnf module').with_ensure('10').that_comes_before('Package[postgresql-server]') }
    it { is_expected.to contain_package('postgresql-server').with_name('postgresql-server') }

    describe 'with version set' do
      let(:pre_condition) do
        <<-PUPPET
        class { 'postgresql::globals':
          manage_dnf_module => true,
          version           => '12',
        }
        PUPPET
      end

      it { is_expected.to contain_package('postgresql dnf module').with_ensure('12').that_comes_before('Package[postgresql-server]') }
      it { is_expected.to contain_package('postgresql-server').with_name('postgresql-server') }
    end
  end

  describe 'service_ensure => running' do
    let(:params) do
      {
        service_ensure: 'running',
        postgres_password: 'new-p@s$word-to-set'
      }
    end

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_class('postgresql::server::passwd') }

    it 'validates connection' do
      expect(subject).to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end

    it 'sets postgres password' do
      expect(subject).to contain_exec('set_postgres_postgrespw_main').with('command' => '/usr/bin/psql -c "ALTER ROLE \"postgres\" PASSWORD ${NEWPASSWD_ESCAPED}"',
                                                                           'user' => 'postgres',
                                                                           'environment' => ['PGPASSWORD=new-p@s$word-to-set', 'PGPORT=5432', 'NEWPASSWD_ESCAPED=$$new-p@s$word-to-set$$'],
                                                                           'unless' => "/usr/bin/psql -h localhost -p 5432 -c 'select 1' > /dev/null")
    end
  end

  describe 'service_ensure => true' do
    let(:params) do
      {
        service_ensure: true,
        postgres_password: 'new-p@s$word-to-set'
      }
    end

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_class('postgresql::server::passwd') }

    it 'validates connection' do
      expect(subject).to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end

    it 'sets postgres password' do
      expect(subject).to contain_exec('set_postgres_postgrespw_main').with('command' => ['/usr/bin/psql -c "ALTER ROLE \"postgres\" PASSWORD ${NEWPASSWD_ESCAPED}"'],
                                                                           'user' => 'postgres',
                                                                           'environment' => ['PGPASSWORD=new-p@s$word-to-set', 'PGPORT=5432', 'NEWPASSWD_ESCAPED=$$new-p@s$word-to-set$$'],
                                                                           'unless' => "/usr/bin/psql -h localhost -p 5432 -c 'select 1' > /dev/null")
    end
  end

  describe 'service_ensure => stopped' do
    let(:params) { { service_ensure: 'stopped' } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }

    it 'shouldnt validate connection' do
      expect(subject).not_to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end
  end

  describe 'service_restart_on_change => false' do
    let(:params) { { service_restart_on_change: false } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }

    it {
      expect(subject).not_to contain_Postgresql_conf('data_directory_for_instance_main').that_notifies('Class[postgresql::server::service]')
    }

    it 'validates connection' do
      expect(subject).to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end
  end

  describe 'service_restart_on_change => true' do
    let(:params) { { service_restart_on_change: true } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }

    it {
      expect(subject).to contain_Postgresql_conf('data_directory_for_instance_main').that_notifies('Class[postgresql::server::service]')
    }

    it { is_expected.to contain_postgresql__server__config_entry('data_directory_for_instance_main') }

    it 'validates connection' do
      expect(subject).to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end
  end

  describe 'service_reload => /bin/true' do
    let(:params) { { service_reload: '/bin/true' } }

    it { is_expected.to contain_class('postgresql::params') }
    it { is_expected.to contain_class('postgresql::server') }

    it {
      expect(subject).to contain_exec('postgresql_reload_main').with('command' => '/bin/true')
    }

    it 'validates connection' do
      expect(subject).to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end
  end

  describe 'service_manage => true' do
    let(:params) { { service_manage: true } }

    it { is_expected.to contain_service('postgresqld_instance_main') }
  end

  describe 'service_manage => false' do
    let(:params) { { service_manage: false } }

    it { is_expected.not_to contain_service('postgresqld_instance_main') }

    it 'shouldnt validate connection' do
      expect(subject).not_to contain_postgresql_conn_validator('validate_service_is_running_instance_main')
    end
  end

  describe 'package_ensure => absent' do
    let(:params) do
      {
        package_ensure: 'absent'
      }
    end

    it 'removes the package' do
      expect(subject).to contain_package('postgresql-server').with(ensure: 'purged')
    end

    it 'stills enable the service' do
      expect(subject).to contain_service('postgresqld_instance_main').with(ensure: 'running')
    end
  end

  describe 'needs_initdb => true' do
    let(:params) do
      {
        needs_initdb: true
      }
    end

    it 'contains proper initdb exec' do
      expect(subject).to contain_exec('postgresql_initdb_instance_main')
    end
  end

  describe 'postgresql_version' do
    let(:pre_condition) do
      <<-EOS
      class { 'postgresql::globals':
        manage_package_repo => true,
        version             => '14',
        before              => Class['postgresql::server'],
      }
      EOS
    end

    it 'contains the correct package version' do
      expect(subject).to contain_class('postgresql::repo').with_version('14')
      expect(subject).to contain_file('/var/lib/postgresql/14/main') # FIXME: be more precise
      expect(subject).to contain_concat('/etc/postgresql/14/main/pg_hba.conf') # FIXME: be more precise
      expect(subject).to contain_concat('/etc/postgresql/14/main/pg_ident.conf') # FIXME: be more precise
    end
  end

  describe 'additional roles' do
    let(:params) do
      {
        roles: {
          username: { createdb: true }
        }
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
          remove_me: :undef
        }
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
            address: '192.0.2.100'
          }
        }
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      expect(subject).to contain_postgresql__server__pg_hba_rule('from_remote_host')
        .with_type('host')
        .with_database('mydb')
        .with_user('myuser')
        .with_auth_method('md5')
        .with_address('192.0.2.100')
    end
  end

  describe 'backup_enable => false' do
    let(:params) { { backup_enable: false } }

    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.not_to contain_class('postgresql::backup::pg_dump') }
    it { is_expected.not_to contain_file('/root/.pgpass') }
    it { is_expected.not_to contain_file('/usr/local/sbin/pg_dump.sh') }
    it { is_expected.not_to contain_cron('pg_dump backup job') }
  end

  describe 'backup_enable => true' do
    let(:params) do
      {
        backup_enable: true,
        backup_provider: 'pg_dump',
        backup_options: {
          db_user: 'backupuser',
          db_password: 'backuppass',
          dir: '/tmp/backuptest',
          manage_user: true
        }
      }
    end

    it { is_expected.to contain_class('postgresql::server') }
    it { is_expected.to contain_class('postgresql::backup::pg_dump') }

    it {
      expect(subject).to contain_postgresql__server__role('backupuser')
        .with_superuser(true)
    }

    it {
      expect(subject).to contain_postgresql__server__pg_hba_rule('local access as backup user')
        .with_type('local')
        .with_database('all')
        .with_user('backupuser')
        .with_auth_method('md5')
    }

    it {
      expect(subject).to contain_file('/root/.pgpass')
        .with_content(%r{.*:backupuser:.*})
    }

    it {
      expect(subject).to contain_file('/usr/local/sbin/pg_dump.sh')
        .with_content(%r{.*pg_dumpall \$_pg_args --file=\$\{FILE\} \$@.*})
    }

    it {
      expect(subject).to contain_cron('pg_dump backup job')
        .with(
          ensure: 'present',
          command: '/usr/local/sbin/pg_dump.sh',
          user: 'root',
          hour: '23',
          minute: '5',
          weekday: '*',
        )
    }
  end
end
