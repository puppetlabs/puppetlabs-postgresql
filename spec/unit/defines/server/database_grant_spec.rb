# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::database_grant', type: :define do
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
      privilege: 'ALL',
      db: 'test',
      role: 'test',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_postgresql__server__database_grant('test') }
  it { is_expected.to contain_postgresql__server__grant('database:test') }
end
