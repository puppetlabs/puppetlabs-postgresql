require 'spec_helper'

describe 'postgresql::server::role', :type => :define do

  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  context 'standalone' do

    let :params do
      {
        :password_hash => 'new-pa$s',
      }
    end
  
    let :pre_condition do
     "class {'postgresql::server':}"
    end
  
    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD' NOCREATEROLE NOCREATEDB LOGIN NOSUPERUSER  CONNECTION LIMIT -1",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
        'port'        => "5432",
      })
    end
    it 'should have alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: ALTER ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "ALTER ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD'",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa'",
        'port'        => "5432",
      })
    end
  end

  context 'passwordless' do

    let :params do
      {}
    end
  
    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end
  
    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE ROLE \"test\"  NOCREATEROLE NOCREATEDB LOGIN NOSUPERUSER  CONNECTION LIMIT -1",
        'environment' => [],
        'unless'      => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
        'port'        => "5432",
      })
    end
  end

  context "with specific db connection settings - default port" do
    let :params do
      {
        :password_hash => 'new-pa$s',
        :connect_settings => { 'PGHOST'     => 'postgres-db-server',
                               'DBVERSION'  => '9.1',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD' NOCREATEROLE NOCREATEDB LOGIN NOSUPERUSER  CONNECTION LIMIT -1",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
        'port'        => "5432",

        'connect_settings' => { 'PGHOST'     => 'postgres-db-server',
                                'DBVERSION'  => '9.1',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
    it 'should have alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: ALTER ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "ALTER ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD'",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa'",
        'port'        => "5432",

        'connect_settings' => { 'PGHOST'     => 'postgres-db-server',
                                'DBVERSION'  => '9.1',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
  end

  context "with specific db connection settings - including port" do
    let :params do
      {
        :password_hash => 'new-pa$s',
        :connect_settings => { 'PGHOST'     => 'postgres-db-server',
                               'DBVERSION'  => '9.1',
                               'PGPORT'     => '1234',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD' NOCREATEROLE NOCREATEDB LOGIN NOSUPERUSER  CONNECTION LIMIT -1",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_roles WHERE rolname = 'test'",
        'connect_settings' => { 'PGHOST'     => 'postgres-db-server',
                                'DBVERSION'  => '9.1',
                                'PGPORT'     => '1234',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
    it 'should have alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: ALTER ROLE test ENCRYPTED PASSWORD ****').with({
        'command'     => "ALTER ROLE \"test\" ENCRYPTED PASSWORD '$NEWPGPASSWD'",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_shadow WHERE usename = 'test' AND passwd = 'md5b6f7fcbbabb4befde4588a26c1cfd2fa'",
        'connect_settings' => { 'PGHOST'     => 'postgres-db-server',
                                'DBVERSION'  => '9.1',
                                'PGPORT'     => '1234',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
  end

  context 'with update_password set to false' do
    let :params do
      {
        :password_hash => 'new-pa$s',
        :update_password => false,
        :connect_settings => { 'PGHOST'     => 'postgres-db-server',
                               'DBVERSION'  => '9.1',
                               'PGPORT'     => '1234',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'postgres'}"
    end

    it 'should not have alter role for "test" user with password as **** if update_password is false' do
      is_expected.not_to contain_postgresql_psql('test: ALTER ROLE test ENCRYPTED PASSWORD ****')
    end
  end

  context "drop role" do
    let :params do
      {
        :connect_settings => { 'PGHOST'     => 'postgres-db-server',
                               'DBVERSION'  => '9.1',
                               'PGPORT'     => '1234',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
        :ensure => 'absent',
      }
    end

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have drop role for "test" user' do
      is_expected.to contain_postgresql_psql('test: DROP ROLE test').with({
        'command'     => "DROP ROLE \"test\"",
        'environment' => ["rp_env"],
        'unless'      => "SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'test')",
        'connect_settings' => { 'PGHOST'     => 'postgres-db-server',
                                'DBVERSION'  => '9.1',
                                'PGPORT'     => '1234',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
  end

  context 'standalone (redshift)' do

    let :params do
      {
        :password_hash => 'new-pa$s',
      }
    end
  
    let :pre_condition do
     "class {'postgresql::server': dialect => 'redshift'}"
    end
  
    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE USER \"test\" PASSWORD '$NEWPGPASSWD' NOCREATEUSER NOCREATEDB CONNECTION LIMIT UNLIMITED",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_user_info WHERE usename = 'test'",
        'port'        => "5432",
      })
    end
    it 'should have alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: ALTER USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "ALTER USER \"test\" PASSWORD '$NEWPGPASSWD'",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'port'        => "5432",
      })
    end
  end

  context 'passwordless (redshift)' do

    let :params do
      {}
    end
  
    let :pre_condition do
     "class {'postgresql::server': dialect => 'redshift'}"
    end
  
    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE USER \"test\" PASSWORD DISABLE NOCREATEUSER NOCREATEDB CONNECTION LIMIT UNLIMITED",
        'environment' => [],
        'unless'      => "SELECT 1 FROM pg_user_info WHERE usename = 'test'",
        'port'        => "5432",
      })
    end
  end

  context "with specific db connection settings - default port (redshift)" do
    let :params do
      {
        :password_hash => 'new-pa$s',
        :connect_settings => { 'PGHOST'     => 'redshift-db-server',
                               'DBVERSION'  => '9.1',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
     "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE USER \"test\" PASSWORD '$NEWPGPASSWD' NOCREATEUSER NOCREATEDB CONNECTION LIMIT UNLIMITED",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_user_info WHERE usename = 'test'",
        'port'        => "5432",

        'connect_settings' => { 'PGHOST'     => 'redshift-db-server',
                                'DBVERSION'  => '9.1',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
    it 'should have alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: ALTER USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "ALTER USER \"test\" PASSWORD '$NEWPGPASSWD'",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'port'        => "5432",

        'connect_settings' => { 'PGHOST'     => 'redshift-db-server',
                                'DBVERSION'  => '9.1',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
  end

  context "with specific db connection settings - including port (redshift)" do
    let :params do
      {
        :password_hash => 'new-pa$s',
        :connect_settings => { 'PGHOST'     => 'redshift-db-server',
                               'DBVERSION'  => '9.1',
                               'PGPORT'     => '1234',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
      }
    end

    let :pre_condition do
     "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have create role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: CREATE USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "CREATE USER \"test\" PASSWORD '$NEWPGPASSWD' NOCREATEUSER NOCREATEDB CONNECTION LIMIT UNLIMITED",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'unless'      => "SELECT 1 FROM pg_user_info WHERE usename = 'test'",
        'connect_settings' => { 'PGHOST'     => 'redshift-db-server',
                                'DBVERSION'  => '9.1',
                                'PGPORT'     => '1234',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
    it 'should have alter role for "test" user with password as ****' do
      is_expected.to contain_postgresql_psql('test: ALTER USER test ENCRYPTED PASSWORD ****').with({
        'command'     => "ALTER USER \"test\" PASSWORD '$NEWPGPASSWD'",
        'environment' => "NEWPGPASSWD=new-pa$s",
        'connect_settings' => { 'PGHOST'     => 'redshift-db-server',
                                'DBVERSION'  => '9.1',
                                'PGPORT'     => '1234',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
  end

  context "drop user (redshift)" do
    let :params do
      {
        :connect_settings => { 'PGHOST'     => 'redshift-db-server',
                               'DBVERSION'  => '9.1',
                               'PGPORT'     => '1234',
                               'PGUSER'     => 'login-user',
                               'PGPASSWORD' => 'login-pass' },
        :ensure => 'absent',
      }
    end

    let :pre_condition do
     "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__role('test') }
    it 'should have drop role for "test" user' do
      is_expected.to contain_postgresql_psql('test: DROP USER test').with({
        'command'     => "DROP USER \"test\"",
        'environment' => ["rp_env"],
        'unless'      => "SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM pg_user_info WHERE usename = 'test')",
        'connect_settings' => { 'PGHOST'     => 'redshift-db-server',
                                'DBVERSION'  => '9.1',
                                'PGPORT'     => '1234',
                                'PGUSER'     => 'login-user',
                                'PGPASSWORD' => 'login-pass' },
      })
    end
  end
end
