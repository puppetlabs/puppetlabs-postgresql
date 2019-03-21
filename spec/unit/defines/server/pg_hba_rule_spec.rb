require 'spec_helper'

describe 'postgresql::server::pg_hba_rule', type: :define do
  let :facts do
    {
      osfamily: 'Debian',
      operatingsystem: 'Debian',
      operatingsystemrelease: '8.0',
      kernel: 'Linux',
      concat_basedir: tmpfilename('pg_hba'),
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end
  let :title do
    'test'
  end
  let :target do
    tmpfilename('pg_hba_rule')
  end

  context 'test template 1' do
    let :pre_condition do
      <<-MANIFEST
        class { 'postgresql::server': }
      MANIFEST
    end

    let :params do
      {
        type: 'host',
        database: 'all',
        user: 'all',
        address: '1.1.1.1/24',
        auth_method: 'md5',
        target: target,
      }
    end

    it do
      is_expected.to contain_concat__fragment('pg_hba_rule_test').with(content: %r{host\s+all\s+all\s+1\.1\.1\.1\/24\s+md5})
    end
  end

  context 'test template 2' do
    let :pre_condition do
      <<-MANIFEST
        class { 'postgresql::server': }
      MANIFEST
    end

    let :params do
      {
        type: 'local',
        database: 'all',
        user: 'all',
        auth_method: 'ident',
        target: target,
      }
    end

    it do
      is_expected.to contain_concat__fragment('pg_hba_rule_test').with(content: %r{local\s+all\s+all\s+ident})
    end
  end

  context 'test template 3' do
    let :pre_condition do
      <<-MANIFEST
        class { 'postgresql::server': }
      MANIFEST
    end

    let :params do
      {
        type: 'host',
        database: 'all',
        user: 'all',
        address: '0.0.0.0/0',
        auth_method: 'ldap',
        auth_option: 'foo=bar',
        target: target,
      }
    end

    it do
      is_expected.to contain_concat__fragment('pg_hba_rule_test').with(content: %r{host\s+all\s+all\s+0\.0\.0\.0\/0\s+ldap\s+foo=bar})
    end
  end

  context 'validation' do
    context 'validate supported auth_method' do
      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::globals':
            version => '9.2',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      let :params do
        {
          type: 'local',
          database: 'all',
          user: 'all',
          address: '0.0.0.0/0',
          auth_method: 'peer',
          target: target,
        }
      end

      it do
        is_expected.to contain_concat__fragment('pg_hba_rule_test').with(
          content: %r{local\s+all\s+all\s+0\.0\.0\.0\/0\s+peer},
        )
      end
    end

    context 'allows scram-sha-256 on postgres 10' do
      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::globals':
            version => '10',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      let :params do
        {
          type: 'local',
          database: 'all',
          user: 'all',
          address: '0.0.0.0/0',
          auth_method: 'scram-sha-256',
          target: target,
        }
      end

      it do
        is_expected.to contain_concat__fragment('pg_hba_rule_test').with(
          content: %r{local\s+all\s+all\s+0\.0\.0\.0\/0\s+scram-sha-256},
        )
      end
    end
  end

  context 'order' do
    context 'default' do
      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::server': }
        MANIFEST
      end

      let :params do
        {
          type: 'local',
          database: 'all',
          user: 'all',
          auth_method: 'ident',
        }
      end

      it do
        is_expected.to contain_concat__fragment('pg_hba_rule_test').with(order: '150')
      end
    end

    context 'string' do
      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::server': }
        MANIFEST
      end

      let :params do
        {
          type: 'local',
          database: 'all',
          user: 'all',
          auth_method: 'ident',
          order: '12',
        }
      end

      it do
        is_expected.to contain_concat__fragment('pg_hba_rule_test').with(order: '12')
      end
    end

    context 'short integer' do
      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::server': }
        MANIFEST
      end

      let :params do
        {
          type: 'local',
          database: 'all',
          user: 'all',
          auth_method: 'ident',
          order: 12,
        }
      end

      it do
        is_expected.to contain_concat__fragment('pg_hba_rule_test').with(order: '012')
      end
    end

    context 'long integer' do
      let :pre_condition do
        <<-MANIFEST
          class { 'postgresql::server': }
        MANIFEST
      end

      let :params do
        {
          type: 'local',
          database: 'all',
          user: 'all',
          auth_method: 'ident',
          order: 1234,
        }
      end

      it do
        is_expected.to contain_concat__fragment('pg_hba_rule_test').with(order: '1234')
      end
    end
  end
end
