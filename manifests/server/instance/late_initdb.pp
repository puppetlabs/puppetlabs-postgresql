# @summary Manage the default encoding when database initialization is managed by the package
#
# @param encoding
#   Sets the default encoding for all databases created with this module. On certain operating systems this is also used during the
#   template1 initialization, so it becomes a default outside of the module as well.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
# @param psql_path Specifies the path to the psql command.
# @param port
#   Specifies the port for the PostgreSQL server to listen on.
#   Note: The same port number is used for all IP addresses the server listens on. Also, for Red Hat systems and early Debian systems,
#   changing the port causes the server to come to a full stop before being able to make the change.
# @param module_workdir Working directory for the PostgreSQL module
define postgresql::server::instance::late_initdb (
  Optional[String[1]]                       $encoding       = $postgresql::server::encoding,
  String[1]                                 $user           = $postgresql::server::user,
  String[1]                                 $group          = $postgresql::server::group,
  Stdlib::Absolutepath                      $psql_path      = $postgresql::server::psql_path,
  Stdlib::Port                              $port           = $postgresql::server::port,
  Stdlib::Absolutepath                      $module_workdir = $postgresql::server::module_workdir,
) {
  # Set the defaults for the postgresql_psql resource
  Postgresql_psql {
    psql_user  => $user,
    psql_group => $group,
    psql_path  => $psql_path,
    port       => $port,
    instance   => $name,
    cwd        => $module_workdir,
  }

  # [workaround]
  # by default pg_createcluster encoding derived from locale
  # but it do does not work by installing postgresql via puppet because puppet
  # always override LANG to 'C'
  postgresql_psql { "Set template1 encoding to ${encoding}":
    command => "UPDATE pg_database
      SET datistemplate = FALSE
      WHERE datname = 'template1'
      ;
      UPDATE pg_database
      SET encoding = pg_char_to_encoding('${encoding}'), datistemplate = TRUE
      WHERE datname = 'template1'",
    unless  => "SELECT datname FROM pg_database WHERE
      datname = 'template1' AND encoding = pg_char_to_encoding('${encoding}')",
    before  => Anchor["postgresql::server::service::end::${name}"],
  }
}
