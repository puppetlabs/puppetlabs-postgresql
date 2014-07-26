require 'spec_helper'

describe 'postgresql::server::pg_ident_map', :type => :define do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('pg_ident'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end
  let :target do
    tmpfilename('pg_ident_map')
  end

  context 'test user map' do
    let :pre_condition do
      <<-EOS
        class { 'postgresql::server': }
      EOS
    end

    let :params do
      {
        :map_name => 'omicron',
        :system_username => 'robert',
        :database_username => 'bob',
        :target => target,
      }
    end
    it do
      is_expected.to contain_concat__fragment('pg_ident_map_test').with({
        :content => /omicron\s+robert\s+bob/
      })
    end
  end
end
