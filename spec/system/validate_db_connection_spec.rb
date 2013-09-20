require 'spec_helper_system'

describe 'postgresql::validate_db_connection:' do
  before :all do
    # Setup postgresql server and a sample database for tests to use.
    pp = <<-EOS.unindent
      $db = 'foo'
      class { 'postgresql::server': }

      postgresql::server::db { $db:
        user     => $db,
        password => postgresql_password($db, $db),
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end
  end

  after :all do
    # Remove postgresql server after all tests have ran.
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should run puppet with no changes declared if db ip connectivity works' do
    pp = <<-EOS.unindent
      postgresql::validate_db_connection { 'foo':
        database_host     => 'localhost',
        database_name     => 'foo',
        database_username => 'foo',
        database_password => 'foo',
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 0
    end
  end

  it 'should fail catalogue if database connectivity fails' do
    pp = <<-EOS.unindent
      postgresql::validate_db_connection { 'foobarbaz':
        database_host     => 'localhost',
        database_name     => 'foobarbaz',
        database_username => 'foobarbaz',
        database_password => 'foobarbaz',
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 4
    end
  end
end
