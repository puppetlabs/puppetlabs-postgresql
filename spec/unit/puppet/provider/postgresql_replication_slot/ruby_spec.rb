# frozen_string_literal: true

require 'spec_helper'

type = Puppet::Type.type(:postgresql_replication_slot)
describe type.provider(:ruby) do
  let(:name) { 'standby' }
  let(:resource) do
    type.new({ name: name, provider: :ruby }.merge(attributes))
  end
  let(:sql_instances) do
    "abc |        | physical  |        |          | t      |      |              | 0/3000420
def |        | physical  |        |          | t      |      |              | 0/3000420\n"
  end
  let(:success_status) { 0 }
  let(:fail_status) { 1 }
  let(:provider) { resource.provider }

  describe '.run_command' do
    let(:attributes) { {} }

    it 'returns the exit status of the psql command' do
      allow(Puppet::Util::Execution).to receive(:execute).and_return(Puppet::Util::Execution::ProcessOutput.new('ERROR:  oops', 1))
      expect(provider.class.send(:run_command, ['psql'], 'postgres', 'postgres')).to eq(['ERROR:  oops', 1])
    end
  end

  context 'when listing instances' do
    before(:each) do
      expect(provider.class).to receive(:run_command).with(
        ['psql', '-t', '-c', 'SELECT * FROM pg_replication_slots;'],
        'postgres', 'postgres'
      ).and_return([sql_instances, nil])
    end

    let(:attributes) { {} }
    let(:instances) { provider.class.instances }
    let(:expected) { ['abc', 'def'] }

    it 'lists instances #size' do
      expect(instances.size).to eq 2
    end

    it 'lists instances #content' do
      expected.each_with_index do |expect, index|
        expect(instances[index].name).to eq expect
      end
    end
  end

  context 'when creating slot' do
    let(:attributes) { { ensure: 'present' } }

    context 'when creation works' do
      it 'calls psql and succeed' do
        expect(provider.class).to receive(:run_command).with(
          ['psql', '-t', '-c', "SELECT * FROM pg_create_physical_replication_slot('standby');"],
          'postgres', 'postgres'
        ).and_return([nil, success_status])

        expect { provider.create }.not_to raise_error
      end
    end

    context 'when creation fails' do
      it 'calls psql and fail' do
        expect(provider.class).to receive(:run_command).with(
          ['psql', '-t', '-c', "SELECT * FROM pg_create_physical_replication_slot('standby');"],
          'postgres', 'postgres'
        ).and_return([nil, fail_status])

        expect { provider.create }.to raise_error(Puppet::Error, %r{Failed to create replication slot standby:})
      end
    end
  end

  context 'when destroying slot' do
    let(:attributes) { { ensure: 'absent' } }

    context 'when destruction works' do
      it 'calls psql and succeed' do
        expect(provider.class).to receive(:run_command).with(
          ['psql', '-t', '-c', "SELECT pg_drop_replication_slot('standby');"],
          'postgres', 'postgres'
        ).and_return([nil, success_status])

        expect { provider.destroy }.not_to raise_error
      end
    end

    context 'when destruction fails' do
      it 'calls psql and fail' do
        expect(provider.class).to receive(:run_command).with(
          ['psql', '-t', '-c', "SELECT pg_drop_replication_slot('standby');"],
          'postgres', 'postgres'
        ).and_return([nil, fail_status])

        expect { provider.destroy }.to raise_error(Puppet::Error, %r{Failed to destroy replication slot standby:})
      end
    end
  end
end
