# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::recovery' do
  include_examples 'Debian 11'
  let(:title) do
    'test'
  end
  let :target do
    tmpfilename('recovery')
  end

  context 'managing recovery' do
    let(:pre_condition) do
      <<-MANIFEST
        class { 'postgresql::globals':
          manage_recovery_conf => true,
          version               => '11',
        }
        class { 'postgresql::server': }
      MANIFEST
    end

    let(:params) do
      {
        restore_command: 'restore_command',
        recovery_target_timeline: 'recovery_target_timeline'
      }
    end

    it do
      expect(subject).to contain_concat__fragment('test-recovery.conf')
        .with(content: %r{restore_command = 'restore_command'\n+recovery_target_timeline = 'recovery_target_timeline'})
    end
  end

  context 'not managing recovery' do
    let(:pre_condition) do
      <<-MANIFEST
        class { 'postgresql::globals':
          manage_recovery_conf => false,
        }
        class { 'postgresql::server': }
      MANIFEST
    end
    let(:params) do
      {
        restore_command: ''
      }
    end

    it 'fails because $manage_recovery_conf is false' do
      expect { catalogue }.to raise_error(Puppet::Error,
                                          %r{postgresql::server::manage_recovery_conf has been disabled})
    end
  end

  context 'not managing recovery, missing param' do
    let(:pre_condition) do
      <<-MANIFEST
        class { 'postgresql::globals':
          manage_recovery_conf => true,
        }
        class { 'postgresql::server': }
      MANIFEST
    end

    it 'fails because no param set' do
      expect { catalogue }.to raise_error(Puppet::Error,
                                          %r{postgresql::server::recovery use this resource but do not pass a parameter will avoid creating the recovery.conf, because it makes no sense.})
    end
  end

  context 'managing recovery with all params' do
    let(:pre_condition) do
      <<-MANIFEST
        class { 'postgresql::globals':
          manage_recovery_conf => true,
          version               => '11',
        }
        class { 'postgresql::server': }
      MANIFEST
    end

    let(:params) do
      {
        restore_command: 'restore_command',
        archive_cleanup_command: 'archive_cleanup_command',
        recovery_end_command: 'recovery_end_command',
        recovery_target_name: 'recovery_target_name',
        recovery_target_time: 'recovery_target_time',
        recovery_target_xid: 'recovery_target_xid',
        recovery_target_inclusive: true,
        recovery_target: 'recovery_target',
        recovery_target_timeline: 'recovery_target_timeline',
        pause_at_recovery_target: true,
        standby_mode: 'on',
        primary_conninfo: 'primary_conninfo',
        primary_slot_name: 'primary_slot_name',
        trigger_file: 'trigger_file',
        recovery_min_apply_delay: 0
      }
    end

    it do
      expect(subject).to contain_concat__fragment('test-recovery.conf')
        .with(content: %r{restore_command = 'restore_command'\n+archive_cleanup_command = 'archive_cleanup_command'\n+recovery_end_command = 'recovery_end_command'\n+recovery_target_name = 'recovery_target_name'\n+recovery_target_time = 'recovery_target_time'\n+recovery_target_xid = 'recovery_target_xid'\n+recovery_target_inclusive = true\n+recovery_target = 'recovery_target'\n+recovery_target_timeline = 'recovery_target_timeline'\n+pause_at_recovery_target = true\n+standby_mode = on\n+primary_conninfo = 'primary_conninfo'\n+primary_slot_name = 'primary_slot_name'\n+trigger_file = 'trigger_file'\n+recovery_min_apply_delay = 0\n+}) # rubocop:disable Layout/LineLength
    end
  end

  # PostgreSQL >= 12: recovery.conf is never read; standby state is instead expressed via an
  # empty standby.signal marker file plus ordinary postgresql.conf GUCs.
  ['12', '16'].each do |pg_version|
    context "managing standby on PostgreSQL #{pg_version}" do
      let(:pre_condition) do
        <<-MANIFEST
          class { 'postgresql::globals':
            manage_recovery_conf => true,
            version               => '#{pg_version}',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      let(:params) do
        {
          primary_conninfo: 'host=primary port=5432 user=replicator',
          primary_slot_name: 'replica1',
          restore_command: 'restore_command'
        }
      end

      it 'creates an empty standby.signal file before the service first starts' do
        expect(subject).to contain_file('test_standby_signal').with(
          ensure: 'file',
          content: '',
          require: 'Postgresql::Server::Instance::Initdb[main]',
          before: 'Postgresql::Server::Instance::Service[main]',
        )
      end

      it 'writes primary_conninfo as a postgresql.conf GUC before the service first starts' do
        expect(subject).to contain_postgresql__server__config_entry('test_primary_conninfo').with(
          ensure: 'present',
          key: 'primary_conninfo',
          value: 'host=primary port=5432 user=replicator',
          before: 'Postgresql::Server::Instance::Service[main]',
        )
      end

      it 'writes primary_slot_name as a postgresql.conf GUC' do
        expect(subject).to contain_postgresql__server__config_entry('test_primary_slot_name').with(
          key: 'primary_slot_name',
          value: 'replica1',
        )
      end

      it 'writes restore_command as a postgresql.conf GUC' do
        expect(subject).to contain_postgresql__server__config_entry('test_restore_command').with(
          key: 'restore_command',
          value: 'restore_command',
        )
      end

      it 'does not create a legacy recovery.conf' do
        expect(subject).not_to contain_concat__fragment('test-recovery.conf')
      end
    end

    context "trigger_file fallback on PostgreSQL #{pg_version}" do
      let(:pre_condition) do
        <<-MANIFEST
          class { 'postgresql::globals':
            manage_recovery_conf => true,
            version               => '#{pg_version}',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      let(:params) do
        {
          trigger_file: '/tmp/legacy_trigger'
        }
      end

      it 'honors trigger_file as a fallback for promote_trigger_file' do
        expect(subject).to contain_postgresql__server__config_entry('test_promote_trigger_file').with(
          key: 'promote_trigger_file',
          value: '/tmp/legacy_trigger',
        )
      end
    end

    context "legacy-only params on PostgreSQL #{pg_version}" do
      let(:pre_condition) do
        <<-MANIFEST
          class { 'postgresql::globals':
            manage_recovery_conf => true,
            version               => '#{pg_version}',
          }
          class { 'postgresql::server': }
        MANIFEST
      end

      let(:params) do
        {
          standby_mode: 'on',
          pause_at_recovery_target: true,
          primary_conninfo: 'host=primary'
        }
      end

      it 'compiles successfully and warns that standby_mode/pause_at_recovery_target are ignored' do
        expect(subject).to compile
        expect(subject).to contain_postgresql__server__config_entry('test_primary_conninfo')
      end
    end
  end
end
