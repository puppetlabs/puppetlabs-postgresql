# Define for creating a redshift group member. See README.md for more information
define postgresql::server::dbgroupmember(
  $db               = $postgresql::server::default_database,
  $port             = undef,
  $ensure           = 'present',
  $groupname        = undef,
  $username         = $title,
  $dialect          = $postgresql::server::dialect,
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
        Postgresql_psql["${title}: ALTER GROUP ${groupname} DROP USER ${username}"],
        Class['postgresql::server'],
      ],
    }
    postgresql_psql { "${title}: ALTER GROUP ${groupname} DROP USER ${username}":
      command     => "ALTER GROUP ${groupname} DROP USER ${username}",
      unless      => "SELECT 1 WHERE NOT (SELECT usesysid from pg_user where usename = '${username}') = ANY((SELECT grolist from pg_group where groname = '${groupname}')::int[])",
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
        Postgresql_psql["${title}: ALTER GROUP ${groupname} ADD USER ${username}"],
        Class['postgresql::server'],
      ],
    }
    postgresql_psql { "${title}: ALTER GROUP ${groupname} ADD USER ${username}":
      command     => "ALTER GROUP ${groupname} ADD USER ${username}",
      unless      => "SELECT 1 WHERE (SELECT usesysid from pg_user where usename = '${username}') = ANY((SELECT grolist from pg_group where groname = '${groupname}')::int[])",
      environment => [],
      require     => Class['Postgresql::Server'],
    }
  }
}