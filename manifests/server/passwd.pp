# @api private
class postgresql::server::passwd {
  postgresql::server::instance::passwd { 'main':
    user              => $postgresql::server::user,
    group             => $postgresql::server::group,
    psql_path         => $postgresql::server::psql_path,
    port              => $postgresql::server::port,
    database          => $postgresql::server::default_database,
    module_workdir    => $postgresql::server::module_workdir,
    postgres_password => $postgresql::server::postgres_password,
  }
}
