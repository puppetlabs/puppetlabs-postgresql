# @summary This resource manages the parameters that applies to the recovery.conf template.
#
# @note
#  Allows you to create the content for recovery.conf. For more details see the usage example and the PostgreSQL documentation.
#  Every parameter value is a string set in the template except recovery_target_inclusive, pause_at_recovery_target, standby_mode and recovery_min_apply_delay.
#  A detailed description of all listed parameters can be found in the PostgreSQL documentation.
#  Only the specified parameters are recognized in the template. The recovery.conf is only created if at least one parameter is set and manage_recovery_conf is set to true.
#
# @param restore_command
# @param archive_cleanup_command
# @param recovery_end_command
# @param recovery_target_name
# @param recovery_target_time
# @param recovery_target_xid
# @param recovery_target_inclusive
# @param recovery_target
# @param recovery_target_timeline
# @param pause_at_recovery_target
# @param standby_mode Can be specified with the string ('on'/'off'), or by using a Boolean value (true/false).
# @param primary_conninfo
# @param primary_slot_name
# @param trigger_file
# @param recovery_min_apply_delay
# @param target Provides the target for the rule, and is generally an internal only property. Use with caution.
#
define postgresql::server::recovery(
  $restore_command                = undef,
  $archive_cleanup_command        = undef,
  $recovery_end_command           = undef,
  $recovery_target_name           = undef,
  $recovery_target_time           = undef,
  $recovery_target_xid            = undef,
  $recovery_target_inclusive      = undef,
  $recovery_target                = undef,
  $recovery_target_timeline       = undef,
  $pause_at_recovery_target       = undef,
  $standby_mode                   = undef,
  $primary_conninfo               = undef,
  $primary_slot_name              = undef,
  $trigger_file                   = undef,
  $recovery_min_apply_delay       = undef,
  $target                         = $postgresql::server::recovery_conf_path
) {

  if $postgresql::server::manage_recovery_conf == false {
    fail('postgresql::server::manage_recovery_conf has been disabled, so this resource is now unused and redundant, either enable that option or remove this resource from your manifests')
  } else {
    if($restore_command == undef and $archive_cleanup_command == undef and $recovery_end_command == undef
      and $recovery_target_name == undef and $recovery_target_time == undef and $recovery_target_xid == undef
      and $recovery_target_inclusive == undef and $recovery_target == undef and $recovery_target_timeline == undef
      and $pause_at_recovery_target == undef and $standby_mode == undef and $primary_conninfo == undef
      and $primary_slot_name == undef and $trigger_file == undef and $recovery_min_apply_delay == undef) {
      fail('postgresql::server::recovery use this resource but do not pass a parameter will avoid creating the recovery.conf, because it makes no sense.')
    }

    concat { $target:
      owner  => $::postgresql::server::config::user,
      group  => $::postgresql::server::config::group,
      force  => true, # do not crash if there is no recovery conf file
      mode   => '0640',
      warn   => true,
      notify => Class['postgresql::server::reload'],
    }

    # Create the recovery.conf content
    concat::fragment { 'recovery.conf':
      target  => $target,
      content => template('postgresql/recovery.conf.erb'),
    }
  }
}
