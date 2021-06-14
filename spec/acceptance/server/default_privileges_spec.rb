# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::default_privileges:' do
  let(:db) { 'grant_role_test' }
  let(:user) { 'psql_grant_role_tester' }
  let(:group) { 'test_group' }
  let(:password) { 'psql_grant_role_pw' }

  # Check that the default privileges were revoked
  let(:check_command) do
    "SELECT * FROM pg_default_acl a JOIN pg_namespace b ON a.defaclnamespace = b.oid WHERE '#{user}=arwdDxt' = ANY (defaclacl) AND nspname = 'public' and defaclobjtype = 'r';"
  end

  let(:pp_one) do
    <<-MANIFEST.unindent
      $db = #{db}
      $user = #{user}
      $group = #{group}
      $password = #{password}

      class { 'postgresql::server': }

      postgresql::server::role { $user:
        password_hash => postgresql::postgresql_password($user, $password),
      }

      postgresql::server::database { $db:
        require => Postgresql::Server::Role[$user],
      }

      # Set default privileges on tables
      postgresql::server::default_privileges { "alter default privileges grant all on tables to ${user}":
        db          => $db,
        role        => $user,
        privilege   => 'ALL',
        object_type => 'TABLES',
        require     => Postgresql::Server::Database[$db],
      }
    MANIFEST
  end
  let(:pp_two) do
    <<-MANIFEST
      $db = #{db}
      $user = #{user}
      $group = #{group}
      $password = #{password}

      class { 'postgresql::server': }

      postgresql::server::role { $user:
        password_hash => postgresql::postgresql_password($user, $password),
      }
      postgresql::server::database { $db:
        require => Postgresql::Server::Role[$user],
      }

      # Removes default privileges on tables
      postgresql::server::default_privileges { "alter default privileges revoke all on tables for ${user}":
        db          => $db,
        role        => $user,
        privilege   => 'ALL',
        object_type => 'TABLES',
        ensure      => 'absent',
        require     => Postgresql::Server::Database[$db],
      }
    MANIFEST
  end

  it 'grants default privileges to an user' do
    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      idempotent_apply(pp_one)

      psql("--command=\"SET client_min_messages = 'error';#{check_command}\" --db=#{db}") do |r|
        expect(r.stdout).to match(%r{\(1 row\)})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'revokes default privileges for an user' do
    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      apply_manifest(pp_one, catch_failures: true)
      apply_manifest(pp_two, expect_changes: true)

      psql("--command=\"SET client_min_messages = 'error';#{check_command}\" --db=#{db}") do |r|
        expect(r.stdout).to match(%r{\(0 rows\)})
        expect(r.stderr).to eq('')
      end
    end
  end
end
