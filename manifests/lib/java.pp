# @summary This class installs the postgresql jdbc connector.
#
# @param package_name
#  String.
# @param package_ensure
#  String. Defaults to 'present'.
#
class postgresql::lib::java (
  String $package_name      = $postgresql::params::java_package_name,
  String[1] $package_ensure = 'present'
) inherits postgresql::params {

  package { 'postgresql-jdbc':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

}
