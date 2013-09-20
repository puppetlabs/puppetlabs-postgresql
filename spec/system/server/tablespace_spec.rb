require 'spec_helper_system'

describe 'postgresql::server::tablespace:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'should idempotently create tablespaces and databases that are using them' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }

      file { '/tmp/pg_tablespaces':
        ensure => 'directory',
        owner  => 'postgres',
        group  => 'postgres',
        mode   => '0700',
      }~>
      # This works around rubies that lack Selinux support, I'm looking at you RHEL5
      exec { "chcon -u system_u -r object_r -t postgresql_db_t /tmp/pg_tablespaces":
        refreshonly => true,
        path        => "/bin:/usr/bin",
        onlyif      => "which chcon",
        before      => File["/tmp/pg_tablespaces/space1", "/tmp/pg_tablespaces/space2"]
      }

      postgresql::server::tablespace { 'tablespace1':
        location => '/tmp/pg_tablespaces/space1',
      }
      postgresql::server::database { 'tablespacedb1':
        encoding   => 'utf8',
        tablespace => 'tablespace1',
      }
      postgresql::server::db { 'tablespacedb2':
        user       => 'dbuser2',
        password   => postgresql_password('dbuser2', 'dbuser2'),
        tablespace => 'tablespace1',
      }

      postgresql::server::role { 'spcuser':
        password_hash => postgresql_password('spcuser', 'spcuser'),
      }
      postgresql::server::tablespace { 'tablespace2':
        location => '/tmp/pg_tablespaces/space2',
        owner    => 'spcuser',
      }
      postgresql::server::database { 'tablespacedb3':
        encoding   => 'utf8',
        tablespace => 'tablespace2',
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
      r.refresh
      r.exit_code.should == 0
    end

    # Check that databases use correct tablespaces
    psql('--command="select ts.spcname from pg_database db, pg_tablespace ts where db.dattablespace = ts.oid and db.datname = \'"\'tablespacedb1\'"\'"') do |r|
      r.stdout.should =~ /tablespace1/
      r.stderr.should == ''
      r.exit_code.should == 0
    end

    psql('--command="select ts.spcname from pg_database db, pg_tablespace ts where db.dattablespace = ts.oid and db.datname = \'"\'tablespacedb3\'"\'"') do |r|
      r.stdout.should =~ /tablespace2/
      r.stderr.should == ''
      r.exit_code.should == 0
    end
  end
end
