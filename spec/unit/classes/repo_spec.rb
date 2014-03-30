require 'spec_helper'

describe 'postgresql::repo', :type => :class do
  let :facts do
    {
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '6.0',
      :lsbdistid              => 'Debian',
    }
  end

  describe 'with no parameters' do
    it 'should instantiate apt_postgresql_org class' do
      should contain_class('postgresql::repo::apt_postgresql_org')
    end
  end
end

describe 'postgresql::repo', :type => :class do
  let :facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '6.4',
    }
  end
  let :params do
    {
      :version  => '9.2',
    }
  end

  describe 'with no parameters' do
    it 'should instantiate yum_postgresql_org class' do
      should include_class('postgresql::repo::yum_postgresql_org')
    end
  end


end
