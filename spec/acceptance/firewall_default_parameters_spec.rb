require 'spec_helper_acceptance'

# These tests are designed to ensure that the module with firewall enabled,
# when ran with defaults, sets up everything correctly and allows us to connect
# to Postgres.
describe 'postgres::server with firewall', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'with defaults' do
    pp = <<-EOS
      class { 'firewall': } ->
      class { 'postgresql::server':
        manage_firewall => true,
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe port(5432) do
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('--command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(/List of databases/)
    end
  end

end



