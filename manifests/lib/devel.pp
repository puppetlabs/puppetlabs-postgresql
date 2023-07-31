# @summary This class installs postgresql development libraries.
#
# @param package_name
#   Override devel package name
# @param package_ensure
#   Ensure the development libraries are installed
# @param link_pg_config
#   If the bin directory used by the PostgreSQL page is not /usr/bin or /usr/local/bin, symlinks pg_config from the package's bin dir
#   into usr/bin (not applicable to Debian systems). Set to false to disable this behavior.
#
#
class postgresql::lib::devel (
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'present',
  String $package_name    = $postgresql::params::devel_package_name,
  Boolean $link_pg_config = $postgresql::params::link_pg_config,
) inherits postgresql::params {
  if $facts['os']['family'] == 'Gentoo' {
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
