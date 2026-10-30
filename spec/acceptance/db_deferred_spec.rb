# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::db' do
  let(:password) { 'deferred_password_test' }

  shared_examples 'a database with a deferred password' do |user, database, deferred_password|
    let(:pp) do
      <<~MANIFEST
        $user = '#{user}'
        $password = '#{password}'
        $database = '#{database}'

        include postgresql::server
        postgresql::server::db { $database:
           user     => $user,
           password => #{deferred_password},
        }
      MANIFEST
    end

    it 'creates the database and the role can log in with the resolved password' do
      apply_manifest(pp)
      psql_cmd = "PGPASSWORD=#{password} PGUSER=#{user} PGDATABASE=#{database} psql -h 127.0.0.1 -d postgres -c '\\q'"
      run_shell("cd /tmp; su #{shellescape('postgres')} -c #{shellescape(psql_cmd)}",
                acceptable_exit_codes: [0])
    end
  end

  context 'with a deferred function returning a String' do
    it_behaves_like 'a database with a deferred password', 'user_test', 'test_database', "Deferred('unwrap', [$password])"
  end

  context 'with a deferred function returning a Sensitive, like vault_lookup::lookup' do
    it_behaves_like 'a database with a deferred password', 'user_test_sensitive', 'test_database_sensitive', "Deferred('new', [Sensitive, $password])"
  end
end
