require 'spec_helper'

describe 'postgresql::repo', type: :class do
  let :facts do
    {
      os: {
        name: 'Debian',
        family: 'Debian',
        release: {
          full: '8.0',
          major: '8',
        },
      },
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      lsbdistid: 'Debian',
      lsbdistcodename: 'jessie',
    }
  end

  describe 'with no parameters' do
    it 'instantiates apt_postgresql_org class' do
      is_expected.to contain_class('postgresql::repo::apt_postgresql_org')
    end
  end
end
