# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::postgresql_acls_to_resources_hash' do
  it { is_expected.not_to eq(nil) }
  context 'individual transform tests' do
    it do
      input = 'local   all             postgres                                ident'
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'local',
          'database'    => 'all',
          'user'        => 'postgres',
          'auth_method' => 'ident',
          'order'       => '100',
        },
      }
      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end

    it do
      input = 'local   all             root                                ident'
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'local',
          'database'    => 'all',
          'user'        => 'root',
          'auth_method' => 'ident',
          'order'       => '100',
        },
      }
      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end

    it do
      input_array = ['local   all             all                                     ident']
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'local',
          'database'    => 'all',
          'user'        => 'all',
          'auth_method' => 'ident',
          'order'       => '100',
        },
      }
      is_expected.to run.with_params(input_array, 'test', 100).and_return(result)
    end

    it do
      input = 'host    all             all             127.0.0.1/32            md5'
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'host',
          'database'    => 'all',
          'user'        => 'all',
          'address'     => '127.0.0.1/32',
          'auth_method' => 'md5',
          'order'       => '100',
        },
      }
      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end

    it do
      input = 'host    all             all             0.0.0.0/0            md5'
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'host',
          'database'    => 'all',
          'user'        => 'all',
          'address'     => '0.0.0.0/0',
          'auth_method' => 'md5',
          'order'       => '100',
        },
      }
      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end

    it do
      input = 'host    all             all             ::1/128                 md5'
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'host',
          'database'    => 'all',
          'user'        => 'all',
          'address'     => '::1/128',
          'auth_method' => 'md5',
          'order'       => '100',
        },
      }
      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end

    it do
      input = 'host    all             all             1.1.1.1 255.255.255.0    md5'
      result = {
        'postgresql class generated rule test 0' => {
          'type'        => 'host',
          'database'    => 'all',
          'user'        => 'all',
          'address'     => '1.1.1.1 255.255.255.0',
          'auth_method' => 'md5',
          'order'       => '100',
        },
      }

      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end

    it do
      input = 'host    all             all             1.1.1.1 255.255.255.0   ldap ldapserver=ldap.example.net ldapprefix="cn=" ldapsuffix=", dc=example, dc=net"'
      result = {
        'postgresql class generated rule test 0' => {
          'type' => 'host',
          'database' => 'all',
          'user'        => 'all',
          'address'     => '1.1.1.1 255.255.255.0',
          'auth_method' => 'ldap',
          'auth_option' => 'ldapserver=ldap.example.net ldapprefix="cn=" ldapsuffix=", dc=example, dc=net"',
          'order'       => '100',
        },
      }

      is_expected.to run.with_params([input], 'test', 100).and_return(result)
    end
  end

  context 'error catching tests' do
    it do
      is_expected.to run.with_params(['test'], 'test').and_raise_error(%r{expects 3 arguments, got 2})
    end

    it do
      is_expected.to run.with_params('test', 'test', 100).and_raise_error(%r{parameter 'acls' expects an Array value, got String})
    end

    it do
      is_expected.to run.with_params(['test'], 100, 'test').and_raise_error(%r{parameter 'id' expects a String value, got Integer})
    end

    it do
      is_expected.to run.with_params(['test'], 'test', 1).and_raise_error(%r{does not have enough parts})
    end
  end

  it 'returns an empty hash when input is empty array' do
    is_expected.to run.with_params([], 'test', 100).and_return({})
  end
end
