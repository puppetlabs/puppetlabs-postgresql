require 'spec_helper_acceptance'

# These tests ensure that postgres can change itself to an alternative pgdata
# location properly.

# Allow postgresql to use /tmp/* as a datadir
if fact('osfamily') == 'RedHat' && fact('selinux') == 'true'
  shell 'setenforce 0'
end

describe 'postgresql::server', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'on an alternative pgdata location' do
    pp = <<-MAIFEST
      #file { '/var/lib/pgsql': ensure => directory, } ->
      # needs_initdb will be true by default for all OS's except Debian
      # in order to change the datadir we need to tell it explicitly to call initdb
      class { 'postgresql::server': datadir => '/tmp/data', needs_initdb => true }
    MAIFEST

    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
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
