# PRIVATE CLASS: do not call directly
class postgresql::server::service {
  $ensure           = $postgresql::server::ensure
  $service_name     = $postgresql::server::service_name
  $service_provider = $postgresql::server::service_provider
  $service_status   = $postgresql::server::service_status

  $service_ensure = $ensure ? {
    present => true,
    absent  => false,
    default => $ensure
  }

  service { 'postgresqld':
    ensure    => $service_ensure,
    name      => $service_name,
    enable    => $service_ensure,
    provider  => $service_provider,
    hasstatus => true,
    status    => $service_status,
  }
}
