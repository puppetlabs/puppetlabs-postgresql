require 'spec_helper_system'

describe 'postgresql::server::postgis:' do
  after :all do
    # Cleanup after tests have ran, remove both postgis and server as postgis
    # pulls in the server based packages.
    pp = <<-EOS.unindent
      class { 'postgresql::server':
        ensure => absent,
      }
      class { 'postgresql::server::postgis':
        package_ensure => purged,
      }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should_not == 1
    end
  end

  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }
      class { 'postgresql::server::postgis': }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
      r.refresh
      r.exit_code.should == 0
    end
  end
end
