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
  $package_name   = undef,
  $package_ensure = 'present'
) {

  require postgresql
  
  $package_name_real = $package_name ? { undef => $postgresql::packages::devel_package_name, default => $package_name }

  package { 'postgresql_devel':
    ensure => $package_ensure,
    name   => $package_name_real,
  }
}
