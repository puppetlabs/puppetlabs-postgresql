# @summary
#  Create a new schema.
#
# @note
#  The database must exist and the PostgreSQL user should have enough privileges
#
# @param db Required. Sets the name of the database in which to create this schema.
# @param owner Sets the default owner of the schema.
# @param schema Sets the name of the schema.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param port the post the postgresql instance is listening on.
# @param user Sets the OS user to run psql
# @param group Sets the OS group to run psql
# @param psql_path Sets path to psql command
# @param module_workdir
#   Specifies working directory under which the psql command should be executed.
#   May need to specify if '/tmp' is on volume mounted with noexec option.
# @param instance The name of the Postgresql database instance.
# @example
#   postgresql::server::schema {'private':
#       db => 'template1',
#   }
define postgresql::server::schema (
  String[1]            $db               = $postgresql::server::default_database,
  Optional[String[1]]  $owner            = undef,
  String[1]            $schema           = $title,
  Hash                 $connect_settings = $postgresql::server::default_connect_settings,
  Stdlib::Port         $port             = $postgresql::server::port,
  String[1]            $user             = $postgresql::server::user,
  String[1]            $group            = $postgresql::server::group,
  Stdlib::Absolutepath $psql_path        = $postgresql::server::psql_path,
  Stdlib::Absolutepath $module_workdir   = $postgresql::server::module_workdir,
  String[1]            $instance         = 'main',
) {
  Postgresql::Server::Db <| dbname == $db |> -> Postgresql::Server::Schema[$name]

  # If the connection settings do not contain a port, then use the local server port
  $port_override = pick($connect_settings['PGPORT'], $port)

  Postgresql_psql {
    db               => $db,
    psql_user        => $user,
    psql_group       => $group,
    psql_path        => $psql_path,
    port             => $port_override,
    cwd              => $module_workdir,
    connect_settings => $connect_settings,
    instance         => $instance,
  }

  postgresql_psql { "${db}: CREATE SCHEMA \"${schema}\"":
    command => "CREATE SCHEMA \"${schema}\"",
    unless  => "SELECT 1 FROM pg_namespace WHERE nspname = '${schema}'",
    require => Class['postgresql::server'],
  }

  if $owner {
    postgresql_psql { "${db}: ALTER SCHEMA \"${schema}\" OWNER TO \"${owner}\"":
      command => "ALTER SCHEMA \"${schema}\" OWNER TO \"${owner}\"",
      unless  => "SELECT 1 FROM pg_namespace JOIN pg_roles rol ON nspowner = rol.oid WHERE nspname = '${schema}' AND rolname = '${owner}'",
      require => Postgresql_psql["${db}: CREATE SCHEMA \"${schema}\""],
    }

    if defined(Postgresql::Server::Role[$owner]) {
      Postgresql::Server::Role[$owner] -> Postgresql_psql["${db}: ALTER SCHEMA \"${schema}\" OWNER TO \"${owner}\""]
    }
  }
}
