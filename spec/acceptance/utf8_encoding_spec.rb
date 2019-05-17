require 'spec_helper_acceptance'

describe 'postgresql::server', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  before(:all) do
    install_iproute2
  end
  let(:pp) do
    <<-MANIFEST
      class { 'postgresql::globals':
        encoding => 'UTF8',
        locale   => 'en_NG',
      } ->
      class { 'postgresql::server': }
  MANIFEST
  end

  it 'with defaults' do
    idempotent_apply(pp)
    expect(port(5432)).to be_listening
    expect(psql('--command="\l" postgres', 'postgres').stdout).to match(%r{List of databases})
    expect(psql('--command="SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname=\'template1\'"').stdout).to match(%r{UTF8})
  end
end
