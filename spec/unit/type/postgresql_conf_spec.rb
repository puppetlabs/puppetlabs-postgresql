# frozen_string_literal: true

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
    [:name, :provider, :target].each do |param|
      it "has a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end

    [:value, :comment].each do |property|
      it "has a #{property} property" do
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
    # boolean https://www.postgresql.org/docs/current/datatype-boolean.html
    describe 'validate boolean values with newvalues function' do
      it 'validates log_checkpoints with value on' do
        expect { described_class.new(name: 'log_checkpoints', value: 'on') }.not_to raise_error
      end
      it 'validates log_checkpoints with value off' do
        expect { described_class.new(name: 'log_checkpoints', value: 'off') }.not_to raise_error
      end
      it 'validates log_checkpoints with value true' do
        expect { described_class.new(name: 'log_checkpoints', value: 'true') }.not_to raise_error
      end
      it 'validates log_checkpoints with value false' do
        expect { described_class.new(name: 'log_checkpoints', value: 'false') }.not_to raise_error
      end
      it 'validates log_checkpoints with value yes' do
        expect { described_class.new(name: 'log_checkpoints', value: 'yes') }.not_to raise_error
      end
      it 'validates log_checkpoints with value no' do
        expect { described_class.new(name: 'log_checkpoints', value: 'no') }.not_to raise_error
      end
      it 'validates log_checkpoints with value 1' do
        expect { described_class.new(name: 'log_checkpoints', value: '1') }.not_to raise_error
      end
      it 'validates log_checkpoints with value 0' do
        expect { described_class.new(name: 'log_checkpoints', value: '0') }.not_to raise_error
      end
    end
    # enums https://www.postgresql.org/docs/current/datatype-enum.html
    describe 'validate enum values with newvalues function' do
      it 'validates ssl_min_protocol_version with value TLSv1.3' do
        expect { described_class.new(name: 'ssl_min_protocol_version', value: 'TLSv1.3') }.not_to raise_error
      end
      it 'validates ssl_min_protocol_version with value TLSv1.1' do
        expect { described_class.new(name: 'ssl_min_protocol_version', value: 'TLSv1.1') }.not_to raise_error
      end
    end
    # integer https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-INT
    describe 'validate integer values with newvalues function' do
      it 'validates max_connections with value 1000' do
        expect { described_class.new(name: 'max_connections', value: '1000') }.not_to raise_error
      end
    end
    # real https://www.postgresql.org/docs/current/datatype-numeric.html#DATATYPE-FLOAT
    describe 'validate real values with newvalues function' do
      it 'validates parallel_tuple_cost with value 0.3' do
        expect { described_class.new(name: 'parallel_tuple_cost', value: '0.3') }.not_to raise_error
      end
    end
    # string https://www.postgresql.org/docs/current/datatype-character.html
    describe 'validate complex string values with newvalues function' do
      it 'validates log_line_prefix with value [%p] %q:%u:%d:%' do
        expect { described_class.new(name: 'log_line_prefix', value: '[%p] %q:%u:%d:%x ') }.not_to raise_error
      end
      it 'validates log_line_prefix with value %t %q%u@%d %p %i' do
        expect { described_class.new(name: 'log_line_prefix', value: '%t %q%u@%d %p %i ') }.not_to raise_error
      end
      it 'validates log_filename with value psql_01-%Y-%m-%d.log' do
        expect { described_class.new(name: 'log_filename', value: 'psql_01-%Y-%m-%d.log') }.not_to raise_error
      end
    end
    # string https://www.postgresql.org/docs/current/datatype-character.html
    describe 'validate string values with newvalues function' do
      it 'validates log_timezone with value UTC' do
        expect { described_class.new(name: 'log_timezone', value: 'UTC') }.not_to raise_error
      end
      it 'validates ssl_ciphers with value HIGH:MEDIUM:+3DES:!aNULL' do
        expect { described_class.new(name: 'ssl_ciphers', value: 'HIGH:MEDIUM:+3DES:!aNULL') }.not_to raise_error
      end
    end
  end
end
