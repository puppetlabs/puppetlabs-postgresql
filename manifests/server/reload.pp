# PRIVATE CLASS: do not use directly
class postgresql::server::reload {
  $service_name   = $postgresql::server::service_name
  $service_status = $postgresql::server::service_status

  exec { 'postgresql_reload':
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => "service ${service_name} reload",
    onlyif      => $service_status,
    refreshonly => true,
    require     => Class['postgresql::server::service'],
  }
}
