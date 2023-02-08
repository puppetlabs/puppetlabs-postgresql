# @summary Install the postgis postgresql packaging.
#
# @param package_name Sets the package name.
# @param package_ensure Specifies if the package is present or not.
class postgresql::server::postgis (
  String $package_name = $postgresql::params::postgis_package_name,
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'present',
) inherits postgresql::params {
  package { 'postgresql-postgis':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

  anchor { 'postgresql::server::postgis::start': }
  -> Class['postgresql::server::install']
  -> Package['postgresql-postgis']
  -> Class['postgresql::server::service']
  -> anchor { 'postgresql::server::postgis::end': }

  if $postgresql::globals::manage_package_repo {
    Class['postgresql::repo']
    -> Package['postgresql-postgis']
  }
}
