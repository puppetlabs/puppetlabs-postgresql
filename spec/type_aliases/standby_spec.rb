# frozen_string_literal: true

require 'spec_helper'

describe 'Postgresql::Standby' do
  context 'base valid data' do
    let :data do
      {
        my_replica: {
          primary_conninfo: 'host=primary port=5432 user=replicator',
          primary_slot_name: 'replica1',
          restore_command: 'cp /archive/%f %p'
        }
      }
    end

    it { is_expected.to allow_value(data) }
  end

  context 'empty' do
    let :data do
      {}
    end

    it { is_expected.to allow_value(data) }
  end

  context 'empty value' do
    let :data do
      {
        my_replica: {}
      }
    end

    it { is_expected.to allow_value(data) }
  end

  context 'invalid primary_slot_name' do
    let :data do
      {
        my_replica: {
          primary_slot_name: 'Not A Valid Slot Name!'
        }
      }
    end

    it { is_expected.not_to allow_value(data) }
  end

  context 'invalid recovery_target_action' do
    let :data do
      {
        my_replica: {
          recovery_target_action: 'reboot'
        }
      }
    end

    it { is_expected.not_to allow_value(data) }
  end

  context 'not a hash' do
    let :data do
      'my_replica'
    end

    it { is_expected.not_to allow_value(data) }
  end
end
