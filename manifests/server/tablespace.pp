# @summary This module creates tablespace.
#
# @param location Specifies the path to locate this tablespace.
# @param manage_location Set to false if you have file{ $location: } already defined
# @param owner Specifies the default owner of the tablespace.
# @param spcname Specifies the name of the tablespace.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param port the port of the postgresql instance that sould be used.
# @param user Sets the OS user to run psql
# @param group Sets the OS group to run psql
# @param psql_path Sets path to psql command
# @param module_workdir
#   Specifies working directory under which the psql command should be executed.
#   May need to specify if '/tmp' is on volume mounted with noexec option.
# @param instance The name of the Postgresql database instance.
define postgresql::server::tablespace (
  String[1]            $location,
  Boolean              $manage_location = true,
  Optional[String[1]]  $owner   = undef,
  String[1]            $spcname = $title,
  Hash                 $connect_settings = $postgresql::server::default_connect_settings,
  Stdlib::Port         $port             = $postgresql::server::port,
  String[1]            $user             = $postgresql::server::user,
  String[1]            $group            = $postgresql::server::group,
  Stdlib::Absolutepath $psql_path        = $postgresql::server::psql_path,
  String[1]            $module_workdir   = $postgresql::server::module_workdir,
  String[1]            $instance         = 'main',
) {
  # If the connection settings do not contain a port, then use the local server port
  $port_override = pick($connect_settings['PGPORT'], $port)

  Postgresql_psql {
    psql_user        => $user,
    psql_group       => $group,
    psql_path        => $psql_path,
    port             => $port_override,
    connect_settings => $connect_settings,
    cwd              => $module_workdir,
    instance         => $instance,
  }

  if($manage_location) {
    file { $location:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      seluser => 'system_u',
      selrole => 'object_r',
      seltype => 'postgresql_db_t',
      require => Class['postgresql::server'],
    }
  } else {
    File <| title == $location |> {
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      seluser => 'system_u',
      selrole => 'object_r',
      seltype => 'postgresql_db_t',
      require => Class['postgresql::server'],
    }
  }

  postgresql_psql { "CREATE TABLESPACE \"${spcname}\"":
    command => "CREATE TABLESPACE \"${spcname}\" LOCATION '${location}'",
    unless  => "SELECT 1 FROM pg_tablespace WHERE spcname = '${spcname}'",
    require => File[$location],
  }

  if $owner {
    postgresql_psql { "ALTER TABLESPACE \"${spcname}\" OWNER TO \"${owner}\"":
      unless  => "SELECT 1 FROM pg_tablespace JOIN pg_roles rol ON spcowner = rol.oid WHERE spcname = '${spcname}' AND rolname = '${owner}'", # lint:ignore:140chars
      require => Postgresql_psql["CREATE TABLESPACE \"${spcname}\""],
    }

    if defined(Postgresql::Server::Role[$owner]) {
      Postgresql::Server::Role[$owner] -> Postgresql_psql["ALTER TABLESPACE \"${spcname}\" OWNER TO \"${owner}\""]
    }
  }
}
