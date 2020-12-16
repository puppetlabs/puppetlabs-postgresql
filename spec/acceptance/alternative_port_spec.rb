# frozen_string_literal: true

require 'spec_helper_acceptance'

# These tests ensure that postgres can change itself to an alternative port
# properly.
describe 'postgresql::server' do
  it 'on an alternative port' do
    pp = <<-MANIFEST
    class { 'postgresql::server': port => '55433', manage_selinux => true }
  MANIFEST
    if os[:family] == 'redhat' && os[:release].start_with?('8')
      apply_manifest(pp, expect_failures: false)
      # GCP failures on redhat8 IAC-1286 - idempotency failing
      # apply_manifest(pp, catch_changes: true)
    else
      idempotent_apply(pp)
    end
  end

  describe port(55_433) do
    it { is_expected.to be_listening }
  end

  it 'can connect with psql' do
    psql('-p 55433 --command="\l" postgres', 'postgres') do |r|
      expect(r.stdout).to match(%r{List of databases})
    end
  end
end
