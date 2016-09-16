# Define for granting membership to a role. See README.md for more information
define postgresql::server::grant_role (
  $group,
  $role,
  $ensure           = 'present',
  $psql_db          = $postgresql::server::default_database,
  $psql_user        = $postgresql::server::user,
  $port             = $postgresql::server::port,
  $connect_settings = $postgresql::server::default_connect_settings,
) {
  validate_string($group)
  validate_string($role)
  if empty($group) {
    fail('$group must be set')
  }
  if empty($role) {
    fail('$role must be set')
  }
  case $ensure {
    'present': {
      $command = "GRANT \"${group}\" TO \"${role}\""
      $unless_comp = '='
    }
    'absent': {
      $command = "REVOKE \"${group}\" FROM \"${role}\""
      $unless_comp = '!='
    }
    default: {
      fail("Unknown value for ensure '${ensure}'.")
    }
  }

  postgresql_psql { "grant_role:${name}":
    command          => $command,
    unless           => "SELECT 1 WHERE pg_has_role('${role}', '${group}', 'MEMBER') ${unless_comp} true",
    db               => $psql_db,
    psql_user        => $psql_user,
    port             => $port,
    connect_settings => $connect_settings,
  }

  if ! $connect_settings or empty($connect_settings) {
    Class['postgresql::server']->Postgresql_psql["grant_role:${name}"]
  }
  if defined(Postgresql::Server::Role[$role]) {
    Postgresql::Server::Role[$role]->Postgresql_psql["grant_role:${name}"]
  }
  if defined(Postgresql::Server::Role[$group]) {
    Postgresql::Server::Role[$group]->Postgresql_psql["grant_role:${name}"]
  }
}
