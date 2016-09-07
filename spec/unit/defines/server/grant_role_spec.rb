require 'spec_helper'

describe 'postgresql::server::grant_role', :type => :define do
  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  let :facts do
    {:osfamily => 'Debian',
     :operatingsystem => 'Debian',
     :operatingsystemrelease => '6.0',
     :kernel => 'Linux', :concat_basedir => tmpfilename('postgis'),
     :id => 'root',
     :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let (:title) { 'test' }

  let (:params) { {
    :group => 'my_group',
    :role  => 'my_role',
  } }

  context "with mandatory arguments only" do
    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").with({
        :command => "GRANT \"#{params[:group]}\" TO \"#{params[:role]}\"",
        :unless  => "SELECT t.count FROM (SELECT count(*) FROM pg_user AS u JOIN pg_auth_members AS am ON (u.usesysid = am.member) JOIN pg_roles AS r ON (r.oid = am.roleid) WHERE r.rolname = '#{params[:group]}' AND u.usename = '#{params[:role]}') AS t WHERE t.count = 1",
      }).that_requires('Class[postgresql::server]')
    }
  end

  context "validation" do
    context "group invalid type" do
      let (:params) { {
        :group => ['a', 'b'],
        :role  => 'r',
      } }

      it {
        expect { catalogue }.to raise_error(Puppet::Error, /is not a string/)
      }
    end

    context "role invalid type" do
      let (:params) { {
          :group => 'g',
          :role  => true,
      } }

      it {
        expect { catalogue }.to raise_error(Puppet::Error, /is not a string/)
      }
    end

    context "group empty" do
      let (:params) { {
          :group => '',
          :role  => 'r',
      } }

      it {
        expect { catalogue }.to raise_error(/\$group must be set/)
      }
    end

    context "role empty" do
      let (:params) { {
          :group => 'g',
          :role  => :undef,
      } }

      it {
        expect { catalogue }.to raise_error(/\$role must be set/)
      }
    end
  end

  context "with db arguments" do
    let (:params) { super().merge({
      :psql_db   => 'postgres',
      :psql_user => 'postgres',
      :port      => '5432',
    }) }

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").with({
        :command => "GRANT \"#{params[:group]}\" TO \"#{params[:role]}\"",
        :unless    => "SELECT t.count FROM (SELECT count(*) FROM pg_user AS u JOIN pg_auth_members AS am ON (u.usesysid = am.member) JOIN pg_roles AS r ON (r.oid = am.roleid) WHERE r.rolname = '#{params[:group]}' AND u.usename = '#{params[:role]}') AS t WHERE t.count = 1",
        :db        => params[:psql_db],
        :psql_user => params[:psql_user],
        :port      => params[:port],
      }).that_requires('Class[postgresql::server]')
    }
  end

  context "with ensure => absent" do
    let (:params) { super().merge({
      :ensure   => 'absent',
    }) }

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").with({
        :command => "REVOKE \"#{params[:group]}\" FROM \"#{params[:role]}\"",
        :unless  => "SELECT t.count FROM (SELECT count(*) FROM pg_user AS u JOIN pg_auth_members AS am ON (u.usesysid = am.member) JOIN pg_roles AS r ON (r.oid = am.roleid) WHERE r.rolname = '#{params[:group]}' AND u.usename = '#{params[:role]}') AS t WHERE t.count != 1",
      }).that_requires('Class[postgresql::server]')
    }
  end

  context "with ensure => invalid" do
    let (:params) { super().merge({
      :ensure   => 'invalid',
    }) }

    it {
      expect { catalogue }.to raise_error(Puppet::Error, /Unknown value for ensure/)
    }
  end

  context "with user defined" do
    let :pre_condition do
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

  context "with group defined" do
    let :pre_condition do
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

  context "with connect_settings" do
    let (:params) { super().merge({
      :connect_settings => { 'PGHOST' => 'postgres-db-server' },
    }) }

    it {
      is_expected.to contain_postgresql_psql("grant_role:#{title}").with_connect_settings( { 'PGHOST' => 'postgres-db-server' } )
    }
    it {
      is_expected.not_to contain_postgresql_psql("grant_role:#{title}").that_requires('Class[postgresql::server]')
    }
  end
end
