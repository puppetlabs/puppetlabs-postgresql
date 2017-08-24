require 'spec_helper'

describe 'postgresql::server::dbgroupmember', :type => :define do

  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test_user'
  end

  context 'group member present' do

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end

    let :params do
      {
        :groupname => 'test',
      }
    end
  
    it { is_expected.to contain_postgresql__server__dbgroupmember('test_user') }
    it 'should have create group for test' do
      is_expected.to contain_postgresql_psql('test_user: ALTER GROUP test ADD USER test_user').with({
        'command'     => "ALTER GROUP test ADD USER test_user",
        'environment' => [],
        'unless'      => "SELECT 1 WHERE (SELECT usesysid from pg_user where usename = 'test_user') = ANY((SELECT grolist from pg_group where groname = 'test')::int[])",
        'port'        => "5432",
      })
    end
  end

  context 'group member absent' do

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end
  
    let :params do
      {
        :ensure => 'absent',
        :groupname => 'test',
      }
    end

    it { is_expected.to contain_postgresql__server__dbgroupmember('test_user') }
    it 'should have create group for test' do
      is_expected.to contain_postgresql_psql('test_user: ALTER GROUP test DROP USER test_user').with({
        'command'     => "ALTER GROUP test DROP USER test_user",
        'environment' => [],
        'unless'      => "SELECT 1 WHERE NOT (SELECT usesysid from pg_user where usename = 'test_user') = ANY((SELECT grolist from pg_group where groname = 'test')::int[])",
        'port'        => "5432",
      })
    end
  end
end
