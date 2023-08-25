# @summary Define for reassigning the ownership of objects within a database.
# @note
#   This enables us to force the a particular ownership for objects within a database
#
# @param old_role Specifies the role or user who is the current owner of the objects in the specified db
# @param new_role Specifies the role or user who will be the new owner of these objects
# @param db Specifies the database to which the 'REASSIGN OWNED' will be applied
# @param psql_user Specifies the OS user for running psql.
# @param port Specifies the port for the PostgreSQL server port to connect to, default is 5432.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
define postgresql::server::reassign_owned_by (
  String $old_role,
  String $new_role,
  String $db,
  String $psql_user                               = $postgresql::server::user,
  Optional[Variant[String[1], Stdlib::Port, Integer]] $port = undef,
  Hash $connect_settings                          = $postgresql::server::default_connect_settings,
) {
  $sql_command = "REASSIGN OWNED BY \"${old_role}\" TO \"${new_role}\""

  $group     = $postgresql::server::group
  $psql_path = $postgresql::server::psql_path

  $port_override = pick($port, $postgresql::server::port)

  $onlyif = "SELECT tablename FROM pg_catalog.pg_tables WHERE
               schemaname NOT IN ('pg_catalog', 'information_schema') AND
               tableowner = '${old_role}'
             UNION ALL SELECT proname FROM pg_catalog.pg_proc WHERE
               pg_get_userbyid(proowner) = '${old_role}'
             UNION ALL SELECT viewname FROM pg_catalog.pg_views WHERE
               pg_views.schemaname NOT IN ('pg_catalog', 'information_schema') AND
               viewowner = '${old_role}'
             UNION ALL SELECT relname FROM pg_catalog.pg_class WHERE
               relkind='S' AND pg_get_userbyid(relowner) = '${old_role}'"

  postgresql_psql { "reassign_owned_by:${db}:${sql_command}":
    command          => $sql_command,
    db               => $db,
    port             => $port_override,
    connect_settings => $connect_settings,
    psql_user        => $psql_user,
    psql_group       => $group,
    psql_path        => $psql_path,
    onlyif           => $onlyif,
  }

  if($old_role != undef and defined(Postgresql::Server::Role[$old_role])) {
    Postgresql::Server::Role[$old_role] -> Postgresql_psql["reassign_owned_by:${db}:${sql_command}"]
  }
  if($new_role != undef and defined(Postgresql::Server::Role[$new_role])) {
    Postgresql::Server::Role[$new_role] -> Postgresql_psql["reassign_owned_by:${db}:${sql_command}"]
  }

  if($db != undef and defined(Postgresql::Server::Database[$db])) {
    Postgresql::Server::Database[$db] -> Postgresql_psql["reassign_owned_by:${db}:${sql_command}"]
  }
}
