# @summary Manage a database grant.
#
# @param privilege Specifies comma-separated list of privileges to grant. Valid options: 'ALL', 'CREATE', 'CONNECT', 'TEMPORARY', 'TEMP'.
# @param db Specifies the database to which you are granting access.
# @param role Specifies the role or user whom you are granting access to.
# @param ensure Specifies whether to grant or revoke the privilege. Revoke or 'absent' works only in PostgreSQL version 9.1.24 or later.
# @param psql_db Defines the database to execute the grant against. This should not ordinarily be changed from the default
# @param psql_user Specifies the OS user for running psql. Default value: The default user for the module, usually 'postgres'.
# @param psql_group Overrides the default postgres user group to be used for related files in the file system.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param port Port to use when connecting.
define postgresql::server::database_grant (
  Enum['ALL', 'CREATE', 'CONNECT', 'TEMPORARY', 'TEMP', 'all', 'create', 'connect', 'temporary', 'temp'] $privilege,
  String[1]                           $db,
  String[1]                           $role,
  Optional[Enum['present', 'absent']] $ensure           = undef,
  Optional[String[1]]                 $psql_db          = undef,
  String[1]                           $psql_user        = $postgresql::server::user,
  Hash $connect_settings = $postgresql::server::default_connect_settings,
  String[1] $psql_group = $postgresql::server::group,
  Stdlib::Port $port = $postgresql::server::port,
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
    group            => $psql_group,
    port             => $port,
    connect_settings => $connect_settings,
  }
}
