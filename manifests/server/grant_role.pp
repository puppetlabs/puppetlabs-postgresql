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
    unless           => "SELECT 1 WHERE EXISTS (SELECT 1 FROM pg_role AS r_role JOIN pg_auth_members AS am ON r_role.oid = am.member JOIN pg_roles AS r_group ON r_group.oid = am.roleid WHERE r_group.rolname = '${group}' AND r_role.rolname = '${role}') ${unless_comp} true",
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
