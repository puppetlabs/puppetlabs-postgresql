# @api private
class postgresql::server::initdb {
  postgresql::server::instance::initdb { 'main':
    auth_host      => $postgresql::server::auth_host,
    auth_local     => $postgresql::server::auth_local,
    needs_initdb   => $postgresql::server::needs_initdb,
    initdb_path    => $postgresql::server::initdb_path,
    datadir        => $postgresql::server::datadir,
    xlogdir        => $postgresql::server::xlogdir,
    logdir         => $postgresql::server::logdir,
    manage_datadir => $postgresql::server::manage_datadir,
    manage_logdir  => $postgresql::server::manage_logdir,
    manage_xlogdir => $postgresql::server::manage_xlogdir,
    encoding       => $postgresql::server::encoding,
    lc_messages    => $postgresql::server::lc_messages,
    locale         => $postgresql::server::locale,
    data_checksums => $postgresql::server::data_checksums,
    group          => $postgresql::server::group,
    user           => $postgresql::server::user,
    username       => $postgresql::server::username,
    module_workdir => $postgresql::server::module_workdir,
  }
}
