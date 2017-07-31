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

  context 'no members' do

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end
  
    it { is_expected.to contain_postgresql__server__dbgroup('test') }
    it 'should have create group for test' do
      is_expected.to contain_postgresql_psql('test: CREATE GROUP test').with({
        'command'     => "CREATE GROUP 'test'",
        'environment' => [],
        'unless'      => "SELECT 1 FROM pg_group WHERE groname = 'test'",
        'port'        => "5432",
      })
    end
    it 'should have update pg_group for test group with groupmembers as {}' do
      is_expected.to contain_postgresql_psql("test: UPDATE pg_group SET grolist = '{}' WHERE groname = 'test'").with({
        'command'     => "UPDATE pg_group SET grolist = '{}' WHERE groname = 'test'",
        'unless'      => "SELECT 1 FROM pg_group WHERE groname = 'test' AND grolist = '{}'",
        'port'        => "5432",
      })
    end
  end

  context 'group containing test members' do

    let :pre_condition do
     "class {'postgresql::server': dialect => 'postgres'}"
    end
  
    let :params do
      {
        :groupmembers => ['testuser1', 'testuser2'],
      }
    end

    it { is_expected.to contain_postgresql__server__dbgroup('test') }
    it 'should have create group for test' do
      is_expected.to contain_postgresql_psql('test: CREATE GROUP test').with({
        'command'     => "CREATE GROUP 'test'",
        'environment' => [],
        'unless'      => "SELECT 1 FROM pg_group WHERE groname = 'test'",
        'port'        => "5432",
      })
    end
    it 'should have update pg_group for test group with provided groupmembers' do
      is_expected.to contain_postgresql_psql("test: UPDATE pg_group SET grolist = '{\"testuser1\", \"testuser2\"}' WHERE groname = 'test'").with({
        'command'     => "UPDATE pg_group SET grolist = '{\"testuser1\", \"testuser2\"}' WHERE groname = 'test'",
        'unless'      => "SELECT 1 FROM pg_group WHERE groname = 'test' AND grolist = '{\"testuser1\", \"testuser2\"}'",
        'port'        => "5432",
      })
    end
  end
end
