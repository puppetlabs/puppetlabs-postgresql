# frozen_string_literal: true

require 'spec_helper'
require 'facter/postgresql_version'

describe :postgresql_version do

  after :each do
    Facter.clear
  end

  it 'returns server version 18.6' do
    allow(Facter::Core::Execution).to receive(:which).with('postgres').and_return('/usr/bin/postgres')
    allow(Facter::Core::Execution).to receive(:execute).with('/usr/bin/postgres --version').and_return("postgres (PostgreSQL) 18.6\n")
    expect(Facter.value(:postgresql_version)).to eq('18.6')
  end

  it 'returns no fact when postgres is not in PATH' do
    allow(Facter::Core::Execution).to receive(:which).with('postgres').and_return(nil)
    expect(Facter::Core::Execution).not_to receive(:execute)
    expect(Facter.value(:postgresql_version)).to be_nil
  end
end
