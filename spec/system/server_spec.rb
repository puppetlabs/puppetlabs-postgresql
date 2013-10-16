require 'spec_helper_system'

describe 'server:' do
  after :all do
    # Cleanup after tests have ran
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
      r.refresh
      r.exit_code.should == 0
    end
  end

  describe port(5432) do
    it { should be_listening }
  end

  describe 'setting postgres password' do
    it 'should install and successfully adjust the password' do
      pp = <<-EOS.unindent
        class { 'postgresql::server':
          postgres_password          => 'foobarbaz',
          ip_mask_deny_postgres_user => '0.0.0.0/32',
        }
      EOS

      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.stdout.should =~ /\[set_postgres_postgrespw\]\/returns: executed successfully/
        r.refresh
        r.exit_code.should == 0
      end

      pp = <<-EOS.unindent
        class { 'postgresql::server':
          postgres_password          => 'TPSR$$eports!',
          ip_mask_deny_postgres_user => '0.0.0.0/32',
        }
      EOS

      puppet_apply(pp) do |r|
        [0,2].should include(r.exit_code)
        r.stdout.should =~ /\[set_postgres_postgrespw\]\/returns: executed successfully/
        r.refresh
        r.exit_code.should == 0
      end

    end
  end
end

describe 'server without defaults:' do
  before :all do
    puppet_apply(<<-EOS.unindent)
      if($::operatingsystem =~ /Debian|Ubuntu/) {
        # Need to make sure the correct utf8 locale is ready for our
        # non-standard tests
        file { '/etc/locale.gen':
          content => "en_US ISO-8859-1\nen_NG UTF-8\nen_US UTF-8\n",
        }~>
        exec { '/usr/sbin/locale-gen':
          logoutput => true,
          refreshonly => true,
        }
      }
    EOS
  end

  context 'test installing non-default version of postgresql' do
    after :all do
      psql('--command="drop database postgresql_test_db" postgres')
      pp = <<-EOS.unindent
        class { 'postgresql::globals':
          ensure              => absent,
          manage_package_repo => true,
          version             => '9.3',
        }
        class { 'postgresql::server':
          ensure => absent,
        }
      EOS
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
      end
    end

    it 'perform installation and create a db' do
      pp = <<-EOS.unindent
        class { "postgresql::globals":
          version             => "9.3",
          manage_package_repo => true,
          encoding            => 'UTF8',
          locale              => 'en_US.UTF-8',
        }
        class { "postgresql::server": }
        postgresql::server::db { "postgresql_test_db":
          user     => "foo1",
          password => postgresql_password('foo1', 'foo1'),
        }
        postgresql::server::config_entry { 'port':
          value => '5432',
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should == 0
      end

      psql('postgresql_test_db --command="select datname from pg_database limit 1"') do |r|
        r.exit_code.should == 0
      end
    end

    describe port(5432) do
      it { should be_listening }
    end
  end

  unless ((node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5') ||
    node.facts['osfamily'] == 'Debian')

    context 'override locale and encoding' do
      after :each do
        puppet_apply "class { 'postgresql::server': ensure => absent }" do |r|
          r.exit_code.should_not == 1
        end
      end

      it 'perform installation with different locale and encoding' do
        pp = <<-EOS.unindent
          class { 'postgresql::server':
            locale   => 'en_NG',
            encoding => 'UTF8',
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should == 2
          r.refresh
          r.exit_code.should == 0
        end

        # Remove db first, if it exists for some reason
        shell('su postgres -c "dropdb test1"')
        shell('su postgres -c "createdb test1"')
        shell('su postgres -c \'psql -c "show lc_ctype" test1\'') do |r|
          r.stdout.should =~ /en_NG/
        end

        shell('su postgres -c \'psql -c "show lc_collate" test1\'') do |r|
          r.stdout.should =~ /en_NG/
        end
      end
    end
  end
end

describe 'server with firewall:' do
  after :all do
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  context 'test installing postgresql with firewall management on' do
    it 'perform installation and make sure it is idempotent' do
      pending('no support for firewall with fedora', :if => (node.facts['operatingsystem'] == 'Fedora'))
      pp = <<-EOS.unindent
        class { 'firewall': }
        class { "postgresql::server":
          manage_firewall => true,
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should == 0
      end
    end
  end
end

describe 'server without pg_hba.conf:' do
  after :all do
    puppet_apply("class { 'postgresql::server': ensure => absent }") do |r|
      r.exit_code.should_not == 1
    end
  end

  context 'test installing postgresql without pg_hba.conf management on' do
    it 'perform installation and make sure it is idempotent' do
      pp = <<-EOS.unindent
        class { "postgresql::server":
          manage_pg_hba_conf => false,
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should == 0
      end
    end
  end
end
