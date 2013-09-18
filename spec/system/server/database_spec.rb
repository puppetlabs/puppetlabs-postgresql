require 'spec_helper_system'

describe 'postgresql::server::database:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should idempotently create a db that we can connect to' do
    begin
      pp = <<-EOS.unindent
        $db = 'postgresql_test_db'
        class { 'postgresql::server': }

        postgresql::server::database { $db: }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should == 0
      end

      psql('--command="select datname from pg_database" postgresql_test_db') do |r|
        r.stdout.should =~ /postgresql_test_db/
        r.stderr.should be_empty
        r.exit_code.should == 0
      end
    ensure
      psql('--command="drop database postgresql_test_db" postgres')
    end
  end
end
