require 'spec_helper_acceptance'

describe 'postgresql::server::grant_role:', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:db) { 'grant_role_test' }
  let(:user) { 'psql_grant_role_tester' }
  let(:group) { 'test_group' }
  let(:password) { 'psql_grant_role_pw' }
  let(:version) do
    if fact('osfamily') == 'RedHat' && fact('operatingsystemrelease') =~ %r{5}
      '8.1'
    end
  end
  let(:pp_one) do
    <<-MANIFEST.unindent
      $db = #{db}
      $user = #{user}
      $group = #{group}
      $password = #{password}
      $version = '#{version}'

      class { 'postgresql::server': }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $user:
        ensure => present,
      }

      postgresql::server::role { $user:
        password_hash => postgresql_password($user, $password),
      }

      postgresql::server::database { $db:
        owner   => $user,
        require => Postgresql::Server::Role[$user],
      }

      # Lets setup the base rules
      $local_auth_option = $version ? {
        '8.1'   => 'sameuser',
        default => undef,
      }

      # Create a rule for the user
      postgresql::server::pg_hba_rule { "allow ${user}":
        type        => 'local',
        database    => $db,
        user        => $user,
        auth_method => 'ident',
        auth_option => $local_auth_option,
        order       => 1,
      }

      # Create a role to grant to the user
      postgresql::server::role { $group:
        db      => $db,
        login   => false,
        require => Postgresql::Server::Database[$db],
      }

      # Grant the role to the user
      postgresql::server::grant_role { "grant_role ${group} to ${user}":
        role  => $user,
        group => $group,
      }
    MANIFEST
  end
  let(:pp_two) do
    <<-MANIFEST.unindent
      $db = #{db}
      $user = #{user}
      $group = #{group}
      $password = #{password}
      $version = '#{version}'

      class { 'postgresql::server': }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $user:
        ensure => present,
      }

      postgresql::server::role { $user:
        password_hash => postgresql_password($user, $password),
      }

      postgresql::server::database { $db:
        owner   => $user,
        require => Postgresql::Server::Role[$user],
      }

      # Lets setup the base rules
      $local_auth_option = $version ? {
        '8.1'   => 'sameuser',
        default => undef,
      }

      # Create a rule for the user
      postgresql::server::pg_hba_rule { "allow ${user}":
        type        => 'local',
        database    => $db,
        user        => $user,
        auth_method => 'ident',
        auth_option => $local_auth_option,
        order       => 1,
      }

      # Create a role to grant to the user
      postgresql::server::role { $group:
        db      => $db,
        login   => false,
        require => Postgresql::Server::Database[$db],
      }

      # Grant the role to the user
      postgresql::server::grant_role { "grant_role ${group} to ${user}":
        role  => $user,
        group => $group,
      }
    MANIFEST
  end
  let(:pp_three) do
    <<-MANIFEST
      $db = "#{db}"
      $user = "#{user}"
      $group = "#{group}"
      $password = #{password}
      $version = '#{version}'

      class { 'postgresql::server': }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $user:
        ensure => present,
      }

      postgresql::server::role { $user:
        password_hash => postgresql_password($user, $password),
      }

      postgresql::server::database { $db:
        owner   => $user,
        require => Postgresql::Server::Role[$user],
      }

      # Lets setup the base rules
      $local_auth_option = $version ? {
        '8.1'   => 'sameuser',
        default => undef,
      }

      # Create a rule for the user
      postgresql::server::pg_hba_rule { "allow ${user}":
        type        => 'local',
        database    => $db,
        user        => $user,
        auth_method => 'ident',
        auth_option => $local_auth_option,
        order       => 1,
      }

      # Create a role to grant to the user
      postgresql::server::role { $group:
        db      => $db,
        login   => false,
        require => Postgresql::Server::Database[$db],
      }

      # Grant the role to the user
      postgresql::server::grant_role { "grant_role ${group} to ${user}":
        role  => $user,
        group => $group,
      }

      postgresql::server::grant_role {"revoke ${group} from ${user}":
        ensure => absent,
        role   => $user,
        group  => $group,
      }
    MANIFEST
  end
  let(:pp_four) do
    <<-MANIFEST
       $db = "#{db}"
       $user = "#{user}"
       $group = "#{group}"
       $password = #{password}

       class { 'postgresql::server': }

       # Since we are not testing pg_hba or any of that, make a local user for ident auth
         user { $user:
         ensure => absent,
       }

       postgresql::server::database { $db:
       }

       # Create a role to grant to the nonexistent user
       postgresql::server::role { $group:
         db      => $db,
         login   => false,
         require => Postgresql::Server::Database[$db],
       }

       # Grant the role to the nonexistent user
       postgresql::server::grant_role { "grant_role ${group} to ${user}":
         role  => $user
         group => $group,
       }
    MANIFEST
  end

  it 'grants a role to a user' do
    begin
      apply_manifest(pp_one, catch_failures: true)
      apply_manifest(pp_one, catch_changes: true)

      ## Check that the role was granted to the user
      psql('--command="SELECT 1 WHERE pg_has_role(\'psql_grant_role_tester\', \'test_group\', \'MEMBER\') = true" grant_role_test', 'psql_grant_role_tester') do |r|
        expect(r.stdout).to match(%r{\(1 row\)})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'grants a role to a superuser' do
    begin
      apply_manifest(pp_two, catch_failures: true)
      apply_manifest(pp_two, catch_changes: true)

      ## Check that the role was granted to the user
      psql('--command="SELECT 1 FROM pg_roles AS r_role JOIN pg_auth_members AS am ON r_role.oid = am.member JOIN pg_roles AS r_group ON r_group.oid = am.roleid WHERE r_group.rolname = \'test_group\' AND r_role.rolname = \'psql_grant_role_tester\'" grant_role_test', 'psql_grant_role_tester') do |r| # rubocop:disable Metrics/LineLength
        expect(r.stdout).to match(%r{\(1 row\)})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'revokes a role from a user' do
    begin
      apply_manifest(pp_three, catch_failures: true)
      apply_manifest(pp_three, expect_changes: true)

      psql('--command="SELECT 1 WHERE pg_has_role(\'psql_grant_role_tester\', \'test_group\', \'MEMBER\') = true" grant_role_test', 'psql_grant_role_tester') do |r|
        expect(r.stdout).to match(%r{\(0 rows\)})
        expect(r.stderr).to eq('')
      end
    end
  end

  it 'does not grant permission to a nonexistent user' do
    begin
      apply_manifest(pp_four, expect_failures: true)

      psql('--command="SELECT 1 WHERE pg_has_role(\'psql_grant_role_tester\', \'test_group\', \'MEMBER\') = true" grant_role_test', 'psql_grant_role_tester') do |r|
        expect(r.stdout).to match(%r{\(0 rows\)})
        expect(r.stderr).to eq('')
      end
    end
  end
end
