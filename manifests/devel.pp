# Class: postgresql::devel
#
#   This class installs postgresql development libraries
#
# Parameters:
#   [*package_name*]   - The name of the postgresql development package.
#   [*package_ensure*] - The ensure value of the package
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::devel(
  $package_name   = '',
  $package_ensure = 'present'
) {

  require postgresql

  if ! $package_name {
    include postgresql::platform
    $package_name_real = $postgresql::platform::devel_package_name
  }
  else {
    $package_name_real = $package_name
  }

  package { 'postgresql_devel':
    ensure => $package_ensure,
    name   => $package_name_real,
  }
}
