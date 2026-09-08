# @summary This resource manages the parameters that apply to standby/recovery configuration.
#
# @note
#  On PostgreSQL < 12 this creates the content for recovery.conf. For more details see the usage example and the PostgreSQL
#  documentation. Every parameter value is a string set in the template except recovery_target_inclusive, pause_at_recovery_target,
#  standby_mode and recovery_min_apply_delay. A detailed description of all listed parameters can be found in the PostgreSQL
#  documentation. Only the specified parameters are recognized in the template. The recovery.conf is only created if at least one
#  parameter is set and manage_recovery_conf is set to true.
#
#  On PostgreSQL >= 12, recovery.conf is never read by PostgreSQL. Instead this creates an empty standby.signal marker file and
#  writes the recovery-relevant settings (primary_conninfo, primary_slot_name, restore_command, etc.) as ordinary postgresql.conf
#  GUCs via postgresql::server::config_entry, since that is how PostgreSQL 12 and later expect standby/recovery configuration to
#  be supplied. standby_mode, trigger_file and pause_at_recovery_target are legacy-only concepts on 12+: standby_mode is replaced
#  by the mere presence of standby.signal, trigger_file was renamed to promote_trigger_file, and pause_at_recovery_target was
#  replaced by recovery_target_action. If any of the three legacy-only parameters are set on PostgreSQL >= 12, a warning is
#  raised and they are otherwise ignored (trigger_file is still honored as a fallback value for promote_trigger_file).
#
# @param restore_command The shell command to execute to retrieve an archived segment of the WAL file series.
# @param archive_cleanup_command This optional parameter specifies a shell command that will be executed at every restartpoint.
# @param recovery_end_command This parameter specifies a shell command that will be executed once only at the end of recovery.
# @param recovery_target_name
#   This parameter specifies the named restore point (created with pg_create_restore_point()) to which recovery will proceed.
# @param recovery_target_time This parameter specifies the time stamp up to which recovery will proceed.
# @param recovery_target_xid This parameter specifies the transaction ID up to which recovery will proceed.
# @param recovery_target_inclusive
#   Specifies whether to stop just after the specified recovery target (true), or just before the recovery target (false).
# @param recovery_target
#   This parameter specifies that recovery should end as soon as a consistent state is reached, i.e. as early as possible.
# @param recovery_target_timeline Specifies recovering into a particular timeline.
# @param recovery_target_action
#   PostgreSQL >= 12 only. Specifies what action the server should take once the recovery target is reached: 'pause', 'promote' or
#   'shutdown'. Replaces the legacy pause_at_recovery_target boolean.
# @param pause_at_recovery_target
#   PostgreSQL < 12 only. Specifies whether recovery should pause when the recovery target is reached. Ignored (with a warning) on
#   PostgreSQL >= 12 — use recovery_target_action instead.
# @param standby_mode
#   PostgreSQL < 12 only. Specifies whether to start the PostgreSQL server as a standby. Ignored (with a warning) on PostgreSQL >= 12,
#   where standby state is instead determined purely by the presence of the standby.signal file.
# @param primary_conninfo  Specifies a connection string to be used for the standby server to connect with the primary.
# @param primary_slot_name
#   Optionally specifies an existing replication slot to be used when connecting to the primary via streaming replication to control
#   resource removal on the upstream node.
# @param trigger_file
#   PostgreSQL < 12 only. Specifies a trigger file whose presence ends recovery in the standby. On PostgreSQL >= 12 this is used only
#   as a fallback value for promote_trigger_file if that is not also set, with a warning.
# @param promote_trigger_file
#   PostgreSQL >= 12 only. Specifies a trigger file whose presence ends recovery in the standby. This is the PG12+ rename of
#   trigger_file.
# @param recovery_min_apply_delay
#   This parameter allows you to delay recovery by a fixed period of time, measured in milliseconds if no unit is specified.
# @param target Provides the target for the rule, and is generally an internal only property. Use with caution. PostgreSQL < 12 only.
define postgresql::server::recovery (
  Optional[String]    $restore_command           = undef,
  Optional[String[1]] $archive_cleanup_command   = undef,
  Optional[String[1]] $recovery_end_command      = undef,
  Optional[String[1]] $recovery_target_name      = undef,
  Optional[String[1]] $recovery_target_time      = undef,
  Optional[String[1]] $recovery_target_xid       = undef,
  Optional[Boolean]   $recovery_target_inclusive = undef,
  Optional[String[1]] $recovery_target           = undef,
  Optional[String[1]] $recovery_target_timeline  = undef,
  Optional[Enum['pause', 'promote', 'shutdown']] $recovery_target_action = undef,
  Optional[Boolean]   $pause_at_recovery_target  = undef,
  Optional[String[1]] $standby_mode              = undef,
  Optional[String[1]] $primary_conninfo          = undef,
  Optional[String[1]] $primary_slot_name         = undef,
  Optional[String[1]] $trigger_file              = undef,
  Optional[String[1]] $promote_trigger_file      = undef,
  Optional[Integer]   $recovery_min_apply_delay  = undef,
  Stdlib::Absolutepath $target                   = $postgresql::server::recovery_conf_path
) {
  if $postgresql::server::manage_recovery_conf == false {
    fail('postgresql::server::manage_recovery_conf has been disabled, so this resource is now unused and redundant, either enable that option or remove this resource from your manifests') # lint:ignore:140chars
  } else {
    if($restore_command == undef and $archive_cleanup_command == undef and $recovery_end_command == undef
      and $recovery_target_name == undef and $recovery_target_time == undef and $recovery_target_xid == undef
      and $recovery_target_inclusive == undef and $recovery_target == undef and $recovery_target_timeline == undef
      and $recovery_target_action == undef and $pause_at_recovery_target == undef and $standby_mode == undef
      and $primary_conninfo == undef and $primary_slot_name == undef and $trigger_file == undef
    and $promote_trigger_file == undef and $recovery_min_apply_delay == undef) {
      fail('postgresql::server::recovery use this resource but do not pass a parameter will avoid creating the recovery.conf, because it makes no sense.') # lint:ignore:140chars
    }

    $_version = $postgresql::server::_version

    if versioncmp($_version, '12') < 0 {
      # ---------------- PostgreSQL < 12: recovery.conf (legacy, unchanged) ----------------
      concat { $target:
        owner  => $postgresql::server::user,
        group  => $postgresql::server::group,
        force  => true, # do not crash if there is no recovery conf file
        mode   => '0640',
        warn   => true,
        notify => Postgresql::Server::Instance::Reload['main'],
      }

      # Create the recovery.conf content
      concat::fragment { "${name}-recovery.conf":
        target  => $target,
        content => epp('postgresql/recovery.conf.epp', {
            restore_command           => $restore_command,
            archive_cleanup_command   => $archive_cleanup_command,
            recovery_end_command      => $recovery_end_command,
            recovery_target_name      => $recovery_target_name,
            recovery_target_time      => $recovery_target_time,
            recovery_target_xid       => $recovery_target_xid,
            recovery_target_inclusive => $recovery_target_inclusive,
            recovery_target           => $recovery_target,
            recovery_target_timeline  => $recovery_target_timeline,
            pause_at_recovery_target  => $pause_at_recovery_target,
            standby_mode              => $standby_mode,
            primary_conninfo          => $primary_conninfo,
            primary_slot_name         => $primary_slot_name,
            trigger_file              => $trigger_file,
            recovery_min_apply_delay  => $recovery_min_apply_delay,
          }
        ),
      }
    } else {
      # ---------------- PostgreSQL >= 12: standby.signal + postgresql.conf GUCs ----------------
      if $standby_mode != undef or $trigger_file != undef or $pause_at_recovery_target != undef {
        warning("postgresql::server::recovery[${name}]: standby_mode, trigger_file and pause_at_recovery_target are legacy recovery.conf concepts and are ignored on PostgreSQL ${_version}. Standby state is now determined by the presence of standby.signal, trigger_file has been renamed to promote_trigger_file (still honored here as a fallback), and pause_at_recovery_target has been replaced by recovery_target_action.") # lint:ignore:140chars
      }

      if $promote_trigger_file {
        $_promote_trigger_file = $promote_trigger_file
      } else {
        $_promote_trigger_file = $trigger_file
      }

      # postgresql::server::config_entry's $value only accepts String[1]/Numeric/Array[String[1]],
      # so booleans must be rendered as postgresql.conf's on/off strings before being handed to it.
      $_recovery_target_inclusive = $recovery_target_inclusive ? {
        undef   => undef,
        true    => 'on',
        default => 'off',
      }

      file { "${name}_standby_signal":
        ensure  => file,
        path    => "${postgresql::server::datadir}/standby.signal",
        owner   => $postgresql::server::user,
        group   => $postgresql::server::group,
        mode    => '0640',
        content => '',
        require => Postgresql::Server::Instance::Initdb['main'],
        before  => Postgresql::Server::Instance::Service['main'],
      }

      $_guc_values = {
        'primary_conninfo'         => $primary_conninfo,
        'primary_slot_name'        => $primary_slot_name,
        'restore_command'          => $restore_command,
        'archive_cleanup_command'  => $archive_cleanup_command,
        'recovery_end_command'     => $recovery_end_command,
        'recovery_target_name'     => $recovery_target_name,
        'recovery_target_time'     => $recovery_target_time,
        'recovery_target_xid'      => $recovery_target_xid,
        'recovery_target_inclusive' => $_recovery_target_inclusive,
        'recovery_target'          => $recovery_target,
        'recovery_target_timeline' => $recovery_target_timeline,
        'recovery_target_action'   => $recovery_target_action,
        'recovery_min_apply_delay' => $recovery_min_apply_delay,
        'promote_trigger_file'     => $_promote_trigger_file,
      }.filter |$key, $value| { $value != undef }

      $_guc_values.each |$key, $value| {
        postgresql::server::config_entry { "${name}_${key}":
          ensure => present,
          key    => $key,
          value  => $value,
          path   => $postgresql::server::postgresql_conf_path,
          before => Postgresql::Server::Instance::Service['main'],
        }
      }
    }
  }
}
