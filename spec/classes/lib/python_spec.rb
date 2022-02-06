# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::python' do
  describe 'on redhat 7' do
    include_examples 'RedHat 7'

    it {
      is_expected.to contain_package('python-psycopg2').with(
        name: 'python-psycopg2',
        ensure: 'present',
      )
    }
  end

  describe 'on redhat 8' do
    include_examples 'RedHat 8'

    it {
      is_expected.to contain_package('python-psycopg2').with(
        name: 'python3-psycopg2',
        ensure: 'present',
      )
    }
  end

  describe 'on debian 11' do
    include_examples 'Debian 11'

    it {
      is_expected.to contain_package('python-psycopg2').with(
        name: 'python-psycopg2',
        ensure: 'present',
      )
    }
  end
end
