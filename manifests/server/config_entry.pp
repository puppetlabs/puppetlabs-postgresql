# @summary Manage a postgresql.conf entry.
#
# @param ensure Removes an entry if set to 'absent'.
# @param key Defines the key/name for the setting. Defaults to $name
# @param value Defines the value for the setting.
# @param path Path for postgresql.conf
# @param comment Defines the comment for the setting. The # is added by default.
#
define postgresql::server::config_entry (
  Enum['present', 'absent']                               $ensure  = 'present',
  String[1]                                               $key     = $name,
  Optional[Variant[String[1], Numeric, Array[String[1]]]] $value   = undef,
  Stdlib::Absolutepath                                    $path    = $postgresql::server::postgresql_conf_path,
  Optional[String[1]]                                     $comment = undef,
) {
  # Those are the variables that are marked as "(change requires restart)"
  # on postgresql.conf.  Items are ordered as on postgresql.conf.
  #
  # XXX: This resource supports setting other variables without knowing
  # their names.  Do not add them here.
  $requires_restart_until = {
    'data_directory'                      => undef,
    'hba_file'                            => undef,
    'ident_file'                          => undef,
    'external_pid_file'                   => undef,
    'listen_addresses'                    => undef,
    'port'                                => undef,
    'max_connections'                     => undef,
    'superuser_reserved_connections'      => undef,
    'unix_socket_directory'               => '9.3',   # Turned into "unix_socket_directories"
    'unix_socket_directories'             => undef,
    'unix_socket_group'                   => undef,
    'unix_socket_permissions'             => undef,
    'bonjour'                             => undef,
    'bonjour_name'                        => undef,
    'ssl'                                 => '10',
    'ssl_ciphers'                         => '10',
    'ssl_prefer_server_ciphers'           => '10',    # New on 9.4
    'ssl_ecdh_curve'                      => '10',    # New on 9.4
    'ssl_cert_file'                       => '10',    # New on 9.2
    'ssl_key_file'                        => '10',    # New on 9.2
    'ssl_ca_file'                         => '10',    # New on 9.2
    'ssl_crl_file'                        => '10',    # New on 9.2
    'shared_buffers'                      => undef,
    'huge_pages'                          => undef,   # New on 9.4
    'max_prepared_transactions'           => undef,
    'max_files_per_process'               => undef,
    'shared_preload_libraries'            => undef,
    'max_worker_processes'                => undef,   # New on 9.4
    'old_snapshot_threshold'              => undef,   # New on 9.6
    'wal_level'                           => undef,
    'wal_log_hints'                       => undef,   # New on 9.4
    'wal_buffers'                         => undef,
    'archive_mode'                        => undef,
    'max_wal_senders'                     => undef,
    'max_replication_slots'               => undef,   # New on 9.4
    'track_commit_timestamp'              => undef,   # New on 9.5
    'hot_standby'                         => undef,
    'logging_collector'                   => undef,
    'cluster_name'                        => undef,   # New on 9.5
    'silent_mode'                         => '9.2',   # Removed
    'track_activity_query_size'           => undef,
    'autovacuum_max_workers'              => undef,
    'autovacuum_freeze_max_age'           => undef,
    'autovacuum_multixact_freeze_max_age' => undef,   # New on 9.5
    'max_locks_per_transaction'           => undef,
    'max_pred_locks_per_transaction'      => undef,
  }

  if ! ($key in $requires_restart_until and (
      ! $requires_restart_until[$key] or
      versioncmp($postgresql::server::_version, $requires_restart_until[$key]) < 0
  )) {
    Postgresql_conf {
      notify => Class['postgresql::server::reload'],
    }
  } elsif $postgresql::server::service_restart_on_change {
    Postgresql_conf {
      notify => Class['postgresql::server::service'],
    }
  } else {
    Postgresql_conf {
      before => Class['postgresql::server::service'],
    }
  }

  postgresql_conf { $name:
    ensure  => $ensure,
    target  => $path,
    key     => $key,
    value   => $value,
    comment => $comment,
    require => Class['postgresql::server::initdb'],
  }
}
