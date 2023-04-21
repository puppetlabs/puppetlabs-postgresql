# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::lib::devel' do
  include_examples 'Debian 11'

  it { is_expected.to contain_class('postgresql::lib::devel') }

  describe 'link pg_config to /usr/bin' do
    it {
      expect(subject).not_to contain_file('/usr/bin/pg_config') \
        .with_ensure('link') \
        .with_target('/usr/lib/postgresql/13/bin/pg_config')
    }
  end

  describe 'disable link_pg_config' do
    let(:params) do
      {
        link_pg_config: false
      }
    end

    it { is_expected.not_to contain_file('/usr/bin/pg_config') }
  end

  describe 'should not link pg_config on RedHat with default version' do
    include_examples 'RedHat 8'

    it { is_expected.not_to contain_file('/usr/bin/pg_config') }
  end

  describe 'link pg_config on RedHat with non-default version' do
    include_examples 'RedHat 8'
    let :pre_condition do
      "class { '::postgresql::globals': version => '9.3' }"
    end

    it {
      expect(subject).to contain_file('/usr/bin/pg_config') \
        .with_ensure('link') \
        .with_target('/usr/pgsql-9.3/bin/pg_config')
    }
  end

  describe 'on Gentoo' do
    include_examples 'Gentoo'
    let :params do
      {
        link_pg_config: false
      }
    end

    it 'fails to compile' do
      expect(subject).to compile.and_raise_error(%r{is not supported})
    end
  end
end
