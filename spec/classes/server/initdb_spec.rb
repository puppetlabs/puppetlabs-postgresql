# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::initdb' do
  let(:pre_condition) do
    'include postgresql::server'
  end

  describe 'on RedHat' do
    include_examples 'RedHat 8'

    it { is_expected.to contain_file('/var/lib/pgsql/data').with_ensure('directory') }

    context 'with (log,manage,xlog)_datadir set to false' do
      let :pre_condition do
        "
        class {'postgresql::server':
          manage_logdir  => false,
          manage_datadir => false,
          manage_xlogdir => false,
          logdir         => '/var/lib/pgsql/data/log',
          xlogdir        => '/var/lib/pgsql/data/xlog',
        }
        file {'/var/lib/pgsql/data': ensure => 'directory'}
        file {'/var/lib/pgsql/data/log': ensure => 'directory'}
        file {'/var/lib/pgsql/data/xlog': ensure => 'directory'}
        "
      end

      it { is_expected.to contain_file('/var/lib/pgsql/data').with_ensure('directory') }
      it { is_expected.to contain_file('/var/lib/pgsql/data/log').with_ensure('directory') }
      it { is_expected.to contain_file('/var/lib/pgsql/data/xlog').with_ensure('directory') }
    end
  end

  describe 'on Amazon' do
    include_examples 'Amazon 1'

    it { is_expected.to contain_file('/var/lib/pgsql92/data').with_ensure('directory') }

    context 'with manage_datadir set to false' do
      let :pre_condition do
        "
        class {'postgresql::server':
          manage_datadir => false,
        }
        file {'/var/lib/pgsql92/data': ensure => 'directory'}
        "
      end

      it { is_expected.to contain_file('/var/lib/pgsql92/data').with_ensure('directory') }
    end
  end

  describe 'exec with module_workdir => /var/tmp' do
    include_examples 'RedHat 8'
    let(:pre_condition) do
      <<-EOS
        class { 'postgresql::globals':
          module_workdir => '/var/tmp',
        }->
        class { 'postgresql::server': }
      EOS
    end

    it 'contains exec with specified working directory' do
      expect(subject).to contain_exec('postgresql_initdb_instance_main').with(
        cwd: '/var/tmp',
      )
    end
  end

  describe 'exec with module_workdir => undef' do
    include_examples 'RedHat 8'
    let(:pre_condition) do
      <<-EOS
        class { 'postgresql::globals':
        }->
        class { 'postgresql::server': }
      EOS
    end

    it 'contains exec with default working directory' do
      expect(subject).to contain_exec('postgresql_initdb_instance_main').with(
        cwd: '/tmp',
      )
    end
  end

  describe 'postgresql_psql with module_workdir => /var/tmp' do
    include_examples 'RedHat 8'
    let(:pre_condition) do
      <<-EOS
        class { 'postgresql::globals':
          module_workdir => '/var/tmp',
          encoding       => 'test',
          needs_initdb   => false,
        }->
        class { 'postgresql::server': }
      EOS
    end

    it 'contains postgresql_psql with specified working directory' do
      expect(subject).to contain_postgresql_psql('Set template1 encoding to test').with(cwd: '/var/tmp')
    end
  end
end
