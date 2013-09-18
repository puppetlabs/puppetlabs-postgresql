require 'spec_helper_system'

describe 'common patterns:' do
  describe 'postgresql.conf include pattern' do
    after :all do
      pp = <<-EOS.unindent
        class { 'postgresql::server': ensure => absent }

        file { '/tmp/include.conf':
          ensure => absent
        }
      EOS
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
      end
    end

    it "should support an 'include' directive at the end of postgresql.conf" do
      pending('no support for include directive with centos 5/postgresql 8.1',
        :if => (node.facts['osfamily'] == 'RedHat' and node.facts['lsbmajdistrelease'] == '5'))

      pp = <<-EOS.unindent
        class { 'postgresql::server': }

        $extras = "/etc/postgresql-include.conf"

        file { $extras:
          content => 'max_connections = 123',
          seltype => 'postgresql_db_t',
          seluser => 'system_u',
          notify  => Class['postgresql::server::service'],
        }

        postgresql::server::config_entry { 'include':
          value   => $extras,
          require => File[$extras],
        }
      EOS

      puppet_apply(pp) do |r|
        r.exit_code.should == 2
        r.refresh
        r.exit_code.should == 0
      end

      psql('--command="show max_connections" -t') do |r|
        r.stdout.should =~ /123/
        r.stderr.should == ''
        r.exit_code.should == 0
      end
    end
  end
end
