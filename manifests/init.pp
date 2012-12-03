# Class: postgresql
#
#   This class installs postgresql client software.
#
#   *Note* don't forget to make sure to add any necessary yum or apt
#   repositories if specifying a custom version.
#
# Parameters:
#   [*version*] - The postgresql version to install.
#   [*package_name*]  - The name of the postgresql client package.
#   [*ensure*] - the ensure parameter passed to the postgresql client package resource
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql (
  $version        = $::postgres_default_version,
  $package_name   = '',
  $package_ensure = 'present'
) inherits postgresql::params {

  if ! $package_name {
    include postgresql::platform
    $package_name_real = $postgresql::platform::client_package_name
  }
  else {
    $package_name_real = $package_name
  }

  package { 'postgresql_client':
    ensure  => $package_ensure,
    name    => $package_name_real,
  }

}
