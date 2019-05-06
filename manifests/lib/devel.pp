# @summary This class installs postgresql development libraries. 
#
# @param package_name
#   String.
# @param package_ensure
#   String. Defaults to 'present'.
# @param link_pg_config
#   Boolean. 
#
#
class postgresql::lib::devel(
  String $package_name      = $postgresql::params::devel_package_name,
  String[1] $package_ensure = 'present',
  Boolean $link_pg_config   = $postgresql::params::link_pg_config
) inherits postgresql::params {

  if $::osfamily == 'Gentoo' {
    fail('osfamily Gentoo does not have a separate "devel" package, postgresql::lib::devel is not supported')
  }

  package { 'postgresql-devel':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

  if $link_pg_config {
    if ( $postgresql::params::bindir != '/usr/bin' and $postgresql::params::bindir != '/usr/local/bin') {
      file { '/usr/bin/pg_config':
        ensure => link,
        target => "${postgresql::params::bindir}/pg_config",
      }
    }
  }

}
