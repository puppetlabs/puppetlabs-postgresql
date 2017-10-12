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

  context 'plain (to user)' do
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

  context 'sequence (to user)' do
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
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT USAGE ON SEQUENCE "test" TO\s* "test"/m,
        'unless'  => /SELECT 1 WHERE has_sequence_privilege\('test',\s* 'test', 'USAGE'\)/m,
      }
    ) }
  end

  context 'all sequences (to user)' do
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
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT USAGE ON ALL SEQUENCES IN SCHEMA "public" TO\s* "test"/m,
        'unless'  => /SELECT 1 FROM \(\s*SELECT sequence_name\s* FROM information_schema\.sequences\s* WHERE sequence_schema='public'\s* EXCEPT DISTINCT\s* SELECT object_name as sequence_name\s* FROM .* WHERE .*grantee='test'\s* AND object_schema='public'\s* AND privilege_type='USAGE'\s*\) P\s* HAVING count\(P\.sequence_name\) = 0/m,
      }
    ) }
  end

  context 'redshift dialect required for group syntax' do
    let :params do
      {
        :db => 'test',
        :role => 'group test',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'postgres'}"
    end

    it { is_expected.to raise_error(Puppet::Error, /GROUP syntax is only available in the Redshift dialect/) }
  end

  context 'plain (to group)' do
    let :params do
      {
        :db => 'test',
        :role => 'group test',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
  end

  context 'schema (to redshift user)' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :privilege => 'usage',
        :object_name => 'test',
        :object_type => 'schema',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT USAGE ON SCHEMA "test" TO\s* "test"/m,
        'unless'  => /SELECT 1 WHERE has_schema_privilege\('test',\s* 'test', 'USAGE'\)/m,
      }
    ) }
  end

  context 'schema (to group)' do
    let :params do
      {
        :db => 'test',
        :role => 'group test',
        :privilege => 'usage',
        :object_name => 'test',
        :object_type => 'schema',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT USAGE ON SCHEMA "test" TO\s* group "test"/m,
        'unless'  => /WHERE\s*nsp.nspname = 'test'/m,
      }
    ) }
  end

  context 'all tables (to redshift user)' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :privilege => 'select',
        :object_type => 'all tables in schema',
        :object_name => 'public',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO\s* "test"/m,
        'unless'  => nil,
      }
    ) }
  end

  context 'all tables (to group)' do
    let :params do
      {
        :db => 'test',
        :role => 'group test',
        :privilege => 'select',
        :object_type => 'all tables in schema',
        :object_name => 'public',
      }
    end

    let :pre_condition do
      "class {'postgresql::server': dialect => 'redshift'}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT SELECT ON ALL TABLES IN SCHEMA "public" TO\s* group "test"/m,
        'unless'  => nil,
      }
    ) }
  end

  context 'SeQuEnCe case insensitive object_type match' do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :privilege => 'usage',
        :object_type => 'SeQuEnCe',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT USAGE ON SEQUENCE "test" TO\s* "test"/m,
        'unless'  => /SELECT 1 WHERE has_sequence_privilege\('test',\s* 'test', 'USAGE'\)/m,
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
    it { is_expected.to contain_postgresql_psql("test: grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1' } ).with_port( 5432 ) }
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
    it { is_expected.to contain_postgresql_psql("test: grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1','PGPORT'    => '1234' } ) }
  end

  context "with specific db connection settings - port overriden by explicit parameter" do
    let :params do
      {
        :db => 'test',
        :role => 'test',
        :connect_settings => { 'PGHOST'    => 'postgres-db-server',
                               'DBVERSION' => '9.1',
             'PGPORT'    => '1234', },
        :port => 5678,
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql("test: grant:test").with_connect_settings( { 'PGHOST'    => 'postgres-db-server','DBVERSION' => '9.1','PGPORT'    => '1234' } ).with_port( '5678' ) }
  end

  context 'with specific schema name' do
    let :params do
      {
        :db          => 'test',
        :role        => 'test',
        :privilege   => 'all',
        :object_name => ['myschema', 'mytable'],
        :object_type => 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('test: grant:test').with(
      {
        'command' => /GRANT ALL ON TABLE "myschema"."mytable" TO\s* "test"/m,
        'unless'  => /SELECT 1 WHERE has_table_privilege\('test',\s*'myschema.mytable', 'INSERT'\)/m,
      }
    ) }
  end

  context 'invalid object_type' do
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

    it { is_expected.to compile.and_raise_error(/parameter 'object_type' expects a match for Pattern/) }
  end

  context 'invalid object_name - wrong type' do
    let :params do
      {
        :db          => 'test',
        :role        => 'test',
        :privilege   => 'all',
        :object_name => 1,
        :object_type => 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.and_raise_error(/parameter 'object_name' expects a value of type (Array|Undef, Array,) or String, got Integer/) }
  end

  context 'invalid object_name - insufficent array elements' do
    let :params do
      {
        :db          => 'test',
        :role        => 'test',
        :privilege   => 'all',
        :object_name => ['oops'],
        :object_type => 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    if Puppet::Util::Package.versioncmp(Puppet.version, '5.2.0') >= 0
      it { is_expected.to compile.and_raise_error(/parameter 'object_name' variant 1 expects size to be 2, got 1/) }
    else
      it { is_expected.to compile.and_raise_error(/parameter 'object_name' variant 0 expects size to be 2, got 1/) }
    end
  end

  context 'invalid object_name - too many array elements' do
    let :params do
      {
        :db          => 'test',
        :role        => 'test',
        :privilege   => 'all',
        :object_name => ['myschema', 'mytable', 'oops'],
        :object_type => 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    if Puppet::Util::Package.versioncmp(Puppet.version, '5.2.0') >= 0
      it { is_expected.to compile.and_raise_error(/parameter 'object_name' variant 1 expects size to be 2, got 3/) }
    else
      it { is_expected.to compile.and_raise_error(/parameter 'object_name' variant 0 expects size to be 2, got 3/) }
    end
  end
end
