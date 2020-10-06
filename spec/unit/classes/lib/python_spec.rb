require 'spec_helper'

describe 'postgresql::lib::python', type: :class do
  describe 'on a redhat based os' do
    let :facts do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { 'full' => '6.4' },
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

  describe 'on a debian based os' do
    let :facts do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: { 'full' => '8.0' },
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
