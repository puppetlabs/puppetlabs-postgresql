#! /usr/bin/env ruby # rubocop:disable Lint/ScriptPermission
require 'spec_helper'

describe Puppet::Type.type(:postgresql_conf) do
  before(:each) do
    @provider_class = described_class.provide(:simple) { mk_resource_methods }
    allow(@provider_class).to receive(:suitable?).and_return true # rubocop:disable RSpec/InstanceVariable
    allow(described_class).to receive(:defaultprovider).and_return @provider_class # rubocop:disable RSpec/InstanceVariable
  end

  describe 'namevar validation' do
    it 'has :name as its namevar' do
      expect(described_class.key_attributes).to eq([:name])
    end
    it 'does not invalid names' do
      expect { described_class.new(name: 'foo bar') }.to raise_error(Puppet::Error, %r{Invalid value})
    end
    it 'allows dots in names' do
      expect { described_class.new(name: 'foo.bar') }.not_to raise_error
    end
  end

  describe 'when validating attributes' do
    [:name, :provider].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end

    [:value, :target].each do |property|
      it "should have a #{property} property" do
        expect(described_class.attrtype(property)).to eq(:property)
      end
    end
  end

  describe 'when validating values' do
    describe 'ensure' do
      it 'supports present as a value for ensure' do
        expect { described_class.new(name: 'foo', ensure: :present) }.not_to raise_error
      end
      it 'supports absent as a value for ensure' do
        expect { described_class.new(name: 'foo', ensure: :absent) }.not_to raise_error
      end
      it 'does not support other values' do
        expect { described_class.new(name: 'foo', ensure: :foo) }.to raise_error(Puppet::Error, %r{Invalid value})
      end
    end
  end
end
