require 'spec_helper'

describe 'postgresql::params', type: :class do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '8.0' },
      },
    }
  end

  it { is_expected.to contain_class('postgresql::params') }
end
