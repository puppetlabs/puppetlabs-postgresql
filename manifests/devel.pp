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
  $package_name   = $postgresql::params::devel_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {

  require postgresql

  package { 'postgresql_devel':
    name   => $package_name,
    ensure => $package_ensure,
  }
}
