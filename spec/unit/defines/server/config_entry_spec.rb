require 'spec_helper'

describe 'postgresql::server::config_entry', :type => :define do
  let :default_facts do
    {
      :osfamily => 'RedHat',
      :operatingsystem => 'RedHat',
      :operatingsystemrelease => '6.4',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end
  let(:facts) { default_facts }

  let(:title) { 'config_entry'}

  let :target do
    tmpfilename('postgresql_conf')
  end

  context "syntax check" do
    let :pre_condition do
      "class {'postgresql::server':}"
    end

    let(:params) { { :ensure => 'present'} }
    it { should contain_postgresql__server__config_entry('config_entry') }
  end

  context "setting port" do
    let :pre_condition do
      # ensuring present causes duplicate port declaration
      "class {'postgresql::server': ensure => false}"
    end

    let(:title) { 'port'}
    let(:params) { { :ensure => 'present', :value => 9000 } }

    describe "on EL6" do
      it { should contain_postgresql_conf('port').with_value(9000) }
      it { should contain_augeas('override PGPORT in /etc/sysconfig/pgsql/postgresql').
             with_context('/files/etc/sysconfig/pgsql/postgresql').
             with_changes('set PGPORT 9000') }
      it { should contain_exec('postgresql_stop') }
    end

    describe "on EL7" do
      let(:facts) { default_facts.merge({ :operatingsystemrelease => '7.0' }) }

      it { should contain_postgresql_conf('port').with_value(9000) }
      it { should contain_file('systemd-port-override').
             with_path('/etc/systemd/system/postgresql.service') }
      it { should contain_exec('restart-systemd') }
    end

    describe "on Fedora" do
      let(:facts) { default_facts.merge({
        :operatingsystem => 'Fedora',
        :operatingsystemrelease => '19'
      }) }

      it { should contain_postgresql_conf('port').with_value(9000) }
      it { should contain_file('systemd-port-override').
             with_path('/etc/systemd/system/postgresql.service') }
      it { should contain_exec('restart-systemd') }
    end
  end
end

