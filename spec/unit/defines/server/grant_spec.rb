require 'spec_helper'

describe 'postgresql::server::grant', type: :define do
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('contrib'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  let :title do
    'test'
  end

  context 'plain' do
    let :params do
      {
        db: 'test',
        role: 'test',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
  end

  context 'sequence' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'usage',
        object_type: 'sequence',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT USAGE ON SEQUENCE "test" TO\s* "test"}m)
        .with_unless(%r{SELECT 1 WHERE has_sequence_privilege\('test',\s* 'test', 'USAGE'\)}m)
    end
  end

  context 'SeQuEnCe case insensitive object_type match' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'usage',
        object_type: 'SeQuEnCe',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT USAGE ON SEQUENCE "test" TO\s* "test"}m)
        .with_unless(%r{SELECT 1 WHERE has_sequence_privilege\('test',\s* 'test', 'USAGE'\)}m)
    end
  end

  context 'all sequences' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'usage',
        object_type: 'all sequences in schema',
        object_name: 'public',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT USAGE ON ALL SEQUENCES IN SCHEMA "public" TO\s* "test"}m)
        .with_unless(%r{SELECT 1 WHERE NOT EXISTS \(\s*SELECT sequence_name\s* FROM information_schema\.sequences\s* WHERE sequence_schema='public'\s* EXCEPT DISTINCT\s* SELECT object_name as sequence_name\s* FROM .* WHERE .*grantee='test'\s* AND object_schema='public'\s* AND privilege_type='USAGE'\s*\)}m) # rubocop:disable Metrics/LineLength
    end
  end

  context 'with specific db connection settings - default port' do
    let :params do
      {
        db: 'test',
        role: 'test',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('grant:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1').with_port(5432) }
  end

  context 'with specific db connection settings - including port' do
    let :params do
      {
        db: 'test',
        role: 'test',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT'    => '1234' },
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('grant:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGPORT' => '1234') }
  end

  context 'with specific db connection settings - port overriden by explicit parameter' do
    let :params do
      {
        db: 'test',
        role: 'test',
        connect_settings: { 'PGHOST' => 'postgres-db-server',
                            'DBVERSION' => '9.1',
                            'PGPORT' => '1234' },
        port: 5678,
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql_psql('grant:test').with_connect_settings('PGHOST' => 'postgres-db-server', 'DBVERSION' => '9.1', 'PGPORT' => '1234').with_port('5678') }
  end

  context 'with specific schema name' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_name: ['myschema', 'mytable'],
        object_type: 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT ALL ON TABLE "myschema"."mytable" TO\s* "test"}m)
        .with_unless(%r{SELECT 1 WHERE has_table_privilege\('test',\s*'myschema.mytable', 'INSERT'\)}m)
    end
  end

  context 'with a role defined' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_name: ['myschema', 'mytable'],
        object_type: 'table',
      }
    end

    let :pre_condition do
      <<-EOS
      class {'postgresql::server':}
      postgresql::server::role { 'test': }
      EOS
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql__server__role('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test') \
        .that_requires(['Class[postgresql::server::service]', 'Postgresql::Server::Role[test]'])
    end
  end

  context 'with a role defined to PUBLIC' do
    let :params do
      {
        db: 'test',
        role: 'PUBLIC',
        privilege: 'all',
        object_name: ['myschema', 'mytable'],
        object_type: 'table',
      }
    end

    let :pre_condition do
      <<-EOS
      class {'postgresql::server':}
      postgresql::server::role { 'test': }
      EOS
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it { is_expected.to contain_postgresql__server__role('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT ALL ON TABLE "myschema"."mytable" TO\s* "PUBLIC"}m)
        .with_unless(%r{SELECT 1 WHERE has_table_privilege\('public',\s*'myschema.mytable', 'INSERT'\)}m)
    end
  end

  context 'function' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'execute',
        object_name: 'test',
        object_arguments: ['text', 'boolean'],
        object_type: 'function',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT EXECUTE ON FUNCTION test\(text,boolean\) TO\s* "test"}m)
        .with_unless(%r{SELECT 1 WHERE has_function_privilege\('test',\s* 'test\(text,boolean\)', 'EXECUTE'\)}m)
    end
  end

  context 'function with schema' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'execute',
        object_name: ['myschema', 'test'],
        object_arguments: ['text', 'boolean'],
        object_type: 'function',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_postgresql__server__grant('test') }
    it do
      is_expected.to contain_postgresql_psql('grant:test')
        .with_command(%r{GRANT EXECUTE ON FUNCTION myschema.test\(text,boolean\) TO\s* "test"}m)
        .with_unless(%r{SELECT 1 WHERE has_function_privilege\('test',\s* 'myschema.test\(text,boolean\)', 'EXECUTE'\)}m)
    end
  end

  context 'standalone not managing server' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'execute',
        object_name: ['myschema', 'test'],
        object_arguments: ['text', 'boolean'],
        object_type: 'function',
        group: 'postgresql',
        psql_path: '/usr/bin',
        psql_user: 'postgres',
        psql_db: 'db',
        port: 1542,
        connect_settings: {},
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.not_to contain_class('postgresql::server') }
  end

  context 'invalid object_type' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'usage',
        object_type: 'invalid',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.and_raise_error(%r{parameter 'object_type' expects a match for Pattern}) }
  end

  context 'invalid object_name - wrong type' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_name: 1,
        object_type: 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    it { is_expected.to compile.and_raise_error(%r{parameter 'object_name' expects a value of type (Array|Undef, Array,) or String, got Integer}) }
  end

  context 'invalid object_name - insufficent array elements' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_name: ['oops'],
        object_type: 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    if Puppet::Util::Package.versioncmp(Puppet.version, '5.2.0') >= 0
      it { is_expected.to compile.and_raise_error(%r{parameter 'object_name' variant 1 expects size to be 2, got 1}) }
    else
      it { is_expected.to compile.and_raise_error(%r{parameter 'object_name' variant 0 expects size to be 2, got 1}) }
    end
  end

  context 'invalid object_name - too many array elements' do
    let :params do
      {
        db: 'test',
        role: 'test',
        privilege: 'all',
        object_name: ['myschema', 'mytable', 'oops'],
        object_type: 'table',
      }
    end

    let :pre_condition do
      "class {'postgresql::server':}"
    end

    if Puppet::Util::Package.versioncmp(Puppet.version, '5.2.0') >= 0
      it { is_expected.to compile.and_raise_error(%r{parameter 'object_name' variant 1 expects size to be 2, got 3}) }
    else
      it { is_expected.to compile.and_raise_error(%r{parameter 'object_name' variant 0 expects size to be 2, got 3}) }
    end
  end
end
