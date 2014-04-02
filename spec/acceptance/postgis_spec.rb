require 'spec_helper_acceptance'

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

    apply_manifest(pp, :catch_failures => true)
  end

  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
      class { 'postgresql::server': }
      class { 'postgresql::server::postgis': }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end
end
