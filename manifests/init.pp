# Class: postgresql
#
#   This class installs postgresql client software.
#
# Parameters:
#   [*client_package_name*]  - The name of the postgresql client package.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql (
  $version        = $::postgres_default_version,
  $package_name   = undef,
  $package_ensure = 'present'
) inherits postgresql::params {
  if ! defined(Class['postgresql::version']) {
    class { 'postgresql::version':
      version => $version
    }
  }
  include postgresql::packages
  
  $package_name_real = $package_name ? { undef => $postgresql::packages::client_package_name, default => $package_name }

  package { 'postgresql_client':
    ensure  => $package_ensure,
    name    => $package_name_real,
  }

}
