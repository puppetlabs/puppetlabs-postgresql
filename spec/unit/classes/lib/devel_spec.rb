require 'spec_helper'

describe 'postgresql::lib::devel', type: :class do
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '6.0',
    }
  end

  it { is_expected.to contain_class('postgresql::lib::devel') }

  describe 'link pg_config to /usr/bin' do
    it {
      is_expected.not_to contain_file('/usr/bin/pg_config') \
        .with_ensure('link') \
        .with_target('/usr/lib/postgresql/8.4/bin/pg_config')
    }
  end

  describe 'disable link_pg_config' do
    let(:params) do
      {
        link_pg_config: false,
      }
    end

    it { is_expected.not_to contain_file('/usr/bin/pg_config') }
  end

  describe 'should not link pg_config on RedHat with default version' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemrelease: '6.3',
        operatingsystemmajrelease: '6',
      }
    end

    it { is_expected.not_to contain_file('/usr/bin/pg_config') }
  end

  describe 'link pg_config on RedHat with non-default version' do
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystem: 'CentOS',
        operatingsystemrelease: '6.3',
        operatingsystemmajrelease: '6',
      }
    end
    let :pre_condition do
      "class { '::postgresql::globals': version => '9.3' }"
    end

    it {
      is_expected.to contain_file('/usr/bin/pg_config') \
        .with_ensure('link') \
        .with_target('/usr/pgsql-9.3/bin/pg_config')
    }
  end

  describe 'on Gentoo' do
    let :facts do
      {
        osfamily: 'Gentoo',
        operatingsystem: 'Gentoo',
      }
    end
    let :params do
      {
        link_pg_config: false,
      }
    end

    it 'fails to compile' do # rubocop:disable RSpec/MultipleExpectations
      expect {
        is_expected.to compile
      }.to raise_error(%r{is not supported})
    end
  end
end
