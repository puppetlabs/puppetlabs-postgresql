# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::database_grant' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  context 'with minimal settings' do
    let :params do
      {
        privilege: 'ALL',
        db: 'test',
        role: 'test'
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__database_grant('test') }
    it { is_expected.to contain_postgresql__server__grant('database:test').with_psql_user('postgres').with_port(5432).with_group('postgres') }
  end

  context 'with different user/group/port' do
    let :params do
      {
        privilege: 'ALL',
        db: 'test',
        role: 'test',
        psql_user: 'foo',
        psql_group: 'bar',
        port: 1337
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('database:test').with_psql_user('foo').with_port(1337).with_group('bar') }
  end
end
