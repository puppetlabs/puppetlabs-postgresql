# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::java', type: :class do
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
      is_expected.to contain_package('postgresql-jdbc').with(
        name: 'libpostgresql-jdbc-java',
        ensure: 'present',
        tag: 'puppetlabs-postgresql',
      )
    }
  end

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
      is_expected.to contain_package('postgresql-jdbc').with(
        name: 'postgresql-jdbc',
        ensure: 'present',
        tag: 'puppetlabs-postgresql',
      )
    }
    describe 'when parameters are supplied' do
      let :params do
        { package_ensure: 'latest', package_name: 'somepackage' }
      end

      it {
        is_expected.to contain_package('postgresql-jdbc').with(
          name: 'somepackage',
          ensure: 'latest',
          tag: 'puppetlabs-postgresql',
        )
      }
    end
  end
end
