require 'spec_helper'

describe 'postgresql::server::schema', :type => :define do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('schema'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  let :params do
    {
      :owner => 'jane',
      :db    => 'janedb',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { should contain_postgresql__server__schema('test') }

  context "with change_ownership set to true" do
    let :params do
      {
        :owner            => 'nate',
        :db               => 'natedb',
        :change_ownership => true,
      }
    end

    it { is_expected.to contain_postgresql_psql("Change owner of schema 'test' to nate") }
  end
end
