require 'spec_helper'

describe Puppet::Type.type(:postgresql_psql) do # rubocop:disable RSpec/MultipleDescribes
  context 'when validating attributes' do
    [:name, :unless, :db, :psql_path, :psql_user, :psql_group, :connect_settings].each do |attr|
      it "should have a #{attr} parameter" do
        expect(Puppet::Type.type(:postgresql_psql).attrtype(attr)).to eq(:param)
      end
    end

    [:command].each do |attr|
      it "should have a #{attr} property" do
        expect(Puppet::Type.type(:postgresql_psql).attrtype(attr)).to eq(:property)
      end
    end
  end
end

describe Puppet::Type.type(:postgresql_psql), unless: Puppet.features.microsoft_windows? do
  subject do
    Puppet::Type.type(:postgresql_psql).new({ name: 'rspec' }.merge(attributes))
  end

  describe 'available attributes' do
    {
      name: 'rspec',
      command: 'SELECT stuff',
      unless: 'SELECT other,stuff',
      db: 'postgres',
      psql_path: '/bin/false',
      psql_user: 'postgres',
      psql_group: 'postgres',
      cwd: '/var/lib',
      refreshonly: :true,
      search_path: ['schema1', 'schema2'],
      connect_settings: { 'PGHOST' => 'postgres-db-server',
                          'DBVERSION' => '9.1' },
    }.each do |attr, value|
      context attr do
        describe [attr]
        subject { super()[attr] }

        let(:attributes) { { attr => value } }

        it { is_expected.to eq(value) }
      end
    end
    let(:attributes) { {} }

    context 'default value: [:psql_path]' do
      subject { super()[:psql_path] }

      it { is_expected.to eq('psql') }
    end
    context 'default value: [:psql_user]' do
      subject { super()[:psql_user] }

      it { is_expected.to eq('postgres') }
    end
    context 'default value: [:psql_group]' do
      subject { super()[:psql_group] }

      it { is_expected.to eq('postgres') }
    end
    context 'default value: [:cwd]' do
      subject { super()[:cwd] }

      it { is_expected.to eq('/tmp') }
    end
    context 'default value: #refreshonly?' do
      subject { super().refreshonly? }

      it { is_expected.to be_falsey }
    end
  end

  # rubocop:disable RSpec/NamedSubject
  # rubocop:disable RSpec/SubjectStub
  describe '#command' do
    let(:attributes) { { command: 'SELECT stuff' } }

    it 'will have the value :notrun if the command should execute' do
      expect(subject).to receive(:should_run_sql).and_return(true)
      expect(subject.property(:command).retrieve).to eq(:notrun)
    end

    it "will be the 'should' value if the command should not execute" do
      expect(subject).to receive(:should_run_sql).and_return(false)
      expect(subject.property(:command).retrieve).to eq('SELECT stuff')
    end

    it 'will call provider#run_sql_command on sync' do
      expect(subject.provider).to receive(:run_sql_command).with('SELECT stuff').and_return(['done', 0])
      subject.property(:command).sync
    end
  end

  describe '#unless' do
    let(:attributes) { { unless: 'SELECT something' } }

    describe '#matches' do
      it 'does not fail when the status is successful' do
        expect(subject.provider).to receive(:run_unless_sql_command).and_return ['1 row returned', 0]
        subject.parameter(:unless).matches('SELECT something')
      end

      it 'returns true when rows are returned' do
        expect(subject.provider).to receive(:run_unless_sql_command).and_return ['1 row returned', 0]
        expect(subject.parameter(:unless).matches('SELECT something')).to be_truthy
      end

      it 'returns false when no rows are returned' do
        expect(subject.provider).to receive(:run_unless_sql_command).and_return ['0 rows returned', 0]
        expect(subject.parameter(:unless).matches('SELECT something')).to be_falsey
      end

      it 'raises an error when the sql command fails' do
        allow(subject.provider).to receive(:run_unless_sql_command).and_return ['Something went wrong', 1]
        expect {
          subject.parameter(:unless).matches('SELECT something')
        }.to raise_error(Puppet::Error, %r{Something went wrong})
      end
    end
  end

  describe "#should_run_sql without 'unless'" do
    [true, :true].each do |refreshonly|
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly }
        end

        context 'not refreshing'
        it { expect(subject.should_run_sql).to be_falsey }
      end
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly }
        end

        context 'refreshing'
        it { expect(subject.should_run_sql(true)).to be_truthy }
      end
    end

    [false, :false].each do |refreshonly|
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly }
        end

        context 'not refreshing'
        it { expect(subject.should_run_sql).to be_truthy }
      end
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly }
        end

        context 'refreshing'
        it { expect(subject.should_run_sql(true)).to be_truthy }
      end
    end
  end

  describe "#should_run_sql with matching 'unless'" do
    before(:each) { expect(subject.parameter(:unless)).to receive(:matches).with('SELECT something').and_return(true) } # rubocop:disable RSpec/ExpectInHook

    [true, :true].each do |refreshonly|
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'not refreshing'
        it { expect(subject.should_run_sql).to be_falsey }
      end
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'refreshing'
        it { expect(subject.should_run_sql(true)).to be_falsey }
      end
    end

    [false, :false].each do |refreshonly|
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'not refreshing'
        it { expect(subject.should_run_sql).to be_falsey }
      end
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'refreshing'
        it { expect(subject.should_run_sql(true)).to be_falsey }
      end
    end
  end

  describe "#should_run_sql when not matching 'unless'" do
    before(:each) { expect(subject.parameter(:unless)).to receive(:matches).with('SELECT something').and_return(false) } # rubocop:disable RSpec/ExpectInHook

    [true, :true].each do |refreshonly|
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'not refreshing'
        it { expect(subject.should_run_sql).to be_falsey }
      end
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'refreshing'
        it { expect(subject.should_run_sql(true)).to be_truthy }
      end
    end

    [false, :false].each do |refreshonly|
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'not refreshing'
        it { expect(subject.should_run_sql).to be_truthy }
      end
      context "refreshonly => #{refreshonly.inspect}" do
        let(:attributes) do
          { refreshonly: refreshonly, unless: 'SELECT something' }
        end

        context 'refreshing'
        it { expect(subject.should_run_sql(true)).to be_truthy }
      end
    end
  end

  describe '#refresh' do
    let(:attributes) { {} }

    it 'syncs command property when command should run' do
      expect(subject).to receive(:should_run_sql).with(true).and_return(true)
      expect(subject.property(:command)).to receive(:sync)
      subject.refresh
    end

    it 'does not sync command property when command should not run' do
      expect(subject).to receive(:should_run_sql).with(true).and_return(false)
      expect(subject.property(:command)).not_to receive(:sync)
      subject.refresh
    end
  end
end
