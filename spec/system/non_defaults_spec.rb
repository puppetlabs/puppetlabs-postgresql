require 'spec_helper_system'

describe 'non defaults:' do
  before :all do
    puppet_apply(<<-EOS)
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
    after :each do
      # Cleanup
      psql('--command="drop database postgresql_test_db" postgres')
      pp = <<-EOS
        class { "postgresql":
          version              => "9.2",
          manage_package_repo  => true,
        }->
        class { 'postgresql::server':
          ensure => absent,
          service_status => 'service postgresql-9.2 status',
        }
      EOS
      puppet_apply(pp)
    end

    it 'perform installation and create a db' do
      pp = <<-EOS
        # Configure version and manage_package_repo globally, install postgres
        # and then try to install a new database.
        class { "postgresql":
          version              => "9.2",
          manage_package_repo  => true,
          charset              => 'UTF8',
          locale               => 'en_US.UTF-8',
        }->
        class { "postgresql::server": }->
        postgresql::db { "postgresql_test_db":
          user        => "foo1",
          password    => postgresql_password('foo1', 'foo1'),
        }->
        class { "postgresql::plperl": }
      EOS

      puppet_apply(pp) do |r|
        # Currently puppetlabs/apt shows deprecated messages
        #r.stderr.should be_empty
        [2,6].should include(r.exit_code)

        r.refresh

        # Currently puppetlabs/apt shows deprecated messages
        #r.stderr.should be_empty
        # It also returns a 4
        [0,4].should include(r.exit_code)
      end

      psql('postgresql_test_db --command="select datname from pg_database limit 1"')
    end
  end

  context 'override locale and charset' do
    it 'perform installation with different locale and charset' do
      puts node.facts.inspect
      pending('no support for locale parameter with centos 5', :if => (node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5'))
      pending('no support for initdb with debian/ubuntu', :if => (node.facts['osfamily'] == 'Debian'))

      # TODO: skip for ubuntu and centos 5
      pp = <<-EOS
        # Set global locale and charset option, and try installing postgres
        class { 'postgresql':
          locale  => 'en_NG',
          charset => 'UTF8',
        }->
        class { 'postgresql::server': }
      EOS

      puppet_apply(pp) do |r|
        # Currently puppetlabs/apt shows deprecated messages
        #r.stderr.should be_empty
        # It also returns a 6
        [2,6].should include(r.exit_code)

        r.refresh

        # Currently puppetlabs/apt shows deprecated messages
        #r.stderr.should be_empty
        # It also returns a 2
        [0,4].should include(r.exit_code)
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
