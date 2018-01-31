require 'spec_helper'

type = Puppet::Type.type(:postgresql_replication_slot)
describe type.provider(:ruby) do
  class SuccessStatus
    def success?
      true
    end
  end
  class FailStatus
    def success?
      false
    end
  end

  let(:name) { 'standby' }
  let(:resource) do
    type.new({ name: name, provider: :ruby }.merge(attributes))
  end
  let(:sql_instances) do
    "abc |        | physical  |        |          | t      |      |              | 0/3000420
def |        | physical  |        |          | t      |      |              | 0/3000420\n"
  end
  let(:success_status) { SuccessStatus.new }
  let(:fail_status) { FailStatus.new }
  let(:provider) { resource.provider }

  context 'when listing instances' do
    before(:each) do
      provider.class.expects(:run_command).with(['psql', '-t', '-c', 'SELECT * FROM pg_replication_slots;'], 'postgres', 'postgres').returns([sql_instances, nil])
    end
    let(:attributes) { {} }
    let(:instances) { provider.class.instances }
    let(:expected) { %w[abc def] }

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
        provider.class.expects(:run_command).with(
          ['psql', '-t', '-c', "SELECT * FROM pg_create_physical_replication_slot('standby');"],
          'postgres', 'postgres'
        ).returns([nil, success_status])

        expect { provider.create }.not_to raise_error
      end
    end

    context 'when creation fails' do
      it 'calls psql and fail' do
        provider.class.expects(:run_command).with(
          ['psql', '-t', '-c', "SELECT * FROM pg_create_physical_replication_slot('standby');"],
          'postgres', 'postgres'
        ).returns([nil, fail_status])

        expect { provider.create }.to raise_error(Puppet::Error, %r{Failed to create replication slot standby:})
      end
    end
  end

  context 'when destroying slot' do
    let(:attributes) { { ensure: 'absent' } }

    context 'when destruction works' do
      it 'calls psql and succeed' do
        provider.class.expects(:run_command).with(
          ['psql', '-t', '-c', "SELECT pg_drop_replication_slot('standby');"],
          'postgres', 'postgres'
        ).returns([nil, success_status])

        expect { provider.destroy }.not_to raise_error
      end
    end

    context 'when destruction fails' do
      it 'calls psql and fail' do
        provider.class.expects(:run_command).with(
          ['psql', '-t', '-c', "SELECT pg_drop_replication_slot('standby');"],
          'postgres', 'postgres'
        ).returns([nil, fail_status])

        expect { provider.destroy }.to raise_error(Puppet::Error, %r{Failed to destroy replication slot standby:})
      end
    end
  end
end
