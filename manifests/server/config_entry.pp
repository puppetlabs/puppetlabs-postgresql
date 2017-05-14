# Manage a postgresql.conf entry. See README.md for more details.
define postgresql::server::config_entry (
  $ensure = 'present',
  $value  = undef,
  $path   = false
) {
  $postgresql_conf_path = $postgresql::server::postgresql_conf_path

  $target = $path ? {
    false   => $postgresql_conf_path,
    default => $path,
  }

  # Those are the variables that are marked as "(change requires restart)"
  # on postgresql.conf.  Items are ordered as on postgresql.conf.
  #
  # XXX: This resource supports setting other variables without knowing
  # their names.  Do not add them here.
  $requires_restart = [
    'data_directory',
    'hba_file',
    'ident_file',
    'external_pid_file',
    'listen_addresses',
    'port',
    'max_connections',
    'superuser_reserved_connections',
    'unix_socket_directory',
    'unix_socket_directories',
    'unix_socket_group',
    'unix_socket_permissions',
    'bonjour',
    'bonjour_name',
    'ssl',
    'ssl_ciphers',
    'ssl_prefer_server_ciphers',            # New on 9.4
    'ssl_ecdh_curve',                       # New on 9.4
    'ssl_cert_file',                        # New on 9.2
    'ssl_key_file',                         # New on 9.2
    'ssl_ca_file',                          # New on 9.2
    'ssl_crl_file',                         # New on 9.2
    'shared_buffers',
    'huge_pages',                           # New on 9.4
    'max_prepared_transactions',
    'max_files_per_process',
    'shared_preload_libraries',
    'max_worker_processes',                 # New on 9.4
    'old_snapshot_threshold',               # New on 9.6
    'wal_level',
    'wal_log_hints',                        # New on 9.4
    'wal_buffers',
    'archive_mode',
    'max_wal_senders',
    'max_replication_slots',                # New on 9.4
    'track_commit_timestamp',               # New on 9.5
    'hot_standby',
    'logging_collector',
    'cluster_name',                         # New on 9.5
    'silent_mode',
    'track_activity_query_size',
    'autovacuum_max_workers',
    'autovacuum_freeze_max_age',
    'autovacuum_multixact_freeze_max_age',  # New on 9.5
    'max_locks_per_transaction',
    'max_pred_locks_per_transaction',
  ]

  Exec {
    logoutput => 'on_failure',
  }

  if ! ($name in $requires_restart) {
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

  # We have to handle ports and the data directory in a weird and
  # special way.  On early Debian and Ubuntu and RHEL we have to ensure
  # we stop the service completely. On RHEL 7 we either have to create
  # a systemd override for the port or update the sysconfig file, but this
  # is managed for us in postgresql::server::config.
  if $::operatingsystem == 'Debian' or $::operatingsystem == 'Ubuntu' {
    if $name == 'port' and ( $::operatingsystemrelease =~ /^6/ or $::operatingsystemrelease =~ /^10\.04/ ) {
        exec { "postgresql_stop_${name}":
          command => "service ${::postgresql::server::service_name} stop",
          onlyif  => "service ${::postgresql::server::service_name} status",
          unless  => "grep 'port = ${value}' ${::postgresql::server::postgresql_conf_path}",
          path    => '/usr/sbin:/sbin:/bin:/usr/bin:/usr/local/bin',
          before  => Postgresql_conf[$name],
        }
    }
    elsif $name == 'data_directory' {
      exec { "postgresql_stop_${name}":
        command => "service ${::postgresql::server::service_name} stop",
        onlyif  => "service ${::postgresql::server::service_name} status",
        unless  => "grep \"data_directory = '${value}'\" ${::postgresql::server::postgresql_conf_path}",
        path    => '/usr/sbin:/sbin:/bin:/usr/bin:/usr/local/bin',
        before  => Postgresql_conf[$name],
      }
    }
  }
  if $::osfamily == 'RedHat' {
    if ! ($::operatingsystemrelease =~ /^7/ or $::operatingsystem == 'Fedora') {
      if $name == 'port' {
        # We need to force postgresql to stop before updating the port
        # because puppet becomes confused and is unable to manage the
        # service appropriately.
        exec { "postgresql_stop_${name}":
          command => "service ${::postgresql::server::service_name} stop",
          onlyif  => "service ${::postgresql::server::service_name} status",
          unless  => "grep 'PGPORT=${value}' /etc/sysconfig/pgsql/postgresql",
          path    => '/sbin:/bin:/usr/bin:/usr/local/bin',
          require => File['/etc/sysconfig/pgsql/postgresql'],
        }
        -> augeas { 'override PGPORT in /etc/sysconfig/pgsql/postgresql':
          lens    => 'Shellvars.lns',
          incl    => '/etc/sysconfig/pgsql/*',
          context => '/files/etc/sysconfig/pgsql/postgresql',
          changes => "set PGPORT ${value}",
          require => File['/etc/sysconfig/pgsql/postgresql'],
          notify  => Class['postgresql::server::service'],
          before  => Class['postgresql::server::reload'],
        }
      } elsif $name == 'data_directory' {
        # We need to force postgresql to stop before updating the data directory
        # otherwise init script breaks
        exec { "postgresql_${name}":
          command => "service ${::postgresql::server::service_name} stop",
          onlyif  => "service ${::postgresql::server::service_name} status",
          unless  => "grep 'PGDATA=${value}' /etc/sysconfig/pgsql/postgresql",
          path    => '/sbin:/bin:/usr/bin:/usr/local/bin',
          require => File['/etc/sysconfig/pgsql/postgresql'],
        }
        -> augeas { 'override PGDATA in /etc/sysconfig/pgsql/postgresql':
          lens    => 'Shellvars.lns',
          incl    => '/etc/sysconfig/pgsql/*',
          context => '/files/etc/sysconfig/pgsql/postgresql',
          changes => "set PGDATA ${value}",
          require => File['/etc/sysconfig/pgsql/postgresql'],
          notify  => Class['postgresql::server::service'],
          before  => Class['postgresql::server::reload'],
        }
      }
    }
  }

  case $ensure {
    /present|absent/: {
      postgresql_conf { $name:
        ensure  => $ensure,
        target  => $target,
        value   => $value,
        require => Class['postgresql::server::initdb'],
      }
    }

    default: {
      fail("Unknown value for ensure '${ensure}'.")
    }
  }
}
