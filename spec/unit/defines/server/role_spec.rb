require 'spec_helper'

describe 'postgresql::server::role', type: :define do
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('contrib'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  let :params do
    {
      password_hash: 'new-pa$s',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_postgresql__server__role('test') }
  it 'has create role for "test" user with password as ****' do
    is_expected.to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
      .with('command'     => "CREATE ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1",
            'environment' => 'NEWPGPASSWD=new-pa$s',
            'unless'      => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
            'port'        => '5432')
  end
  it 'has alter role for "test" user with password as ****' do
    is_expected.to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
      .with('command'     => "ALTER ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD'",
            'environment' => 'NEWPGPASSWD=new-pa$s',
            'unless'      => "SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa'",
            'port'        => '5432')
  end

  context 'with specific db connection settings - default port' do
    let :params do
      {
        password_hash: 'new-pa$s',
        connect_settings: { 'PGHOST'     => 'postgres-db-server',
                            'DBVERSION'  => '9.1',
                            'PGUSER'     => 'login-user',
                            'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'has create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
        .with_command("CREATE ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1")
        .with_environment('NEWPGPASSWD=new-pa$s')
        .with_unless("SELECT 1 FROM pg_roles WHERE rolname = 'test'")
        .with_port(5432)
        .with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass')
        .that_requires('Class[postgresql::server::service]')
    end
    it 'has alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => "ALTER ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD'", 'environment' => 'NEWPGPASSWD=new-pa$s',
              'unless'  => "SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa'", 'port' => '5432',
              'connect_settings' => { 'PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1',
                                      'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass' })
    end
  end

  context 'with specific db connection settings - including port' do
    let :params do
      {
        password_hash: 'new-pa$s',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION'  => '9.1',
                            'PGPORT'     => '1234',
                            'PGUSER'     => 'login-user',
                            'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'has create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('CREATE ROLE test ENCRYPTED PASSWORD ****')
        .with('command'     => "CREATE ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD' LOGIN NOCREATEROLE NOCREATEDB NOSUPERUSER  CONNECTION LIMIT -1",
              'environment' => 'NEWPGPASSWD=new-pa$s', 'unless' => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
              'connect_settings' => { 'PGHOST'     => 'postgres-db-server', 'DBVERSION' => '9.1',
                                      'PGPORT'     => '1234', 'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass' })
    end
    it 'has alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
        .with('command' => "ALTER ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD'", 'environment' => 'NEWPGPASSWD=new-pa$s',
              'unless'  => "SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa'",
              'connect_settings' => { 'PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1',
                                      'PGPORT' => '1234', 'PGUSER' => 'login-user', 'PGPASSWORD' => 'login-pass' })
    end
  end

  context 'with update_password set to false' do
    let :params do
      {
        password_hash: 'new-pa$s',
        update_password: false,
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it 'does not have alter role for "test" user with password as **** if update_password is false' do
      is_expected.not_to contain_postgresql_psql('ALTER ROLE test ENCRYPTED PASSWORD ****')
    end
  end

  context 'with ensure set to absent' do
    let :params do
      {
        ensure: 'absent',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it 'has drop role for "test" user if ensure absent' do
      is_expected.to contain_postgresql_psql('DROP ROLE "test"').that_requires('Class[postgresql::server::service]')
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
                            'DBVERSION'  => '9.1',
                            'PGPORT'     => '1234',
                            'PGUSER'     => 'login-user',
                            'PGPASSWORD' => 'login-pass' },
        psql_user: 'postgresql',
        psql_group: 'postgresql',
        psql_path: '/usr/bin',
        module_workdir: '/tmp',
        db: 'db',
      }
    end

    let :pre_condition do
      ''
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_class('postgresql::server') }
  end
end
