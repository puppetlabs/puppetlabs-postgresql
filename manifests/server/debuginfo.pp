# Install the contrib postgresql packaging. See README.md for more details.
class postgresql::server::debuginfo (
  $package_name   = $postgresql::params::debuginfo_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {
  validate_string($package_name)

  package { 'postgresql-debuginfo':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }

  anchor { 'postgresql::server::contrib::start': }->
  Class['postgresql::server::install']->
  Package['postgresql-debuginfo']->
  Class['postgresql::server::service']->
  anchor { 'postgresql::server::contrib::end': }
}
