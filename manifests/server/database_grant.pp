# Manage a database grant. See README.md for more details.
define postgresql::server::database_grant(
  $privilege,
  $db,
  $role,
  $ensure           = undef,
  $psql_db          = undef,
  $psql_user        = undef,
  $connect_settings = undef,
) {
  postgresql::server::grant { "database:${name}":
    ensure           => $ensure,
    role             => $role,
    db               => $db,
    privilege        => $privilege,
    object_type      => 'DATABASE',
    object_name      => $db,
    psql_db          => $psql_db,
    psql_user        => $psql_user,
    connect_settings => $connect_settings,
  }
}
