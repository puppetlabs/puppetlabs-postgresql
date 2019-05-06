# @summary This class installs the postgresql-docs
#
# @param package_name
#   String.
# @param package_ensure
#   String. Defaults to 'present'.
# 
#
class postgresql::lib::docs (
  String $package_name      = $postgresql::params::docs_package_name,
  String[1] $package_ensure = 'present',
) inherits postgresql::params {

  package { 'postgresql-docs':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

}
