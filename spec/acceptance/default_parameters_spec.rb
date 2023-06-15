# frozen_string_literal: true

require 'spec_helper_acceptance'

# These tests are designed to ensure that the module, when ran with defaults,
# sets up everything correctly and allows us to connect to Postgres.
describe 'postgresql::server' do
  before(:all) do
    LitmusHelper.instance.run_shell("cd /tmp; su 'postgres' -c 'pg_ctl stop -D /var/lib/pgsql/data/ -m fast'", acceptable_exit_codes: [0, 1]) unless os[:family].match?(%r{debian|ubuntu})
  end

  it 'with defaults' do
    pp = <<-MANIFEST
      class { 'postgresql::server': }
    MANIFEST

    idempotent_apply(pp)
  end

  describe port(5432) do
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('--command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end
end
