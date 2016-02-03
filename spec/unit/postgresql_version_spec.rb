require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  describe 'postgresql_version' do
    context 'with value' do
      before :each do
        allow(Facter::Util::Resolution).to receive(:which).with('psql').and_return(true)
        allow(Facter::Util::Resolution).to receive(:exec).with('psql -V 2>&1').and_return('psql (PostgreSQL) 9.4.5')
      end
      it do
        expect(Facter.fact(:postgresql_version).value).to eq('9.4.5')
      end
    end
  end
end
