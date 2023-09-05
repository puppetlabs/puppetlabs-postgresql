# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::database' do
  include_examples 'Debian 11'
  let :title do
    'test'
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_postgresql__server__database('test') }
  it { is_expected.to contain_postgresql_psql('CREATE DATABASE "test"').that_requires('Service[postgresqld_instance_main]') }

  context "with comment set to 'test comment'" do
    let(:params) { { comment: 'test comment' } }

    it { is_expected.to contain_postgresql_psql("COMMENT ON DATABASE \"test\" IS 'test comment'").with_connect_settings({}) }
  end

  context 'with specific db connection settings - default port' do
    let :pre_condition do
      "class {'postgresql::server':}"
    end

    let(:params) do
      { connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1' } }
    end

    it { is_expected.to contain_postgresql_psql('CREATE DATABASE "test"').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1').with_port(5432) }
  end

  context 'with specific db connection settings - including port' do
    let :pre_condition do
      "class {'postgresql::globals':}

       class {'postgresql::server':}"
    end

    let(:params) do
      { connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT' => '1234' } }
    end

    it { is_expected.to contain_postgresql_psql('CREATE DATABASE "test"').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGPORT' => '1234').with_port(1234) }
  end

  context 'with global db connection settings - including port' do
    let :pre_condition do
      "class {'postgresql::globals':
           default_connect_settings => { 'PGHOST'    => 'postgres-db-server',
                                         'DBVERSION' => '9.2',
                                         'PGPORT'    => '1234' }
       }

       class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql_psql('CREATE DATABASE "test"').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.2', 'PGPORT' => '1234').with_port(1234) }
  end

  context 'with different owner' do
    let(:params) { { owner: 'test_owner' } }

    it { is_expected.to contain_postgresql_psql('ALTER DATABASE "test" OWNER TO "test_owner"') }
  end
end
