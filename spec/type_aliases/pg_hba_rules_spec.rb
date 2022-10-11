# frozen_string_literal: true

require 'spec_helper'

describe 'Postgresql::Pg_hba_rules' do
  context 'base valid required data' do
    let :data do
      {
        foo: {
          description: 'pc',
          type: 'host',
          database: 'all',
          user: 'all',
          address: '127.0.0.1/32',
          auth_method: 'md5',
          target: '/foo.conf',
          postgresql_version: '14',
          order: 1,
        },
        foo2: {
          description: 'pc',
          type: 'host',
          database: 'all',
          user: 'all',
          address: '127.0.0.1/32',
          auth_method: 'md5',
          target: '/foo.conf',
          postgresql_version: '14',
          order: 2
        }
      }
    end

    it { is_expected.to allow_value(data) }
  end
  context 'empty' do
    let :data do
      {}
    end

    it { is_expected.to allow_value(data) }
  end
  context 'invalid data' do
    let :data do
      {
        description: 'pc',
        type: 'host',
        database: 'all',
        user: 'all',
        address: '/32',
        auth_method: 'md5'
      }
    end

    it { is_expected.not_to allow_value(data) }
  end
  context 'empty value' do
    let :data do
      {
        foo: {}
      }
    end

    it { is_expected.not_to allow_value(data) }
  end
end
