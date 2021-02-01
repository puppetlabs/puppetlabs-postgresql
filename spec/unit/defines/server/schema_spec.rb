# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::schema', type: :define do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '8.0', 'major' => '8' },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  let :params do
    {
      owner: 'jane',
      db: 'janedb',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_postgresql__server__schema('test') }

  context 'with different owner' do
    let :params do
      {
        owner: 'nate',
        db: 'natedb',
      }
    end

    it { is_expected.to contain_postgresql_psql('natedb: ALTER SCHEMA "test" OWNER TO "nate"') }
  end
end
