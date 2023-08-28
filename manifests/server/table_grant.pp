# @summary This resource wraps the grant resource to manage table grants specifically.
#
# @param privilege
#   Specifies comma-separated list of privileges to grant.
#   Valid options: 'ALL', 'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER'.
# @param table Specifies the table to which you are granting access.
# @param db Specifies which database the table is in.
# @param role Specifies the role or user to whom you are granting access.
# @param ensure Specifies whether to grant or revoke the privilege. Default is to grant the privilege.
# @param port Port to use when connecting.
# @param psql_db Specifies the database to execute the grant against. This should not ordinarily be changed from the default.
# @param psql_user Specifies the OS user for running psql.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param onlyif_exists Create grant only if it doesn't exist.
define postgresql::server::table_grant (
  Enum['ALL', 'SELECT', 'INSERT', 'UPDATE', 'DELETE', 'TRUNCATE', 'REFERENCES', 'TRIGGER', 'all', 'select', 'insert', 'update', 'delete',
  'truncate', 'references', 'trigger'] $privilege,
  String[1]                                           $table,
  String[1]                                           $db,
  String[1]                                           $role,
  Optional[Enum['present', 'absent']]                 $ensure           = undef,
  Optional[Stdlib::Port]                              $port             = undef,
  Optional[String[1]]                                 $psql_db          = undef,
  Optional[String[1]]                                 $psql_user        = undef,
  Optional[Hash]                                      $connect_settings = undef,
  Boolean                                             $onlyif_exists    = false,
) {
  postgresql::server::grant { "table:${name}":
    ensure           => $ensure,
    role             => $role,
    db               => $db,
    port             => $port,
    privilege        => $privilege,
    object_type      => 'TABLE',
    object_name      => $table,
    psql_db          => $psql_db,
    psql_user        => $psql_user,
    onlyif_exists    => $onlyif_exists,
    connect_settings => $connect_settings,
  }
}
