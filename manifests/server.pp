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
  $version          = $::postgres_default_version,
  $package_name     = undef,
  $package_ensure   = 'present',
  $service_provider = $postgresql::params::service_provider,
  $service_status   = $postgresql::params::service_status,
  $config_hash      = {}
) inherits postgresql::params {

  if ! defined(Class['postgresql::version']) {
    class { 'postgresql::version':
      version => $version
    }
  }

  include postgresql::packages
  include postgresql::paths

  $package_name_real = $package_name ? { undef => $postgresql::packages::server_package_name, default => $package_name }


  package { 'postgresql-server':
    ensure  => $package_ensure,
    name    => $package_name_real,
  }
  
  $config_class = {}
  $config_class['postgresql::config'] = $config_hash

  create_resources( 'class', $config_class )
  

  service { 'postgresqld':
    ensure   => running,
    name     => $postgresql::paths::service_name,
    enable   => true,
    require  => Package['postgresql-server'],
    provider => $service_provider,
    status   => $service_status,
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
