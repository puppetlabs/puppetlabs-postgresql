# @summary Define for granting membership to a role.
#
# @param group Specifies the group role to which you are assigning a role.
# @param role Specifies the role you want to assign to a group. If left blank, uses the name of the resource.
# @param ensure Specifies whether to grant or revoke the membership. Valid options: 'present' or 'absent'.
# @param psql_db Specifies the database to execute the grant against. This should not ordinarily be changed from the default
# @param psql_user Sets the OS user to run psql.
# @param port Port to use when connecting.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param instance The name of the Postgresql database instance.
# @param with_admin_option Specifies if the role should be granted with admin option.
define postgresql::server::grant_role (
  String[1]                                 $group,
  String[1]                                 $role              = $name,
  Enum['present', 'absent']                 $ensure            = 'present',
  String[1]                                 $instance          = 'main',
  String[1]                                 $psql_db           = $postgresql::server::default_database,
  String[1]                                 $psql_user         = $postgresql::server::user,
  Stdlib::Port                              $port              = $postgresql::server::port,
  Hash                                      $connect_settings  = $postgresql::server::default_connect_settings,
  Boolean                                   $with_admin_option = false,
) {
  case $ensure {
    'present': {
      $with_admin_option_sql = $with_admin_option ? { true => 'WITH ADMIN OPTION', default => '' }
      $command = "GRANT \"${group}\" TO \"${role}\" ${with_admin_option_sql}"
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
    unless           => "SELECT 1 WHERE EXISTS (SELECT 1 FROM pg_roles AS r_role JOIN pg_auth_members AS am ON r_role.oid = am.member JOIN pg_roles AS r_group ON r_group.oid = am.roleid WHERE r_group.rolname = '${group}' AND r_role.rolname = '${role}') ${unless_comp} true", # lint:ignore:140chars
    db               => $psql_db,
    psql_user        => $psql_user,
    port             => $port,
    instance         => $instance,
    connect_settings => $connect_settings,
  }

  if empty($connect_settings) {
    Class['postgresql::server'] -> Postgresql_psql["grant_role:${name}"]
  }
  if defined(Postgresql::Server::Role[$role]) {
    Postgresql::Server::Role[$role] -> Postgresql_psql["grant_role:${name}"]
  }
  if defined(Postgresql::Server::Role[$group]) {
    Postgresql::Server::Role[$group] -> Postgresql_psql["grant_role:${name}"]
  }
}
