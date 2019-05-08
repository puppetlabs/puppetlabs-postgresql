# @summary Install the contrib postgresql packaging.
#
# @param package_name
#   The name of the PostgreSQL contrib package.
# @param package_ensure
#   Ensure the contrib package is installed.
class postgresql::server::contrib (
  String $package_name      = $postgresql::params::contrib_package_name,
  String[1] $package_ensure = 'present'
) inherits postgresql::params {

  if $::osfamily == 'Gentoo' {
    fail('osfamily Gentoo does not have a separate "contrib" package, postgresql::server::contrib is not supported.')
  }

  package { 'postgresql-contrib':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

  anchor { 'postgresql::server::contrib::start': }
  -> Class['postgresql::server::install']
  -> Package['postgresql-contrib']
  -> Class['postgresql::server::service']
  anchor { 'postgresql::server::contrib::end': }
}
