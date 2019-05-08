# @summary This class installs the perl libs for postgresql.
#
# @param package_name
#   Specifies the name of the PostgreSQL perl package to install.
# @param package_ensure
#   Ensure the perl libs for postgresql are installed.
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
