require 'spec_helper'

describe 'postgresql::config_entry', :type => :define do
  let :facts do
    {
      :postgres_default_version => '9.2',
      :osfamily => 'RedHat',
    }
  end
  let(:title) { 'config_entry'}
  let :target do
    tmpfilename('postgresql_conf')
  end
  context "syntax check" do
    let(:params) { { :ensure => 'present'} }
    it { should include_class("postgresql::params") }
  end
end

