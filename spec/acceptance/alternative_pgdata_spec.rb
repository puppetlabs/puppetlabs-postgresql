require 'spec_helper_acceptance'

# These tests ensure that postgres can change itself to an alternative pgdata
# location properly.
describe 'postgres::server', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'on an alternative pgdata location' do
    pp = <<-EOS
      class { 'postgresql::server': datadir => '/var/pgsql' }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end
  
  describe "Alternate Directory" do
    File.directory?("/var/pgsql").should be true
  end

  it 'can connect with psql' do
    psql('--command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(/List of databases/)
    end
  end

end
