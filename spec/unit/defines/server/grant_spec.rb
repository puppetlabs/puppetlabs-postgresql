require 'spec_helper'

describe 'postgresql::server::grant', :type => :define do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
      :operatingsystemrelease => '6.0',
      :kernel => 'Linux',
      :concat_basedir => tmpfilename('contrib'),
      :id => 'root',
      :path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  context 'plain' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
  end

  context 'sequence' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :privilege => 'usage',
        :object_type => 'sequence',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('grant:test').with(
      {
        'command' => /GRANT USAGE ON SEQUENCE "test" TO\s* "test"/m,
        'unless'  => /SELECT 1 WHERE has_sequence_privilege\('test',\s* 'test', 'USAGE'\)/m,
      }
    ) }
  end

  context 'all sequences' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :privilege => 'usage',
        :object_type => 'all sequences in schema',
        :object_name => 'public',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('grant:test').with(
      {
        'command' => /GRANT USAGE ON ALL SEQUENCES IN SCHEMA "public" TO\s* "test"/m,
        'unless'  => /SELECT 1 FROM \(\s*SELECT sequence_name\s* FROM information_schema\.sequences\s* WHERE sequence_schema='public'\s* EXCEPT DISTINCT\s* SELECT object_name as sequence_name\s* FROM .* WHERE .*grantee='test'\s* AND object_schema='public'\s* AND privilege_type='USAGE'\s*\) P\s* HAVING count\(P\.sequence_name\) = 0/m,
      }
    ) }
  end

  context "with specific db connection settings - default port" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1', },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1' } ).with_port( 5432 ) }
  end

  context "with specific db connection settings - including port" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1',
                               'PGPORT'    => '1234', },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1','PGPORT'    => '1234' } ) }
  end

  context "with specific db connection settings - port overriden by explicit parameter" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1',
             'PGPORT'    => '1234', },
        :port => '5678',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1','PGPORT'    => '1234' } ).with_port( '5678' ) }
  end

  context 'invalid objectype' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :privilege => 'usage',
        :object_type => 'invalid',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.and_raise_error(/"INVALID" does not match/) }
  end
end
