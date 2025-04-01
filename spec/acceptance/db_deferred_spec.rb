# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::db:' do
  let(:user) { 'user_test' }
  let(:password) { 'deferred_password_test' }
  let(:database) { 'test_database' }

  let(:pp_one) do
    <<-MANIFEST.unindent
      $user = #{user}
      $password = #{password}
      $database = #{database}

      include postgresql::server
      postgresql::server::db { $database:
         user     => $user,
         password => Deferred('unwrap', [$password]),
      }
    MANIFEST
  end

  it 'creates a database with with the password in the deferred function' do
    if run_shell('puppet --version').stdout[0].to_i < 7
      skip # Deferred function fixes only in puppet 7, see https://tickets.puppetlabs.com/browse/PUP-11518
    end
    apply_manifest(pp_one)
    psql_cmd = "PGPASSWORD=#{password} PGUSER=#{user} PGDATABASE=#{database} psql -h 127.0.0.1 -d postgres -c '\\q'"
    run_shell("cd /tmp; su #{shellescape('postgres')} -c #{shellescape(psql_cmd)}",
              acceptable_exit_codes: [0])
  end
end
