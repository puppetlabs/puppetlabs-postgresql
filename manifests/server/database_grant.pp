# @summary Manage a database grant.
#
# @param privilege
# @param db
# @param role
# @param ensure
# @param psql_db
# @param psql_user
# @param connect_settings
#
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
