require 'spec_helper_acceptance'

describe 'postgresql::server::recovery' do
  describe 'should manage recovery' do
    after(:all) do
      pp = <<-MANIFEST.unindent
        file { '/tmp/recovery.conf':
          ensure => absent,
        }
      MANIFEST

      apply_manifest(pp, catch_failures: true)
    end

    pp = <<-MANIFEST.unindent
      class { 'postgresql::globals':
        recovery_conf_path => '/tmp/recovery.conf',
        manage_recovery_conf => true,
      }

      class { 'postgresql::server': }

      # Create a recovery.conf file
      postgresql::server::recovery { "recovery.conf":
        restore_command          => 'restore_command',
        recovery_target_timeline => 'recovery_target_timeline',
      }
    MANIFEST
    it 'adds conf file' do
      idempotent_apply(pp)
    end

    describe file('/tmp/recovery.conf') do
      it { is_expected.to be_file }
      it { is_expected.to contain %r{restore_command = 'restore_command'} }
      it { is_expected.to contain %r{recovery_target_timeline = 'recovery_target_timeline'} }
    end
  end

  describe 'should not create recovery if recovery config not specified' do
    it 'does not add conf file' do
      pp = <<-EOS.unindent
        class { 'postgresql::globals':
          recovery_conf_path => '/tmp/recovery.conf',
          manage_recovery_conf => true,
        }

        class { 'postgresql::server': }
      EOS

      idempotent_apply(pp)
    end

    describe file('/tmp/recovery.conf') do
      it { is_expected.not_to be_file }
    end
  end
end
