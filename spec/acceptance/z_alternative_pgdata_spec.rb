require 'spec_helper_acceptance'

# These tests ensure that postgres can change itself to an alternative pgdata
# location properly.

describe 'postgresql::server' do
  before(:each) do
    if os[:family] == 'sles'
      skip "These test's currently do not work on SLES/Suse modules"
    end
  end

  it 'on an alternative pgdata location' do
    pp = <<-MAIFEST
      #file { '/var/lib/pgsql': ensure => directory, } ->
      # needs_initdb will be true by default for all OS's except Debian
      # in order to change the datadir we need to tell it explicitly to call initdb
      class { 'postgresql::server': datadir => '/tmp/data', needs_initdb => true }
    MAIFEST

    idempotent_apply(pp)
  end

  describe file('/tmp/data') do
    it { is_expected.to be_directory }
  end

  it 'can connect with psql' do
    psql('--command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end
end
