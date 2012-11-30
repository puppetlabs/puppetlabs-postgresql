# Class: postgresql::server
#
# manages the installation of the postgresql server.  manages the package and service
#
# Parameters:
#   [*package_name*] - name of package
#   [*service_name*] - name of service
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::server (
  $package_name     = $postgresql::params::server_package_name,
  $package_ensure   = 'present',
  $service_name     = $postgresql::params::service_name,
  $service_provider = $postgresql::params::service_provider,
  $service_status   = $postgresql::params::service_status,
  $config_hash      = {}
) inherits postgresql::params {

  package { 'postgresql-server':
    ensure => $package_ensure,
    name   => $package_name,
  }

  $config_class = {}
  $config_class['postgresql::config'] = $config_hash

  create_resources( 'class', $config_class )

  Package['postgresql-server'] -> Class['postgresql::config']

  if ($needs_initdb) {
    include postgresql::initdb

    Class['postgresql::initdb'] -> Class['postgresql::config']
    Class['postgresql::initdb'] -> Service['postgresqld']
  }

  service { 'postgresqld':
    ensure   => running,
    name     => $service_name,
    enable   => true,
    require  => Package['postgresql-server'],
    provider => $service_provider,
    status   => $service_status,
  }

  exec { 'reload_postgresql':
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => "service ${postgresql::params::service_name} reload",
    refreshonly => true,
  }
}
