require 'spec_helper_system'

describe 'postgresql_psql:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should run some SQL when the unless query returns no rows' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }

      postgresql_psql { 'foobar':
        db        => 'postgres',
        psql_user => 'postgres',
        command   => 'select 1',
        unless    => 'select 1 where 1=2',
        require   => Class['postgresql::server'],
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 2
    end
  end

  it 'should not run SQL when the unless query returns rows' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }

      postgresql_psql { 'foobar':
        db        => 'postgres',
        psql_user => 'postgres',
        command   => 'select * from pg_database limit 1',
        unless    => 'select 1 where 1=1',
        require   => Class['postgresql::server'],
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end
  end

end
