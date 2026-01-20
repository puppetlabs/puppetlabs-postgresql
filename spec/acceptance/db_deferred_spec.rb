# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::db' do
  let(:user) { 'user_test' }
  let(:password) { 'deferred_password_test' }
  let(:database) { 'test_database' }

  let(:pp_one) do
    <<~MANIFEST
      $user = '#{user}'
      $password = '#{password}'
      $database = '#{database}'

      include postgresql::server
      postgresql::server::db { $database:
         user     => $user,
         password => Deferred('new', [Sensitive, 'password']),
      }
    MANIFEST
  end

  it 'creates a database with with the password in the deferred function' do
    apply_manifest(pp_one)
    psql_cmd = "PGPASSWORD=#{password} PGUSER=#{user} PGDATABASE=#{database} psql -h 127.0.0.1 -d postgres -c '\\q'"
    run_shell("cd /tmp; su #{shellescape('postgres')} -c #{shellescape(psql_cmd)}",
              acceptable_exit_codes: [0])
  end
end
