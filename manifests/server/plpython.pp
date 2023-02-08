# @summary This class installs the PL/Python procedural language for postgresql.
#
# @param package_ensure 
#   Specifies whether the package is present.
# @param package_name
#   Specifies the name of the postgresql PL/Python package.
class postgresql::server::plpython (
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'present',
  Optional[String[1]] $package_name = $postgresql::server::plpython_package_name,
) {
  package { 'postgresql-plpython':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

  anchor { 'postgresql::server::plpython::start': }
  -> Class['postgresql::server::install']
  -> Package['postgresql-plpython']
  -> Class['postgresql::server::service']
  -> anchor { 'postgresql::server::plpython::end': }
}
