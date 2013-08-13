require 'spec_helper_system'

describe 'install:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test postgresql::server' do
    pp = <<-EOS
      class { 'postgresql::server': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end

    puppet_apply(pp) do |r|
      r.exit_code.should be_zero
    end
  end

  describe 'postgresql::db' do
    it 'should idempotently create a db that we can connect to' do
      begin
        pp = <<-EOS
          $db = 'postgresql_test_db'
          include postgresql::server

          postgresql::db { $db:
            user        => $db,
            password    => postgresql_password($db, $db),
          }
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

    it 'should take a locale parameter' do
      pending('no support for locale parameter with centos 5', :if => (node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5'))
      begin
        pp = <<-EOS
          class { 'postgresql::server': }
          if($::operatingsystem == 'Debian') {
            # Need to make sure the correct locale is installed first
            file { '/etc/locale.gen':
              content => "en_US ISO-8859-1\nen_NG UTF-8\n",
            }~>
            exec { '/usr/sbin/locale-gen':
              logoutput => true,
              refreshonly => true,
            }
          }
          postgresql::db { 'test1':
            user     => 'test1',
            password => postgresql_password('test1', 'test1'),
            charset => 'UTF8',
            locale => 'en_NG',
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should == 0
        end

        psql('-c "show lc_ctype" test1') do |r|
          r.stdout.should =~ /en_NG/
        end

        psql('-c "show lc_collate" test1') do |r|
          r.stdout.should =~ /en_NG/
        end
      ensure
        psql('--command="drop database test1" postgres')
      end
    end

    it 'should take an istemplate parameter' do
      begin
        pp = <<-EOS
          $db = 'template2'
          include postgresql::server

          postgresql::db { $db:
            user        => $db,
            password    => postgresql_password($db, $db),
            istemplate  => true,
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should == 0
        end

        psql('--command="select datname from pg_database" template2') do |r|
          r.stdout.should =~ /template2/
          r.stderr.should be_empty
          r.exit_code.should == 0
        end
      ensure
        psql('--command="drop database template2" postgres') do |r|
          r.stdout.should be_empty
          r.stderr.should =~ /cannot drop a template database/
          r.exit_code.should_not == 0
        end
      end
    end

    it 'should update istemplate parameter' do
      begin
        pp = <<-EOS
          $db = 'template2'
          include postgresql::server

          postgresql::db { $db:
            user        => $db,
            password    => postgresql_password($db, $db),
            istemplate  => false,
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should == 0
        end

        psql('--command="select datname from pg_database" template2') do |r|
          r.stdout.should =~ /template2/
          r.stderr.should be_empty
          r.exit_code.should == 0
        end
      ensure
        psql('--command="drop database template2" postgres') do |r|
          r.exit_code.should == 0
        end
      end
    end
  end

  describe 'custom postgres password' do
    it 'should install and successfully adjust the password' do
      pp = <<-EOS
        class { "postgresql::server":
          config_hash => {
            'postgres_password'          => 'TPSReports!',
            'ip_mask_deny_postgres_user' => '0.0.0.0/32',
          },
        }
      EOS

      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.stdout.should =~ /\[set_postgres_postgrespw\]\/returns: executed successfully/
      end
      puppet_apply(pp) do |r|
        r.exit_code.should == 0
      end

      pp = <<-EOS
        class { "postgresql::server":
          config_hash => {
            'postgres_password'          => 'TPSR$$eports!',
            'ip_mask_deny_postgres_user' => '0.0.0.0/32',
          },
        }
      EOS

      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.stdout.should =~ /\[set_postgres_postgrespw\]\/returns: executed successfully/
      end
      puppet_apply(pp) do |r|
        r.exit_code.should == 0
      end

    end
  end

  describe 'postgresql::psql' do
    it 'should work but emit a deprecation warning' do
      pp = <<-EOS
        include postgresql::server

        postgresql::psql { 'foobar':
          db       => 'postgres',
          user     => 'postgres',
          command  => 'select * from pg_database limit 1',
          unless   => 'select 1 where 1=1',
          require  => Class['postgresql::server'],
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.stdout.should =~ /postgresql::psql is deprecated/
        r.refresh
        r.exit_code.should == 2
        r.stdout.should =~ /postgresql::psql is deprecated/
      end
    end
  end

  describe 'postgresql_psql' do
    it 'should run some SQL when the unless query returns no rows' do
      pp = <<-EOS
        include postgresql::server

        postgresql_psql { 'foobar':
          db          => 'postgres',
          psql_user   => 'postgres',
          command     => 'select 1',
          unless      => 'select 1 where 1=2',
          require     => Class['postgresql::server'],
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should == 2
      end
    end

    it 'should not run SQL when the unless query returns rows' do
      pp = <<-EOS
        include postgresql::server

        postgresql_psql { 'foobar':
          db          => 'postgres',
          psql_user   => 'postgres',
          command     => 'select * from pg_database limit 1',
          unless      => 'select 1 where 1=1',
          require     => Class['postgresql::server'],
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should == 0
      end
    end
  end

  describe 'postgresql::database_user' do
    it 'should idempotently create a user who can log in' do
      pp = <<-EOS
        $user = "postgresql_test_user"
        $password = "postgresql_test_password"

        include postgresql::server

        # Since we are not testing pg_hba or any of that, make a local user for ident auth
        user { $user:
          ensure => present,
        }

        postgresql::database_user { $user:
          password_hash => postgresql_password($user, $password),
          require  => [ Class['postgresql::server'],
                        User[$user] ],
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
      pp = <<-EOS
        $user = "postgresql_test_user"
        $password = "postgresql_test_password2"

        include postgresql::server

        # Since we are not testing pg_hba or any of that, make a local user for ident auth
        user { $user:
          ensure => present,
        }

        postgresql::database_user { $user:
          password_hash => postgresql_password($user, $password),
          require  => [ Class['postgresql::server'],
                        User[$user] ],
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
      pp = <<-EOS
        $user = "postgresql_test_user2"
        $password = "postgresql_test_password2"

        include postgresql::server

        # Since we are not testing pg_hba or any of that, make a local user for ident auth
        user { $user:
          ensure => present,
        }

        postgresql::database_user { $user:
          password_hash => $password,
          require  => [ Class['postgresql::server'],
                        User[$user] ],
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

  describe 'postgresql::database_grant' do
    it 'should grant access so a user can create in a database' do
      begin
        pp = <<-EOS
          $db = 'postgres'
          $user = 'psql_grant_tester'
          $password = 'psql_grant_pw'

          include postgresql::server

          # Since we are not testing pg_hba or any of that, make a local user for ident auth
          user { $user:
            ensure => present,
          }

          postgresql::database_user { $user:
            password_hash => postgresql_password($user, $password),
            require       => [
              Class['postgresql::server'],
              User[$user],
            ],
          }

          postgresql::database { $db:
            require => Class['postgresql::server'],
          }

          postgresql::database_grant { 'grant create test':
            privilege => 'CREATE',
            db        => $db,
            role      => $user,
            require   => [
              Postgresql::Database[$db],
              Postgresql::Database_user[$user],
            ],
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should == 0
        end

        # Check that the user can create a table in the database
        psql('--command="create table foo (foo int)" postgres', 'psql_grant_tester') do |r|
          r.stdout.should =~ /CREATE TABLE/
          r.stderr.should == ''
          r.exit_code.should == 0
        end
      ensure
        psql('--command="drop table foo" postgres', 'psql_grant_tester')
      end
    end
  end

  describe 'postgresql::table_grant' do
    it 'should grant access so a user can insert in a table' do
      begin
        pp = <<-EOS
          $db = 'table_grant'
          $user = 'psql_table_tester'
          $password = 'psql_table_pw'

          include postgresql::server

          # Since we are not testing pg_hba or any of that, make a local user for ident auth
          user { $user:
            ensure => present,
          }

          postgresql::database_user { $user:
            password_hash => postgresql_password($user, $password),
            require       => [
              Class['postgresql::server'],
              User[$user],
            ],
          }

          postgresql::database { $db:
            require => Class['postgresql::server'],
          }

          postgresql_psql { 'Create testing table':
            command => 'CREATE TABLE "test_table" (field integer NOT NULL)',
            db      => $db,
            unless  => "SELECT * FROM pg_tables WHERE tablename = 'test_table'",
            require => Postgresql::Database[$db],
          }

          postgresql::table_grant { 'grant insert test':
            privilege => 'INSERT',
            table     => 'test_table',
            db        => $db,
            role      => $user,
            require   => [
              Postgresql::Database[$db],
              Postgresql::Database_user[$user],
              Postgresql_psql['Create testing table'],
            ],
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should == 0
        end

        ## Check that the user can create a table in the database
        #psql('--command="create table foo (foo int)" postgres', 'psql_grant_tester') do |r|
        #  r.stdout.should =~ /CREATE TABLE/
        #  r.stderr.should be_empty
        #  r.exit_code.should == 0
        #end
      ensure
        #psql('--command="drop table foo" postgres', 'psql_grant_tester')
      end
    end
  end

  describe 'postgresql::validate_db_connections' do
    it 'should run puppet with no changes declared if database connectivity works' do
      pp = <<-EOS
        $db = 'foo'
        include postgresql::server

        postgresql::db { $db:
          user        => $db,
          password    => postgresql_password($db, $db),
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should == 0
      end

      pp = <<-EOS
        postgresql::validate_db_connection { 'foo':
          database_host => 'localhost',
          database_name => 'foo',
          database_username => 'foo',
          database_password => 'foo',
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 0
      end
    end

    it 'should fail catalogue if database connectivity fails' do
      pp = <<-EOS
        postgresql::validate_db_connection { 'foobarbaz':
          database_host => 'localhost',
          database_name => 'foobarbaz',
          database_username => 'foobarbaz',
          database_password => 'foobarbaz',
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 4
      end
    end
  end

  describe 'postgresql::tablespace' do
    it 'should idempotently create tablespaces and databases that are using them' do
      pp = <<-EOS
        include postgresql::server

        file { '/tmp/pg_tablespaces':
          ensure  => 'directory',
          owner   => 'postgres',
          group   => 'postgres',
          mode    => '0700',
        }~>
        # This works around rubies that lack Selinux support, I'm looking at you RHEL5
        exec { "chcon -u system_u -r object_r -t postgresql_db_t /tmp/pg_tablespaces":
          refreshonly => true,
          path        => "/bin:/usr/bin",
          onlyif      => "which chcon",
          before      => File["/tmp/pg_tablespaces/space1", "/tmp/pg_tablespaces/space2"]
        }

        postgresql::tablespace{ 'tablespace1':
          location => '/tmp/pg_tablespaces/space1',
          require => [Class['postgresql::server'], File['/tmp/pg_tablespaces']],
        }
        postgresql::database{ 'tablespacedb1':
          charset => 'utf8',
          tablespace => 'tablespace1',
          require => Postgresql::Tablespace['tablespace1'],
        }
        postgresql::db{ 'tablespacedb2':
          user => 'dbuser2',
          password => postgresql_password('dbuser2', 'dbuser2'),
          tablespace => 'tablespace1',
          require => Postgresql::Tablespace['tablespace1'],
        }

        postgresql::database_user{ 'spcuser':
          password_hash => postgresql_password('spcuser', 'spcuser'),
          require       => Class['postgresql::server'],
        }
        postgresql::tablespace{ 'tablespace2':
          location => '/tmp/pg_tablespaces/space2',
          owner => 'spcuser',
          require => [Postgresql::Database_user['spcuser'], File['/tmp/pg_tablespaces']],
        }
        postgresql::database{ 'tablespacedb3':
          charset => 'utf8',
          tablespace => 'tablespace2',
          require => Postgresql::Tablespace['tablespace2'],
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

  describe 'postgresql::pg_hba_rule' do
    it 'should create a ruleset in pg_hba.conf' do
      pp = <<-EOS
        include postgresql::server
        postgresql::pg_hba_rule { "allow application network to access app database":
          type => "host",
          database => "app",
          user => "app",
          address => "200.1.2.0/24",
          auth_method => md5,
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
      end

      puppet_apply(pp) do |r|
        r.exit_code.should be_zero
      end

      shell("grep '200.1.2.0/24' /etc/postgresql/*/*/pg_hba.conf || grep '200.1.2.0/24' /var/lib/pgsql/data/pg_hba.conf") do |r|
        r.exit_code.should be_zero
      end
    end

    it 'should create a ruleset in pg_hba.conf that denies db access to db test1' do
      pp = <<-EOS
        include postgresql::server
        postgresql::db { "test1":
          user => "test1",
          password => postgresql_password('test1', 'test1'),
          grant => "all",
        }
        postgresql::pg_hba_rule { "allow anyone to have access to db test1":
          type => "local",
          database => "test1",
          user => "test1",
          auth_method => reject,
          order => '001',
        }
        user { "test1":
          shell => "/bin/bash",
          managehome => true,
        }
      EOS
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
      end

      shell('su - test1 -c \'psql -U test1 -c "\q" test1\'') do |r|
        r.exit_code.should == 2
      end
    end
  end

  describe 'postgresql.conf include' do
    it "should support an 'include' directive at the end of postgresql.conf" do
      pending('no support for include directive with centos 5/postgresql 8.1', :if => (node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5'))
      pp = <<-EOS
        class pg_test {
          class { 'postgresql::server': }

          $pg_conf_include_file = "${postgresql::params::confdir}/postgresql_puppet_extras.conf"

          file { $pg_conf_include_file :
            content => 'max_connections = 123',
            notify => Service['postgresqld'],
          }
        }
        class { 'pg_test': }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end

      psql('--command="show max_connections" -t') do |r|
        r.stdout.should =~ /123/
        r.stderr.should == ''
        r.exit_code.should == 0
      end

      pp = <<-EOS
        class cleanup {
          require postgresql::params

          $pg_conf_include_file = "${postgresql::params::confdir}/postgresql_puppet_extras.conf"

          file { $pg_conf_include_file :
            ensure => absent
          }
        }
        class { 'cleanup': }
      EOS
      puppet_apply(pp)
    end
  end
end
