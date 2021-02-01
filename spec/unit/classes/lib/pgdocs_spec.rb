# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::docs', type: :class do
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
      is_expected.to contain_package('postgresql-docs').with(
        name: 'postgresql-docs',
        ensure: 'present',
        tag: 'puppetlabs-postgresql',
      )
    }
    describe 'when parameters are supplied' do
      let :params do
        { package_ensure: 'latest', package_name: 'somepackage' }
      end

      it {
        is_expected.to contain_package('postgresql-docs').with(
          name: 'somepackage',
          ensure: 'latest',
          tag: 'puppetlabs-postgresql',
        )
      }
    end
  end
end
