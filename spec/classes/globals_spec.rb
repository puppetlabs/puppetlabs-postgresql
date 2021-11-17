# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::globals' do
  context 'on a debian 11' do
    include_examples 'Debian 11'

    describe 'with no parameters' do
      it 'works' do
        is_expected.to contain_class('postgresql::globals')
      end
    end

    describe 'manage_package_repo => true' do
      let(:params) do
        {
          manage_package_repo: true,
        }
      end

      it 'pulls in class postgresql::repo' do
        is_expected.to contain_class('postgresql::repo')
      end
    end
  end

  context 'on redhat 7' do
    include_examples 'RedHat 7'

    describe 'with no parameters' do
      it 'works' do
        is_expected.to contain_class('postgresql::globals')
      end
    end

    describe 'manage_package_repo on RHEL => true' do
      let(:params) do
        {
          manage_package_repo: true,
          repo_proxy: 'http://proxy-server:8080',
        }
      end

      it 'pulls in class postgresql::repo' do
        is_expected.to contain_class('postgresql::repo')
      end

      it do
        is_expected.to contain_yumrepo('yum.postgresql.org').with(
          'enabled' => '1',
          'proxy'   => 'http://proxy-server:8080',
        )
        is_expected.to contain_yumrepo('pgdg-common').with(
          'enabled' => '1',
          'proxy'   => 'http://proxy-server:8080',
        )
      end
    end

    describe 'repo_baseurl on RHEL => mirror.localrepo.com' do
      let(:params) do
        {
          manage_package_repo: true,
          repo_baseurl: 'http://mirror.localrepo.com/pgdg-postgresql',
          yum_repo_commonurl: 'http://mirror.localrepo.com/pgdg-common',
        }
      end

      it 'pulls in class postgresql::repo' do
        is_expected.to contain_class('postgresql::repo')
      end

      it do
        is_expected.to contain_yumrepo('yum.postgresql.org').with(
          'enabled' => '1',
          'baseurl' => 'http://mirror.localrepo.com/pgdg-postgresql',
        )
        is_expected.to contain_yumrepo('pgdg-common').with(
          'enabled' => '1',
          'baseurl' => 'http://mirror.localrepo.com/pgdg-common',
        )
      end
    end
  end
end
