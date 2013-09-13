require 'spec_helper'

describe 'postgresql::config', :type => :class do
  let :facts do
    {
      :postgres_default_version => '8.4',
      :osfamily => 'Debian',
      :concat_basedir => tmpfilename('config'),
    }
  end
  let :params do
    {
      :manage_service => true,
    }
  end
  it { should include_class("postgresql::config") }

  describe 'when manage_service is set to true' do
    it { should contain_class('postgresql::config::afterservice').with(:require =>
      '[Class[Postgresql::Config::Beforeservice]{:name=>"Postgresql::Config::Beforeservice"}, Service[postgresqld]{:name=>"postgresqld"}]') }
  end

  describe 'when manage_service is set to false' do
    let :params do
      {
        :manage_service => false,
      }
    end
    it { should contain_class('postgresql::config::afterservice').with(:require =>
      '[Class[Postgresql::Config::Beforeservice]{:name=>"Postgresql::Config::Beforeservice"}, :undef]') }

  end
end
