# @summary This resource manages the parameters that applies to the recovery.conf template.
#
# @note
#  Allows you to create the content for recovery.conf. For more details see the usage example and the PostgreSQL documentation.
#  Every parameter value is a string set in the template except recovery_target_inclusive, pause_at_recovery_target, standby_mode and recovery_min_apply_delay.
#  A detailed description of all listed parameters can be found in the PostgreSQL documentation.
#  Only the specified parameters are recognized in the template. The recovery.conf is only created if at least one parameter is set and manage_recovery_conf is set to true.
#
# @param restore_command The shell command to execute to retrieve an archived segment of the WAL file series.
# @param archive_cleanup_command This optional parameter specifies a shell command that will be executed at every restartpoint.
# @param recovery_end_command This parameter specifies a shell command that will be executed once only at the end of recovery.
# @param recovery_target_name This parameter specifies the named restore point (created with pg_create_restore_point()) to which recovery will proceed.
# @param recovery_target_time This parameter specifies the time stamp up to which recovery will proceed.
# @param recovery_target_xid This parameter specifies the transaction ID up to which recovery will proceed.
# @param recovery_target_inclusive Specifies whether to stop just after the specified recovery target (true), or just before the recovery target (false).
# @param recovery_target This parameter specifies that recovery should end as soon as a consistent state is reached, i.e. as early as possible.
# @param recovery_target_timeline Specifies recovering into a particular timeline.
# @param pause_at_recovery_target Specifies whether recovery should pause when the recovery target is reached.
# @param standby_mode Specifies whether to start the PostgreSQL server as a standby.
# @param primary_conninfo  Specifies a connection string to be used for the standby server to connect with the primary.
# @param primary_slot_name Optionally specifies an existing replication slot to be used when connecting to the primary via streaming replication to control resource removal on the upstream node.
# @param trigger_file Specifies a trigger file whose presence ends recovery in the standby.
# @param recovery_min_apply_delay This parameter allows you to delay recovery by a fixed period of time, measured in milliseconds if no unit is specified.
# @param target Provides the target for the rule, and is generally an internal only property. Use with caution.
define postgresql::server::recovery (
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
      owner  => $postgresql::server::config::user,
      group  => $postgresql::server::config::group,
      force  => true, # do not crash if there is no recovery conf file
      mode   => '0640',
      warn   => true,
      notify => Class['postgresql::server::reload'],
    }

    # Create the recovery.conf content
    concat::fragment { "${name}-recovery.conf":
      target  => $target,
      content => template('postgresql/recovery.conf.erb'),
    }
  }
}
