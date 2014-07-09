require 'spec_helper_acceptance'

# These tests ensure that postgres can change itself to an alternative port
# properly.
describe 'postgres::server', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'on an alternative port' do
    pp = <<-EOS
      class { 'postgresql::server': port => '5433' }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe port(5433) do
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('-p 5433 --command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(/List of databases/)
    end
  end

end



