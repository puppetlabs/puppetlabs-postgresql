# Define for creating a redshift group. See README.md for more information
define postgresql::server::dbgroup(
  $db               = $postgresql::server::default_database,
  $port             = undef,
  $ensure           = 'present',
  $groupname        = $title,
  $dialect          = $postgresql::server::dialect,
  $refreshonly      = $postgresql::server::refreshonly,
  $connect_settings = undef,
) {
  $psql_user      = $postgresql::server::user
  $psql_group     = $postgresql::server::group
  $psql_path      = $postgresql::server::psql_path
  $module_workdir = $postgresql::server::module_workdir

  #
  # Port, order of precedence: $port parameter, $connect_settings[PGPORT], $postgresql::server::port
  #
  if $port != undef {
    $port_override = $port
  } elsif $connect_settings != undef and has_key( $connect_settings, 'PGPORT') {
    $port_override = undef
  } else {
    $port_override = $postgresql::server::port
  }

  if $ensure == 'absent' {
    Postgresql_psql {
      db               => $db,
      port             => $port_override,
      psql_user        => $psql_user,
      psql_group       => $psql_group,
      psql_path        => $psql_path,
      connect_settings => $connect_settings,
      cwd              => $module_workdir,
      require          => [
        Postgresql_psql["${title}: DROP GROUP ${groupname}"],
        Class['postgresql::server'],
      ],
    }

    postgresql_psql { "${title}: DROP GROUP ${groupname}":
      command     => "DROP GROUP ${groupname}",
      unless      => "SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM pg_group WHERE groname = '${groupname}')",
      environment => [],
      require     => Class['Postgresql::Server'],
    }
  } else {
    Postgresql_psql {
      db         => $db,
      port       => $port_override,
      psql_user  => $psql_user,
      psql_group => $psql_group,
      psql_path  => $psql_path,
      connect_settings => $connect_settings,
      cwd        => $module_workdir,
      require    => [
        Postgresql_psql["${title}: CREATE GROUP ${groupname}"],
        Class['postgresql::server'],
      ],
    }
    postgresql_psql { "${title}: CREATE GROUP ${groupname}":
      command     => "CREATE GROUP ${groupname}",
      unless      => "SELECT 1 FROM pg_group WHERE groname = '${groupname}'",
      environment => [],
      require     => Class['Postgresql::Server'],
    }
  }
}