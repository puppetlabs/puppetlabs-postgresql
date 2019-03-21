# This class installs the perl libs for postgresql. See README.md for more
# details.
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
