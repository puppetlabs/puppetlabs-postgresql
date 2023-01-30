# @param service_reload Overrides the default reload command for your PostgreSQL service.
# @param service_status Overrides the default status check command for your PostgreSQL service.
define postgresql::server::instance::reload (
  $service_status = $postgresql::server::service_status,
  $service_reload = $postgresql::server::service_reload,
) {
  exec { 'postgresql_reload':
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => $service_reload,
    onlyif      => $service_status,
    refreshonly => true,
    require     => Class['postgresql::server::service'],
  }
}
