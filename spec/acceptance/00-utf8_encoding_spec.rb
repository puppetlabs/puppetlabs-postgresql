require 'spec_helper_acceptance' # rubocop:disable Style/FileName

describe 'postgresql::server', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  pp = <<-MANIFEST
      class { 'postgresql::globals':
        encoding => 'UTF8',
        locale   => 'en_NG',
      } ->
      class { 'postgresql::server': }
  MANIFEST
  it 'with defaults' do
    idempotent_apply(default, pp)
  end

  describe port(5432) do
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('--command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end

  it 'must set UTF8 as template1 encoding' do
    psql('--command="SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname=\'template1\'"') do |r|
      expect(r.stdout).to match(%r{UTF8})
    end
  end
end
