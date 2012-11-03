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
  $package_name   = $postgresql::params::client_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {

  package { 'postgresql_client':
    ensure  => $package_ensure,
    name    => $package_name,
  }

}
