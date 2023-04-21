# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::schema' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  let :params do
    {
      owner: 'jane',
      db: 'janedb'
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
        db: 'natedb'
      }
    end

    it { is_expected.to contain_postgresql_psql('natedb: ALTER SCHEMA "test" OWNER TO "nate"') }
  end
end
