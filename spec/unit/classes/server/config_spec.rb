require 'spec_helper'

describe 'postgresql::server::config', :type => :class do
  let (:pre_condition) do
    "include postgresql::server"
  end

  describe 'on RedHat 7' do
    let :facts do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'CentOS',
        :operatingsystemrelease => '7.0',
        :concat_basedir => tmpfilename('server'),
        :kernel => 'Linux',
        :id => 'root',
        :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    end

    describe 'with a version >= 9.1' do
      let (:pre_condition) do
        <<-EOS
          class { 'postgresql::globals':
            manage_package_repo => false,
            version => '9.4',
          }->
          class { 'postgresql::server': }
        EOS
      end

      it 'should have the correct systemd-override file' do
        is_expected.to contain_file('systemd-override').with ({
          :ensure => 'present',
          :path => '/etc/systemd/system/postgresql-9.4.service',
          :owner => 'root',
          :group => 'root',
        })
        is_expected.to contain_file('systemd-override') \
          .with_content(/postgresql-9.4.service/)
      end
    end
  end
end
