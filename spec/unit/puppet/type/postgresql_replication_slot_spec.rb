require 'spec_helper'

describe Puppet::Type.type(:postgresql_replication_slot) do
  subject do
    Puppet::Type.type(:postgresql_psql).new(name: 'standby')
  end

  it 'has a name parameter' do
    expect(subject[:name]).to eq 'standby' # rubocop:disable RSpec/NamedSubject
  end
end
