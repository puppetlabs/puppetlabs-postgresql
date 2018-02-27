require 'spec_helper_acceptance'

describe 'postgresql::server::schema:', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:version) do
    if fact('osfamily') == 'RedHat' && fact('operatingsystemrelease') =~ %r{5}
      '8.1'
    end
  end
  let(:pp) do
    <<-MANIFEST.unindent
      $db = 'schema_test'
      $user = 'psql_schema_tester'
      $password = 'psql_schema_pw'
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

      postgresql::server::schema { $user:
        db      => $db,
        owner   => $user,
        require => Postgresql::Server::Database[$db],
      }
    MANIFEST
  end

  it 'creates a schema for a user' do
    begin
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)

      ## Check that the user can create a table in the database
      psql('--command="create table psql_schema_tester.foo (foo int)" schema_test', 'psql_schema_tester') do |r|
        expect(r.stdout).to match(%r{CREATE TABLE})
        expect(r.stderr).to eq('')
      end
    ensure
      psql('--command="drop table psql_schema_tester.foo" schema_test', 'psql_schema_tester')
    end
  end
end
