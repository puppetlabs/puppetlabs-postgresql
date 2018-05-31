require 'spec_helper'

describe 'postgresql::server::grant_role', type: :define do
  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  let(:facts) do
    { osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      kernel: 'Linux', concat_basedir: tmpfilename('postgis'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' }
  end

  let(:title) { 'test' }

  let(:params) do
    {
      group: 'my_group',
      role: 'my_role',
    }
  end

  context 'with mandatory arguments only' do
    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}")
        .with(command: "GRANT \"#{params[:group]}\" TO \"#{params[:role]}\"",
              unless: "SELECT 1 WHERE EXISTS (SELECT 1 FROM pg_roles AS r_role JOIN pg_auth_members AS am ON r_role.oid = am.member JOIN pg_roles AS r_group ON r_group.oid = am.roleid WHERE r_group.rolname = '#{params[:group]}' AND r_role.rolname = '#{params[:role]}') = true") # rubocop:disable Metrics/LineLength
        .that_requires('Class[postgresql::server]')
    }
  end

  context 'with db arguments' do
    let(:params) do
      super().merge(psql_db: 'postgres',
                    psql_user: 'postgres',
                    port: '5432')
    end

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}")
        .with(command: "GRANT \"#{params[:group]}\" TO \"#{params[:role]}\"",
              unless: "SELECT 1 WHERE EXISTS (SELECT 1 FROM pg_roles AS r_role JOIN pg_auth_members AS am ON r_role.oid = am.member JOIN pg_roles AS r_group ON r_group.oid = am.roleid WHERE r_group.rolname = '#{params[:group]}' AND r_role.rolname = '#{params[:role]}') = true", # rubocop:disable Metrics/LineLength
              db: params[:psql_db], psql_user: params[:psql_user],
              port: params[:port]).that_requires('Class[postgresql::server]')
    }
  end

  context 'with ensure => absent' do
    let(:params) do
      super().merge(ensure: 'absent')
    end

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}")
        .with(command: "REVOKE \"#{params[:group]}\" FROM \"#{params[:role]}\"",
              unless: "SELECT 1 WHERE EXISTS (SELECT 1 FROM pg_roles AS r_role JOIN pg_auth_members AS am ON r_role.oid = am.member JOIN pg_roles AS r_group ON r_group.oid = am.roleid WHERE r_group.rolname = '#{params[:group]}' AND r_role.rolname = '#{params[:role]}') != true") # rubocop:disable Metrics/LineLength
        .that_requires('Class[postgresql::server]')
    }
  end

  context 'with user defined' do
    let(:pre_condition) do
      "class { 'postgresql::server': }
postgresql::server::role { '#{params[:role]}': }"
    end

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").that_requires("Postgresql::Server::Role[#{params[:role]}]")
    }
    it {
      is_expected.not_to contain_postgresql_psql("grant_role:#{title}").that_requires("Postgresql::Server::Role[#{params[:group]}]")
    }
  end

  context 'with group defined' do
    let(:pre_condition) do
      "class { 'postgresql::server': }
postgresql::server::role { '#{params[:group]}': }"
    end

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").that_requires("Postgresql::Server::Role[#{params[:group]}]")
    }
    it {
      is_expected.not_to contain_postgresql_psql("grant_role:#{title}").that_requires("Postgresql::Server::Role[#{params[:role]}]")
    }
  end

  context 'with connect_settings' do
    let(:params) do
      super().merge(connect_settings: { 'PGHOST' => 'postgres-db-server' })
    end

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").with_connect_settings('PGHOST' => 'postgres-db-server')
    }
    it {
      is_expected.not_to contain_postgresql_psql("grant_role:#{title}").that_requires('Class[postgresql::server]')
    }
  end
end
