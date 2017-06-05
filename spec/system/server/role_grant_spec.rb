require 'spec_helper_system'

describe 'postgresql::server::role_grant:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should grant access so a user can create in a database' do
    begin
      pp = <<-EOS.unindent
        $db          = 'postgres'
        $parent_role = 'psql_grant_tester_parent'
        $child_role  = 'psql_grant_tester_child'
        $password    = 'psql_grant_pw'

        class { 'postgresql::server': }

        # Since we are not testing pg_hba or any of that, make a local user for ident auth
        user { $user:
          ensure => present,
        }

        postgresql::server::role { $user:
          password_hash => postgresql_password($user, $password),
        }

        postgresql::server::database { $db: }

        postgresql::server::grant { 'grant create testparent':
          object_type => 'database',
          privilege   => 'CREATE',
          db          => $db,
          role        => $parent_role,
        }

        postgresql::server::role_grant { 'grant child_role to parent_role':
          role         => $parent_role,
          user         => $child_role,
          admin_option => true,
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should == 0
      end

      # Check that the user can create a table in the database
      psql('--command="create table foo (foo int)" postgres', 'psql_grant_tester_child') do |r|
        r.stdout.should =~ /CREATE TABLE/
        r.stderr.should == ''
        r.exit_code.should == 0
      end
    ensure
      psql('--command="drop table foo" postgres', 'psql_grant_tester')
    end
  end
end
