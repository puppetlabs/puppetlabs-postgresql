require 'spec_helper'

describe 'postgresql::server::dbgroup', :type => :define do

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
    'test'
  end

  context 'group present' do

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end
  
    it { is_expected.to contain_postgresql__server__dbgroup('test') }
    it 'should have create group for test' do
      is_expected.to contain_postgresql_psql('test: CREATE GROUP test').with({
        'command'     => "CREATE GROUP test",
        'environment' => ["rp_env"],
        'unless'      => "SELECT 1 FROM pg_group WHERE groname = 'test'",
        'port'        => "5432",
      })
    end
  end

  context 'group absent' do

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end
  
    let :params do
      {
        :ensure => 'absent',
      }
    end

    it { is_expected.to contain_postgresql__server__dbgroup('test') }
    it 'should have create group for test' do
      is_expected.to contain_postgresql_psql('test: DROP GROUP test').with({
        'command'     => "DROP GROUP test",
        'environment' => ["rp_env"],
        'unless'      => "SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM pg_group WHERE groname = 'test')",
        'port'        => "5432",
      })
    end
  end
end
