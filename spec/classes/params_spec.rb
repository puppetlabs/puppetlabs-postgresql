# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::params' do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '8.0', 'major' => '8' },
      },
    }
  end

  it { is_expected.to contain_class('postgresql::params') }
end
