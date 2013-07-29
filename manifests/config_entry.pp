#
# Parameters:
#   ['ensure'] - Whether the setting should be present or absent. Default to present.
#   ['value']  - The value of the configuration parameter.
#   ['path']   - The path to the configuration file (optional)
#
# Actions:
# - Creates and manages a postgresql configuration entry.
#
# Sample usage:
#   postgresql::config_entry { 'shared_buffers':
#     value => '128MB',
#   }
#
#   postgresql::config_entry { 'fsync':
#     ensure => absent, # reset to default value
#   }
#
# See also:
#   http://www.postgresql.org/docs/current/static/config-setting.html
#
define postgresql::config_entry (
    $ensure='present',
    $value=undef,
    $path=false
) {

  include '::postgresql::params'

  $target = $path ? {
    false   => "${::postgresql::params::postgresql_conf_path}",
    default => $path,
  }

  case $name {

    /data_directory|hba_file|ident_file|include|listen_addresses|port|max_connections|superuser_reserved_connections|unix_socket_directory|unix_socket_group|unix_socket_permissions|bonjour|bonjour_name|ssl|ssl_ciphers|shared_buffers|max_prepared_transactions|max_files_per_process|shared_preload_libraries|wal_level|wal_buffers|archive_mode|max_wal_senders|hot_standby|logging_collector|silent_mode|track_activity_query_size|autovacuum_max_workers|autovacuum_freeze_max_age|max_locks_per_transaction|max_pred_locks_per_transaction|restart_after_crash/: {
      Pgconf {
        notify => Service['postgresqld'],
      }
    }

    default: {
      Pgconf {
        notify => Exec['reload_postgresql'],
      }
    }
  }


  case $ensure {

    /present|absent/: {
      pgconf { $name:
        ensure  => $ensure,
        target  => $target,
        value   => $value,
        require => Class["postgresql::config"],
      }
    }

    default: {
      fail("Unknown value for ensure '${ensure}'.")
    }
  }

}
