# This defined types creates database schemas. See README.md for more details.
define postgresql::server::schema(
  $db,
  $owner  = undef,
  $schema = $title,
) {
  $user      = $postgresql::server::user
  $group     = $postgresql::server::group
  $port      = $postgresql::server::port
  $psql_path = $postgresql::server::psql_path
  $version   = $postgresql::server::_version

  Postgresql_psql {
    db         => $db,
    psql_user  => $user,
    psql_group => $group,
    psql_path  => $psql_path,
    port       => $port,
  }

  $schema_title   = "Create Schema '${schema}'"
  $authorization = $owner? {
    undef   => '',
    default => "AUTHORIZATION \"${owner}\"",
  }

  $schema_command = "CREATE SCHEMA \"${schema}\" ${authorization}"
  $unless         = "SELECT nspname FROM pg_namespace WHERE nspname='${schema}'"

  postgresql_psql { $schema_title:
    command => $schema_command,
    unless  => $unless,
    require => Class['postgresql::server'],
  }

  if($owner != undef and defined(Postgresql::Server::Role[$owner])) {
    Postgresql::Server::Role[$owner]->Postgresql_psql[$schema_title]
  }
}
