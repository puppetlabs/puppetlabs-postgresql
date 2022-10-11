# frozen_string_literal: true

require 'spec_helper'

describe 'Postgresql::Pg_hba_rule' do
  context 'base valid required data' do
    let :data do
      {
        description: 'pc',
        type: 'host',
        database: 'all',
        user: 'all',
        address: '127.0.0.1/32',
        auth_method: 'md5',
        target: '/foo.conf',
        postgresql_version: '14',
        order: 3
      }
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
        auth_method: 'md5',
        target: '/foo.conf',
        postgres_version: '14'
      }
    end

    it { is_expected.not_to allow_value(data) }
  end
  context 'empty data' do
    let :data do
      {}
    end

    it { is_expected.not_to allow_value(data) }
  end
end
