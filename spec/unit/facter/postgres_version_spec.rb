require 'spec_helper'

describe Facter::Util::Fact.to_s do
  before(:each) do
    Facter.clear
  end

  describe 'postgres_version' do
    context 'with value' do
      before :each do
        allow(Facter::Core::Execution).to receive(:which).and_return('/usr/bin/postgres')
        allow(Facter::Core::Execution).to receive(:execute).with('postgres -V 2>/dev/null').and_return('postgres (PostgreSQL) 10.0')
      end

      it 'postgres_version' do
        expect(Facter.fact(:postgres_version).value).to eq('10.0')
      end
    end
  end
end
