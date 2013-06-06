require 'spec_helper'

describe 'postgresql::python', :type => :class do

  describe 'on a redhat based os' do
    let :facts do {
      :osfamily                 => 'RedHat',
      :postgres_default_version => 'foo',
    }
    end
    it { should contain_package('python-psycopg2').with(
      :name   => 'python-psycopg2',
      :ensure => 'present'
    )}
  end

  describe 'on a debian based os' do
    let :facts do {
      :osfamily                 => 'Debian',
      :postgres_default_version => 'foo',
    }
    end
    it { should contain_package('python-psycopg2').with(
      :name   => 'python-psycopg2',
      :ensure => 'present'
    )}
  end

  describe 'on any other os' do
    let :facts do {
      :osfamily                 => 'foo',
      :postgres_default_version => 'foo',
    }
    end

    it 'should fail without all the necessary parameters' do
      expect { subject }.to raise_error(/Module postgresql does not provide defaults for osfamily: foo/)
    end
  end

  describe 'on any other os without all the necessary parameters' do
    let :facts do {
      :osfamily                 => 'foo',
      :postgres_default_version => 'foo',
    }
    end

    it 'should fail' do
      expect { subject }.to raise_error(/Module postgresql does not provide defaults for osfamily: foo/)
    end
  end

end
