# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::role' do
  let(:user) { 'foo' }
  let(:password) { 'bar' }

  it 'with different DBVERSION in connect_settings' do
    pp_role = <<-MANIFEST
      $user = '#{user}'
      $password = '#{password}'

      class { 'postgresql::server': }

      postgresql::server::role { $user:
        password_hash    => $password,
        connect_settings => {
          'DBVERSION' => '13',
        },
      }
    MANIFEST

    if Gem::Version.new(postgresql_version) >= Gem::Version.new('14')
      idempotent_apply(pp_role)

      # verify that password_encryption selectio is based on 'DBVERSION' and not on postgresql::serverglobals::version
      psql("--command=\"SELECT 1 FROM pg_shadow WHERE usename = '#{user}' AND passwd = 'md596948aad3fcae80c08a35c9b5958cd89'\"") do |r|
        expect(r.stdout).to match(%r{\(1 row\)})
        expect(r.stderr).to eq('')
      end
    end
  end
end
