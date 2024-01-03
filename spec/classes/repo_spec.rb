# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::repo' do
  include_examples 'Debian 11'

  describe 'with no parameters' do
    it 'instantiates apt_postgresql_org class' do
      expect(subject).to contain_class('postgresql::repo::apt_postgresql_org')
    end

    it {
      is_expected.to contain_apt__source('apt.postgresql.org')
        .with_location('https://apt.postgresql.org/pub/repos/apt/')
        .with_release("#{facts[:os]['distro']['codename']}-pgdg")
    }

    it { is_expected.to contain_apt__pin('apt_postgresql_org') }
  end

  describe 'with custom baseurl and release' do
    let(:params) do
      {
        baseurl: 'https://apt-archive.postgresql.org/pub/repos/apt/',
        release: 'bionic-pgdg-archive',
      }
    end

    it {
      is_expected.to contain_apt__source('apt.postgresql.org')
        .with_location(params[:baseurl])
        .with_release(params[:release])
    }
  end
end
