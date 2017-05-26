require 'spec_helper'

describe 'postgresql::repo', :type => :class do
  let :facts do
    {
      lsbdistid: 'Debian',
      lsbdistcodename: 'squeeze',
      os: {
        family: 'Debian',
        lsb: { distid: 'Debian', distcodename: 'squeeze' },
        name: 'Debian',
        release: { full: '6.0' },
      },
      osfamily: 'Debian',
    }
  end

  describe 'with no parameters' do
    it 'should instantiate apt_postgresql_org class' do
      is_expected.to contain_class('postgresql::repo::apt_postgresql_org')
    end
  end
end
