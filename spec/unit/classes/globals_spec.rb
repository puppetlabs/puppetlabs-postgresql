# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::globals', type: :class do
  context 'on a debian 8' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: {
            full: '8.0',
            major: '8',
          },
          distro: { 'codename' => 'jessie' },
        },
        osfamily: 'Debian',
        lsbdistid: 'Debian',
        lsbdistcodename: 'jessie',
      }
    end

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

  context 'on redhat family systems' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { 'full' => '7.1', 'major' => '7' },
        },
        osfamily: 'RedHat',
      }
    end

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
      end
    end

    describe 'repo_baseurl on RHEL => mirror.localrepo.com' do
      let(:params) do
        {
          manage_package_repo: true,
          repo_baseurl: 'http://mirror.localrepo.com',
        }
      end

      it 'pulls in class postgresql::repo' do
        is_expected.to contain_class('postgresql::repo')
      end

      it do
        is_expected.to contain_yumrepo('yum.postgresql.org').with(
          'enabled' => '1',
          'baseurl' => 'http://mirror.localrepo.com',
        )
      end
    end
  end
end
