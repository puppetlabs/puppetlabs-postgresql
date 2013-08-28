require 'spec_helper'

describe 'postgres_default_version', :type => :fact do
  it 'should handle redhat 5.6' do
    Facter.fact(:osfamily).stubs(:value).returns 'RedHat'
    Facter.fact(:operatingsystemrelease).stubs(:value).returns '5.6'
    Facter.fact(:postgres_default_version).value.should == '8.1'
  end

  it 'should handle redhat 6.2' do
    Facter.fact(:osfamily).stubs(:value).returns 'RedHat'
    Facter.fact(:operatingsystemrelease).stubs(:value).returns '6.2'
    Facter.fact(:postgres_default_version).value.should == '8.4'
  end

  it 'should handle Debian 6.0' do
    Facter.fact(:osfamily).stubs(:value).returns 'Debian'
    Facter.fact(:operatingsystemrelease).stubs(:value).returns '6.0'
    Facter.fact(:postgres_default_version).value.should == '8.4'
  end

  it 'should handle Debian 7.0' do
    Facter.fact(:osfamily).stubs(:value).returns 'Debian'
    Facter.fact(:operatingsystemrelease).stubs(:value).returns '7.0'
    Facter.fact(:postgres_default_version).value.should == '9.1'
  end

  it 'should handle Debian 8.0' do
    Facter.fact(:osfamily).stubs(:value).returns 'Debian'
    Facter.fact(:operatingsystemrelease).stubs(:value).returns '8.0'
    Facter.fact(:postgres_default_version).value.should == '9.3'
  end
end
