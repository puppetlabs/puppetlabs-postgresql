# This resource wraps the grant resource to manage sequence grants specifically.
# See README.md for more details.
define postgresql::server::sequence_grant(
  $privilege,
  $sequence,
  $db,
  $role,
  $port      = $postgresql::server::port,
  $psql_db   = undef,
  $psql_user = undef
) {
  postgresql::server::grant { "sequence:${name}":
    role        => $role,
    db          => $db,
    port        => $port,
    privilege   => $privilege,
    object_type => 'SEQUENCE',
    object_name => $sequence,
    psql_db     => $psql_db,
    psql_user   => $psql_user,
  }
}
