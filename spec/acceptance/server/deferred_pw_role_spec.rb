# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::role:' do
  let(:user) { 'deferred_user_test' }
  let(:password) { 'test_password' }

  let(:pp_one) do
    <<~MANIFEST
      $user = #{user}
      $password = #{password}

      class { 'postgresql::server': }
      $deferred_func = Deferred('new', [String, $password])

      postgresql::server::role { $user:
        password_hash => $deferred_func,
      }
    MANIFEST
  end

  it 'creates a role with the password in the deferred function' do
    if run_shell('puppet --version').stdout[0].to_i < 7
      skip # Deferred function fixes only in puppet 7, see https://tickets.puppetlabs.com/browse/PUP-11518
    end
    apply_manifest(pp_one)
    psql_cmd = "PGPASSWORD=#{password} PGUSER=#{user} psql -h 127.0.0.1 -d postgres -c '\\q'"
    run_shell("cd /tmp; su #{shellescape('postgres')} -c #{shellescape(psql_cmd)}",
              acceptable_exit_codes: [0])
  end
end
