require 'spec_helper_system'

describe 'postgresql::server::db' do
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

        postgresql::server::db { $db:
          user     => $db,
          password => postgresql_password($db, $db),
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
      pp = <<-EOS.unindent
        class { 'postgresql::server': }
        if($::operatingsystem == 'Debian') {
          # Need to make sure the correct locale is installed first
          file { '/etc/locale.gen':
            content => "en_US ISO-8859-1\nen_NG UTF-8\n",
          }~>
          exec { '/usr/sbin/locale-gen':
            logoutput   => true,
            refreshonly => true,
          }
        }
        postgresql::server::db { 'test1':
          user     => 'test1',
          password => postgresql_password('test1', 'test1'),
          encoding => 'UTF8',
          locale   => 'en_NG',
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
      pp = <<-EOS.unindent
        $db = 'template2'
        class { 'postgresql::server': }

        postgresql::server::db { $db:
          user       => $db,
          password   => postgresql_password($db, $db),
          istemplate => true,
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
      pp = <<-EOS.unindent
        $db = 'template2'
        class { 'postgresql::server': }

        postgresql::server::db { $db:
          user       => $db,
          password   => postgresql_password($db, $db),
          istemplate => false,
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
