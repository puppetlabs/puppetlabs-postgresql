# Install the contrib postgresql packaging. See README.md for more details.
class postgresql::contrib (
  $package_name   = $postgresql::params::contrib_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {
  validate_string($package_name)

  package { 'postgresql-contrib':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }
}
