# Class: postgresql::server
#
# == Class: postgresql::server
# Manages the installation of the postgresql server.  manages the package and
# service.
#
# === Parameters:
# [*package_name*] - name of package
# [*service_name*] - name of service
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::server (
  $package_name     = '',
  $package_ensure   = 'present',
  $service_name     = '',
  $service_provider = '',
  $service_status   = '',
  $config_hash      = {}
) inherits postgresql::params {

  require postgresql
  include postgresql::paths
  include postgresql::packages

  if ! $package_name {
    $package_name_real = $postgresql::packages::server_package_name
  } else {
    $package_name_real = $package_name
  }

  if ! $service_name {
      $service_name_real = $postgresql::paths::service_name
  } else {
      $service_name_real = $service_name
  }

  if ! $service_provider {
      $service_provider_real = $postgresql::paths::service_provider
  } else {
      $service_provider_real = $service_provider
  }

  if ! $service_status {
      $service_status_real = $postgresql::paths::service_status
  } else {
      $service_status_real = $service_status
  }

  package { 'postgresql-server':
    ensure  => $package_ensure,
    name    => $package_name_real,
  }
  
  $config_class = {}
  $config_class['postgresql::config'] = $config_hash

  create_resources( 'class', $config_class )
  

  service { 'postgresqld':
    ensure   => running,
    name     => $service_name_real,
    enable   => true,
    require  => Package['postgresql-server'],
    provider => $service_provider_real,
    status   => $service_status_real,
  }
  
  if ($postgresql::params::needs_initdb) {
    include postgresql::initdb

    Package['postgresql-server'] -> Class['postgresql::initdb'] -> Class['postgresql::config'] -> Service['postgresqld']
  } 
  else  {
    Package['postgresql-server'] -> Class['postgresql::config'] -> Service['postgresqld']
  }

  exec { 'reload_postgresql':
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    command     => "service ${postgresql::params::service_name} reload",
    refreshonly => true,
  }
}
