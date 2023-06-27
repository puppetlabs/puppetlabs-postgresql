# @api private
class postgresql::server::initdb {
  postgresql::server::instance::initdb { 'main':
    auth_host      => $postgresql::server::auth_host,
    auth_local     => $postgresql::server::auth_local,
    data_checksums => $postgresql::server::data_checksums,
    datadir        => $postgresql::server::datadir,
    encoding       => $postgresql::server::encoding,
    group          => $postgresql::server::group,
    initdb_path    => $postgresql::server::initdb_path,
    lc_messages    => $postgresql::server::lc_messages,
    locale         => $postgresql::server::locale,
    logdir         => $postgresql::server::logdir,
    manage_datadir => $postgresql::server::manage_datadir,
    manage_logdir  => $postgresql::server::manage_logdir,
    manage_xlogdir => $postgresql::server::manage_xlogdir,
    module_workdir => $postgresql::server::module_workdir,
    needs_initdb   => $postgresql::server::needs_initdb,
    user           => $postgresql::server::user,
    username       => $postgresql::server::username,
    xlogdir        => $postgresql::server::xlogdir,
  }
}
