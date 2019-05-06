# @summary This class installs the perl libs for postgresql.
#
# @param package_name
#   String.
# @param package_ensure
#   String. Defaults to 'present'.
#
class postgresql::lib::perl(
  String $package_name      = $postgresql::params::perl_package_name,
  String[1] $package_ensure = 'present'
) inherits postgresql::params {

  package { 'perl-DBD-Pg':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

}
