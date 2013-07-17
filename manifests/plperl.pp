# == Class: postgresql::plperl
#
# This class installs the PL/Perl procedural language for postgresql.
#
# === Parameters
#
# [*ensure*]
#   ensure state for package.
#   can be specified as version.
#
# [*package_name*]
#   name of package
#
class postgresql::plperl(
  $package_name   = $postgresql::params::plperl_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {

  package { 'postgresql-plperl':
    ensure => $package_ensure,
    name   => $package_name,
  }

}
