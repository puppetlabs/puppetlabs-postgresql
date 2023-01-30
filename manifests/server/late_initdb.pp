# @summary Manage the default encoding when database initialization is managed by the package
#
# @api private
class postgresql::server::late_initdb {
  assert_private()

  postgresql::server::instance::late_initdb { 'main':
    encoding       => $postgresql::server::encoding,
    user           => $postgresql::server::user,
    group          => $postgresql::server::group,
    psql_path      => $postgresql::server::psql_path,
    port           => $postgresql::server::port,
    module_workdir => $postgresql::server::module_workdir,
  }
}
