# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::perl', type: :class do
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
      is_expected.to contain_package('perl-DBD-Pg').with(
        name: 'perl-DBD-Pg',
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
      is_expected.to contain_package('perl-DBD-Pg').with(
        name: 'libdbd-pg-perl',
        ensure: 'present',
      )
    }
  end
end
