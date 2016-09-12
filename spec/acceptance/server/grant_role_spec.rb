require 'spec_helper_acceptance'

describe 'postgresql::server::grant_role:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'should grant a role to a user' do
    begin
      pp = <<-EOS.unindent
        $db = 'grant_role_test'
        $user = 'psql_grant_role_tester'
        $group = 'test_group'
        $password = 'psql_grant_role_pw'

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

        # Create a rule for the user
        postgresql::server::pg_hba_rule { "allow ${user}":
          type        => 'local',
          database    => $db,
          user        => $user,
          auth_method => 'ident',
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
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)

      ## Check that the role was granted to the user
      psql('--command="SELECT 1 WHERE pg_has_role(\'psql_grant_role_tester\', \'test_group\', \'MEMBER\') = true" grant_role_test', 'psql_grant_role_tester') do |r|
        expect(r.stdout).to match(/\(1 row\)/)
        expect(r.stderr).to eq('')
      end
    end
  end

end
