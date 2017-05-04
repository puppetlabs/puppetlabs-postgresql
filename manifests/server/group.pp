# Define for creating a redshift group. See README.md for more information
define postgresql::server::group(
  $db               = $postgresql::server::default_database,
  $port             = undef, 
  $groupmembers     = undef,
  $groupname        = $title,
  $dialect          = $postgresql::server::dialect,
  $connect_settings = undef,
) {
  $psql_user      = $postgresql::server::user
  $psql_group     = $postgresql::server::group
  $psql_path      = $postgresql::server::psql_path
  $module_workdir = $postgresql::server::module_workdir

  postgresql_psql { "${title}: CREATE GROUP ${groupname}":
    command     => "CREATE GROUP ${groupname}",
    unless      => "SELECT 1 FROM pg_group WHERE groname = '${groupname}'",
    environment => $environment,
    require     => Class['Postgresql::Server'],
  }

  postgresql_psql {"${title}: ALTER GROUP \"${group}\" ${groupmembers_sql}":
    unless => "SELECT 1 FROM pg_group WHERE groname = '${groupname}' AND grolist = ${groupmembers_list}",
  }

}