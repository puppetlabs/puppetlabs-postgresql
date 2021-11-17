# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::python' do
  describe 'on a redhat based os' do
    let :facts do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { 'full' => '6.4', 'major' => '6' },
        },
      }
    end

    it {
      is_expected.to contain_package('python-psycopg2').with(
        name: 'python-psycopg2',
        ensure: 'present',
      )
    }
  end

  describe 'on a redhat based os with python 3' do
    let :facts do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { 'full' => '8.2', 'major' => '8' },
        },
      }
    end

    it {
      is_expected.to contain_package('python-psycopg2').with(
        name: 'python3-psycopg2',
        ensure: 'present',
      )
    }
  end

  describe 'on a debian based os' do
    let :facts do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: { 'full' => '8.0', 'major' => '8' },
        },
      }
    end

    it {
      is_expected.to contain_package('python-psycopg2').with(
        name: 'python-psycopg2',
        ensure: 'present',
      )
    }
  end
end
