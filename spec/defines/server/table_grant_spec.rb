# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::table_grant' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  let :params do
    {
      privilege: 'ALL',
      db: 'test',
      role: 'test',
      table: 'foo',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_postgresql__server__table_grant('test') }
  it { is_expected.to contain_postgresql__server__grant('table:test') }
end
