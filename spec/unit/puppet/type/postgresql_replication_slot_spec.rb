# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:postgresql_replication_slot) do
  subject do
    described_class.new(name: 'standby1_slot')
  end

  it 'has a name parameter' do
    expect(subject[:name]).to eq 'standby1_slot'
  end

  it 'accepts a valid slot name' do
    expect { described_class.new(name: 'standby1_slot') }.not_to raise_error
  end

  it 'rejects a slot name with invalid characters' do
    expect { described_class.new(name: 'Standby-1') }.to raise_error(Puppet::Error, %r{invalid}i)
  end

  it 'is ensurable' do
    expect(subject.property(:ensure)).not_to be_nil
  end

  it 'accepts ensure => present and ensure => absent' do
    expect { described_class.new(name: 'standby1_slot', ensure: :present) }.not_to raise_error
    expect { described_class.new(name: 'standby1_slot', ensure: :absent) }.not_to raise_error
  end
end
