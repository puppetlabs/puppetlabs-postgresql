# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server' do
  let(:pp) do
    ENV['RSPEC_DEBUG'] = 'yes'
    <<-MANIFEST
      class { 'postgresql::globals':
        encoding => 'UTF8',
        locale   => 'en_NG',
      } ->
      class { 'postgresql::server': }
    MANIFEST
  end

  it 'with defaults' do
    export_locales('en_NG.UTF8')
    idempotent_apply(pp, debug: true)
    puts '-------------------------------'
    puts LitmusHelper.instance.run_shell('ss -lntp').stdout
    puts '-------------------------------'
    puts LitmusHelper.instance.run_shell('journalctl -u postgresql').stdout
    puts '-------------------------------'
    puts LitmusHelper.instance.run_shell('systemctl status postgresql*').stdout
    puts '-------------------------------'
    puts LitmusHelper.instance.run_shell("su postgres -c 'psql -c \\\\l'").stdout
    puts '-------------------------------'
    puts LitmusHelper.instance.run_shell('true &>/dev/null </dev/tcp/127.0.0.1/5432 && echo open || echo closed').stdout
    puts '-------------------------------'
    expect(port(5432)).to be_listening.on('127.0.0.1').with('tcp')
    expect(psql('--command="\l" postgres', 'postgres').stdout).to match(%r{List of databases})
    expect(psql('--command="SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname=\'template1\'"').stdout).to match(%r{UTF8})
  end
end
