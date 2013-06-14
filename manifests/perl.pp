# Class: postgresql::perl
#
# This class installs perl libraries for postgresql
#
# Parameters:
#   [*package_name*]    - The name of the postgresql perl package.
#   [*package_ensure*]  - The ensure value of the package.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   class { 'postgresql::perl': }
#
class postgresql::perl (
  $package_name   = $postgresql::params::perl_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {

  validate_string($package_name)

  package { 'postgresql-perl':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
