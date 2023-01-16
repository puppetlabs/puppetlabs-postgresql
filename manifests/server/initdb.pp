# @api private
class postgresql::server::initdb {
  postgresql::server::instance_initdb { 'main':
    needs_initdb   => $postgresql::server::needs_initdb,
    initdb_path    => $postgresql::server::initdb_path,
    datadir        => $postgresql::server::datadir,
    xlogdir        => $postgresql::server::xlogdir,
    logdir         => $postgresql::server::logdir,
    manage_datadir => $postgresql::server::manage_datadir,
    manage_logdir  => $postgresql::server::manage_logdir,
    manage_xlogdir => $postgresql::server::manage_xlogdir,
    encoding       => $postgresql::server::encoding,
    locale         => $postgresql::server::locale,
    data_checksums => $postgresql::server::data_checksums,
    group          => $postgresql::server::group,
    user           => $postgresql::server::user,
    module_workdir => $postgresql::server::module_workdir,
  }
}
