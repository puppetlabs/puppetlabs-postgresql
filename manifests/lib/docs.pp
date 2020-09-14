# @summary Installs PostgreSQL bindings for Postgres-Docs. Set the following parameters if you have a custom version you would like to install.
#
# @note
#   Make sure to add any necessary yum or apt repositories if specifying a custom version.
#
# @param package_name
#   Specifies the name of the PostgreSQL docs package.
# @param package_ensure
#   Whether the PostgreSQL docs package resource should be present.
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
