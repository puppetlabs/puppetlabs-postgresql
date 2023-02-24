# @summary This class installs the postgresql jdbc connector.
#
# @note
#   Make sure to add any necessary yum or apt repositories if specifying a custom version.
#
# @param package_name
#  Specifies the name of the PostgreSQL java package.
# @param package_ensure
#  Specifies whether the package is present.
#
class postgresql::lib::java (
  String $package_name = $postgresql::params::java_package_name,
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'present',
) inherits postgresql::params {
  package { 'postgresql-jdbc':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }
}
