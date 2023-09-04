# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::db' do
  include_examples 'Debian 11'

  let :title do
    'testdb'
  end
  let :pre_condition do
    "class {'postgresql::server':}"
  end

  context 'with minimal params' do
    let :params do
      {
        user: 'foo'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__db('testdb').without_port.with_user('foo').with_psql_user('postgres').with_psql_group('postgres') }
    it { is_expected.to contain_postgresql__server__database('testdb').without_owner.with_user('postgres').with_group('postgres') }
    it { is_expected.to contain_postgresql__server__role('foo').that_comes_before('Postgresql::Server::Database[testdb]').with_port(5432).with_psql_user('postgres').with_psql_group('postgres') }
    it { is_expected.to contain_postgresql__server__database_grant('GRANT foo - ALL - testdb').with_port(5432).with_psql_user('postgres').with_psql_group('postgres') }
  end

  context 'without dbname param' do
    let :params do
      {
        user: 'test',
        password: 'test',
        owner: 'tester'
      }
    end

    it { is_expected.to contain_postgresql__server__db('testdb') }
    it { is_expected.to contain_postgresql__server__database('testdb').with_owner('tester') }
    it { is_expected.to contain_postgresql__server__role('test').that_comes_before('Postgresql::Server::Database[testdb]') }
    it { is_expected.to contain_postgresql__server__database_grant('GRANT test - ALL - testdb') }
  end

  context 'dbname' do
    let :params do
      {
        dbname: 'testtest',
        user: 'test',
        password: 'test',
        owner: 'tester'
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__database('testtest') }
  end
end
