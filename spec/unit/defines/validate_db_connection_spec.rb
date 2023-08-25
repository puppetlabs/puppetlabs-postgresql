# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::validate_db_connection', type: :define do
  let :facts do
    {
      os: {
        family: 'Debian',
        name: 'Debian',
        release: { 'full' => '8.0', 'major' => '8' },
      },
    }
  end

  let :title do
    'test'
  end

  describe 'should work with only default parameters' do
    it { is_expected.to contain_postgresql__validate_db_connection('test') }
  end

  describe 'should work with all parameters' do
    let :params do
      {
        database_host: 'test',
        database_name: 'test',
        database_password: 'test',
        database_username: 'test',
        database_port: 5432,
        run_as: 'postgresq',
        sleep: 4,
        tries: 30,
      }
    end

    it { is_expected.to contain_postgresql__validate_db_connection('test') }

    it 'has proper path for validate command' do
      is_expected.to contain_exec('validate postgres connection for test@test:5432/test').with(unless: %r{^/usr/local/bin/validate_postgresql_connection.sh\s+\d+})
    end
  end

  describe 'should work while specifying validate_connection in postgresql::client' do
    let :params do
      {
        database_host: 'test',
        database_name: 'test',
        database_password: 'test',
        database_username: 'test',
        database_port: 5432,
      }
    end

    let :pre_condition do
      <<-MANIFEST
        class { 'postgresql::globals':
          module_workdir => '/var/tmp',
        } ->
        class { 'postgresql::client': validcon_script_path => '/opt/something/validate.sh' }
      MANIFEST
    end

    it 'has proper path for validate command and correct cwd' do
      is_expected.to contain_exec('validate postgres connection for test@test:5432/test').with(unless: %r{^/opt/something/validate.sh\s+\d+},
                                                                                               cwd: '/var/tmp')
    end
  end
end
