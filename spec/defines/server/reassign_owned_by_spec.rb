# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::reassign_owned_by' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  let :params do
    {
      db: 'test',
      old_role: 'test_old_role',
      new_role: 'test_new_role'
    }
  end

  let :pre_condition do
    <<-MANIFEST
      class {'postgresql::server':}
      postgresql::server::role{ ['test_old_role','test_new_role']: }
    MANIFEST
  end

  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_postgresql__server__reassign_owned_by('test') }

  it {
    expect(subject).to contain_postgresql_psql('reassign_owned_by:test:REASSIGN OWNED BY "test_old_role" TO "test_new_role"')
      .with_command('REASSIGN OWNED BY "test_old_role" TO "test_new_role"')
      .with_onlyif(%r{SELECT tablename FROM pg_catalog.pg_tables WHERE\s*schemaname NOT IN \('pg_catalog', 'information_schema'\) AND\s*tableowner = 'test_old_role'.*}m)
      .that_requires('Service[postgresqld_instance_main]')
  }
end
