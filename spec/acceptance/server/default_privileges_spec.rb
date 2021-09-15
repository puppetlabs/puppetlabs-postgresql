# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::default_privileges:' do
  let(:db) { 'grant_role_test' }
  let(:user) { 'psql_grant_role_tester' }
  let(:group) { 'test_group' }
  let(:password) { 'psql_grant_role_pw' }

  # Check that the default privileges were revoked
  let(:check_command) do
    "SELECT * FROM pg_default_acl a LEFT JOIN pg_namespace b ON a.defaclnamespace = b.oid WHERE '#{user}=arwdDxt' = ANY (defaclacl) AND nspname = 'public' and defaclobjtype = 'r';"
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

  let(:target_user) { 'target_role_user' }
  let(:target_password) { 'target_role_password' }

  let(:target_check_command) do
    "SELECT 1 FROM pg_default_acl a LEFT JOIN pg_namespace AS b ON a.defaclnamespace = b.oid WHERE '#{user}=arwdDxt/#{target_user}' = ANY (defaclacl) AND nspname = 'public' AND defaclobjtype = 'r';"
  end

  let(:pp_target_role) do
    <<-MANIFEST.unindent
      $db = #{db}
      $user = #{user}
      $group = #{group}
      $password = #{password}
      $target_user = #{target_user}
      $target_password = #{target_password}

      user {$user:
        ensure => present,
      }
      postgresql::server::database_grant { "allow connect for ${user}":
        privilege => 'CONNECT',
        db        => $db,
        role      => $user,
      }

      class { 'postgresql::server': }

      postgresql::server::role { $user:
        password_hash => postgresql::postgresql_password($user, $password),
      }

      postgresql::server::role { $target_user:
        password_hash => postgresql::postgresql_password($target_user, $target_password),
      }

      postgresql::server::database { $db:
        require => Postgresql::Server::Role[$user],
      }

      # Set default privileges on tables
      postgresql::server::default_privileges { "alter default privileges grant all on tables to ${user}":
        db          => $db,
        role        => $user,
        target_role => $target_user,
        psql_user   => 'postgres',
        privilege   => 'ALL',
        object_type => 'TABLES',
        require     => Postgresql::Server::Database[$db],
      }
    MANIFEST
  end

  let(:pp_target_role_revoke) do
    <<-MANIFEST.unindent
      $db = #{db}
      $user = #{user}
      $group = #{group}
      $password = #{password}
      $target_user = #{target_user}
      $target_password = #{target_password}

      user {$user:
        ensure => present,
      }
      postgresql::server::database_grant { "allow connect for ${user}":
        privilege => 'CONNECT',
        db        => $db,
        role      => $user,
      }


      class { 'postgresql::server': }

      postgresql::server::role { $user:
        password_hash => postgresql::postgresql_password($user, $password),
      }

      postgresql::server::role { $target_user:
        password_hash => postgresql::postgresql_password($target_user, $target_password),
      }

      postgresql::server::database { $db:
        require => Postgresql::Server::Role[$user],
      }

      # Set default privileges on tables
      postgresql::server::default_privileges { "alter default privileges grant all on tables to ${user}":
        db          => $db,
        role        => $user,
        target_role => $target_user,
        psql_user   => 'postgres',
        privilege   => 'ALL',
        object_type => 'TABLES',
        ensure      => 'absent',
        require     => Postgresql::Server::Database[$db],
      }
    MANIFEST
  end

  let(:all_schemas_check_command) do
    "SELECT * FROM pg_default_acl a WHERE '#{user}=arwdDxt' = ANY (defaclacl) AND defaclnamespace = 0 and defaclobjtype = 'r';"
  end

  let(:pp_unset_schema) do
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
        schema      => '',
        require     => Postgresql::Server::Database[$db],
      }
    MANIFEST
  end
  let(:pp_unset_schema_revoke) do
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
        schema      => '',
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

  it 'grants default privileges to a user on a specific target role' do
    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      idempotent_apply(pp_target_role)

      psql("--command=\"SET client_min_messages = 'error'; #{target_check_command}\" --db=#{db}", user) do |r|
        expect(r.stdout).to match(%r{^\(1 row\)$})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'revokes default privileges from a user on a specific target role' do
    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      idempotent_apply(pp_target_role)
      idempotent_apply(pp_target_role_revoke)

      psql("--command=\"SET client_min_messages = 'error'; #{target_check_command}\" --db=#{db}", user) do |r|
        expect(r.stdout).to match(%r{^\(0 rows\)$})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'grants default privileges on all schemas to a user' do
    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      idempotent_apply(pp_unset_schema)

      psql("--command=\"SET client_min_messages = 'error';#{all_schemas_check_command}\" --db=#{db}") do |r|
        expect(r.stdout).to match(%r{\(1 row\)})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'revokes default privileges on all schemas for a user' do
    if Gem::Version.new(postgresql_version) >= Gem::Version.new('9.6')
      apply_manifest(pp_unset_schema, catch_failures: true)
      apply_manifest(pp_unset_schema_revoke, expect_changes: true)

      psql("--command=\"SET client_min_messages = 'error';#{all_schemas_check_command}\" --db=#{db}") do |r|
        expect(r.stdout).to match(%r{\(0 rows\)})
        expect(r.stderr).to eq('')
      end
    end
  end
end
