# PRIVATE CLASS: do not use directly
class postgresql::server::reload {
  $ensure         = $postgresql::server::ensure
  $service_name   = $postgresql::server::service_name
  $service_status = $postgresql::server::service_status

  if($ensure == 'present' or $ensure == true) {
    case $::osfamily {
      'Gentoo': {
        $command = "/etc/init.d/${service_name} reload"
      }
      default: {
        $command = "service ${service_name} reload"
      }
    }

    exec { 'postgresql_reload':
      path        => '/usr/bin:/usr/sbin:/bin:/sbin',
      command     => $command,
      onlyif      => $service_status,
      refreshonly => true,
    }
  }
}
