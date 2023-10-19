# frozen_string_literal: true

require 'spec_helper'
provider_class = Puppet::Type.type(:postgresql_conf).provider(:ruby)

describe provider_class do
  let(:resource) { Puppet::Type.type(:postgresql_conf).new(name: 'foo', key: 'foo', value: 'bar') }
  let(:provider) { resource.provider }

  before(:each) do
    allow(provider).to receive(:file_path).and_return('/tmp/foo')
    allow(provider).to receive(:read_file).and_return('foo = bar')
    allow(provider).to receive(:write_file).and_return(true)
    allow(provider).to receive(:resource).and_return(key: 'your_key', line_number: 1, value: 'foo')
  end
  # rubocop:enable RSpec/ReceiveMessages

  it 'has a method parse_config' do
    expect(provider).to respond_to(:parse_config)
  end

  it 'has a method delete_header' do
    expect(provider).to respond_to(:delete_header)
  end

  it 'has a method add_header' do
    expect(provider).to respond_to(:add_header)
  end

  describe '#exists?' do
    it 'returns true when a matching config item is found' do
      config_data = [{ key: 'your_key', value: 'your_value' }]
      expect(provider).to receive(:parse_config).and_return(config_data)

      expect(provider.exists?).to be true
    end

    it 'returns false when no matching config item is found' do
      config_data = [{ key: 'other_key', value: 'other_value' }]
      expect(provider).to receive(:parse_config).and_return(config_data)

      expect(provider.exists?).to be false
    end

    it 'raises an error when multiple matching config items are found' do
      config_data = [{ key: 'your_key', value: 'value1' }, { key: 'your_key', value: 'value2' }]
      expect(provider).to receive(:parse_config).and_return(config_data)

      expect { provider.exists? }.to raise_error(Puppet::Error, 'found multiple config items of your_key, please fix this')
    end
  end

  it 'has a method create' do
    expect(provider).to respond_to(:create)
  end

  it 'has a method destroy' do
    expect(provider).to respond_to(:destroy)
  end

  it 'has a method value' do
    expect(provider).to respond_to(:value)
  end

  it 'has a method value=' do
    expect(provider).to respond_to(:value=)
  end

  it 'has a method comment' do
    expect(provider).to respond_to(:comment)
  end

  it 'has a method comment=' do
    expect(provider).to respond_to(:comment=)
  end

  it 'is an instance of the Provider Ruby' do
    expect(provider).to be_an_instance_of Puppet::Type::Postgresql_conf::ProviderRuby
  end
end
