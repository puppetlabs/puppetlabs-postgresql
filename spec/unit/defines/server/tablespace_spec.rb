require 'spec_helper'

describe 'postgresql::server::tablespace', type: :define do
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('tablespace'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  let :params do
    {
      location: '/srv/data/foo',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_file('/srv/data/foo').with_ensure('directory') }
  it { is_expected.to contain_postgresql__server__tablespace('test') }
  it { is_expected.to contain_postgresql_psql('CREATE TABLESPACE "test"').that_requires('Class[postgresql::server::service]') }

  context 'with different owner' do
    let :params do
      {
        location: '/srv/data/foo',
        owner: 'test_owner',
      }
    end

    it { is_expected.to contain_postgresql_psql('ALTER TABLESPACE "test" OWNER TO "test_owner"') }
  end

  context 'with manage_location set to false' do
    let :params do
      {
        location: '/srv/data/foo',
        manage_location: false,
      }
    end

    let :pre_condition do
      "
      class {'postgresql::server':}
      file {'/srv/data/foo': ensure => 'directory'}
      "
    end

    it { is_expected.to contain_file('/srv/data/foo').with_ensure('directory') }
  end
end
