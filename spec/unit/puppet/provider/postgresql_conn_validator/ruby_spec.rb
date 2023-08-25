# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:postgresql_conn_validator).provider(:ruby) do
  let(:resource) do
    Puppet::Type.type(:postgresql_conn_validator).new({
      name: 'testname',
    }.merge(attributes))
  end
  let(:provider) { resource.provider }
  let(:attributes) do
    {
      psql_path: '/usr/bin/psql',
      host: 'db.test.com',
      port: 4444,
      db_username: 'testuser',
      db_password: 'testpass',
    }
  end
  let(:connect_settings) do
    {
      connect_settings: {
        PGPASSWORD: 'testpass',
        PGHOST: 'db.test.com',
        PGPORT: '1234',
      },
    }
  end

  describe '#build_psql_cmd' do
    it 'contains expected commandline options' do
      expect(provider.validator.build_psql_cmd).to eq(['/usr/bin/psql', '--tuples-only', '--quiet', '--no-psqlrc', '--host', 'db.test.com', '--port', 4444, '--username', 'testuser', '--command',
                                                       'SELECT 1'])
    end
  end

  describe 'connect_settings' do
    it 'returns array if password is present' do
      expect(provider.validator.connect_settings).to eq({ 'PGPASSWORD' => 'testpass' })
    end

    it 'returns an empty array if password is nil' do
      attributes.delete(:db_password)
      expect(provider.validator.connect_settings).to eq({})
    end

    it 'returns an array of settings' do
      attributes.delete(:db_password)
      attributes.merge! connect_settings
      expect(provider.validator.connect_settings).to eq({ PGHOST: 'db.test.com', PGPASSWORD: 'testpass', PGPORT: '1234' })
    end
  end

  describe '#attempt_connection' do
    let(:sleep_length) { 1 }
    let(:tries) { 3 }

    it 'tries the correct number of times' do
      provider.validator.attempt_connection(sleep_length, tries)
    end
  end
end
