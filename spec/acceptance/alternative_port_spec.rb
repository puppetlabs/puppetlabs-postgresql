require 'spec_helper_acceptance'

# These tests ensure that postgres can change itself to an alternative port
# properly.
describe 'postgresql::server', unless: UNSUPPORTED_PLATFORMS.include?(os[:family]) do
  it 'on an alternative port' do
    pp = <<-MANIFEST
      class { 'postgresql::server': port => '55433' }
    MANIFEST

    idempotent_apply(default, pp)
  end

  describe port(55433) do # rubocop:disable Style/NumericLiterals
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('-p 55433 --command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end
end
