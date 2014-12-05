require 'spec_helper'

describe 'postgresql::server::extension', :type => :define do
  let :pre_condition do
    "class { 'postgresql::server': }
     postgresql::server::database { 'template_postgis':
       template   => 'template1',
     }"
  end

  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('postgis'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let (:title) { 'postgis' }
  let (:params) { {
    :database => 'template_postgis',
  } }

  context "with mandatory arguments only" do
    it { is_expected.to compile.with_all_deps }

    it {
      is_expected.to contain_postgresql_psql('Add postgis extension to template_postgis').with({
        :db      => 'template_postgis',
        :command => 'CREATE EXTENSION postgis',
        :unless  => "SELECT extname FROM pg_extension WHERE extname = 'postgis'",
      })
    }
  end

  context "when setting package name" do
    let (:params) { super().merge({
      :package_name => 'postgis',
    }) }

    it "should take a package_name optional argument" do

      is_expected.to compile.with_all_deps

      is_expected.to contain_package('Postgresql extension postgis').with({
          :ensure  => 'present',
          :name    => 'postgis',
        })
    end
  end
end
