require 'spec_helper_system'

describe 'postgresql::server::role:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should idempotently create a user who can log in' do
    pp = <<-EOS.unindent
      $user = "postgresql_test_user"
      $password = "postgresql_test_password"

      class { 'postgresql::server': }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $user:
        ensure => present,
      }

      postgresql::server::role { $user:
        password_hash => postgresql_password($user, $password),
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end

    # Check that the user can log in
    psql('--command="select datname from pg_database" postgres', 'postgresql_test_user') do |r|
      r.stdout.should =~ /template1/
      r.stderr.should == ''
      r.exit_code.should == 0
    end
  end

  it 'should idempotently alter a user who can log in' do
    pp = <<-EOS.unindent
      $user = "postgresql_test_user"
      $password = "postgresql_test_password2"

      class { 'postgresql::server': }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $user:
        ensure => present,
      }

      postgresql::server::role { $user:
        password_hash => postgresql_password($user, $password),
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end

    # Check that the user can log in
    psql('--command="select datname from pg_database" postgres', 'postgresql_test_user') do |r|
      r.stdout.should =~ /template1/
      r.stderr.should == ''
      r.exit_code.should == 0
    end
  end

  it 'should idempotently create a user with a cleartext password' do
    pp = <<-EOS.unindent
      $user = "postgresql_test_user2"
      $password = "postgresql_test_password2"

      class { 'postgresql::server': }

      # Since we are not testing pg_hba or any of that, make a local user for ident auth
      user { $user:
        ensure => present,
      }

      postgresql::server::role { $user:
        password_hash => $password,
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end

    # Check that the user can log in
    psql('--command="select datname from pg_database" postgres', 'postgresql_test_user2') do |r|
      r.stdout.should =~ /template1/
      r.stderr.should == ''
      r.exit_code.should == 0
    end
  end
end
