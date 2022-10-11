# frozen_string_literal: true

require 'spec_helper'

describe 'Postgresql::Pg_hba_rule_type' do
  describe 'valid values' do
    [
      'local',
      'host',
      'hostssl',
      'hostnossl',
      'hostgssenc',
      'hostnogssenc',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid values' do
    context 'with garbage inputs' do
      [
        :symbol,
        nil,
        'foobar',
        '',
        true,
        false,
        ['meep', 'meep'],
        65_538,
        [95_000, 67_000],
        {},
        { 'foo' => 'bar' },
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
