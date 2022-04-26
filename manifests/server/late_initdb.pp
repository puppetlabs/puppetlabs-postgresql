# @summary Manage the default encoding when database initialization is managed by the package
#
# @api private
class postgresql::server::late_initdb {
  assert_private()

  $encoding       = $postgresql::server::encoding
  $user           = $postgresql::server::user
  $group          = $postgresql::server::group
  $psql_path      = $postgresql::server::psql_path
  $port           = $postgresql::server::port
  $module_workdir = $postgresql::server::module_workdir

  # Set the defaults for the postgresql_psql resource
  Postgresql_psql {
    psql_user  => $user,
    psql_group => $group,
    psql_path  => $psql_path,
    port       => $port,
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
    before  => Anchor['postgresql::server::service::end'],
  }
}
