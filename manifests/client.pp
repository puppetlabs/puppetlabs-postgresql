# Install client cli tool. See README.md for more details.
class postgresql::client (
  $package_name   = $postgresql::params::client_package_name,
  $package_ensure = 'present'
) inherits postgresql::params {
  validate_string($package_name)

  package { 'postgresql-client':
    ensure  => $package_ensure,
    name    => $package_name,
    tag     => 'postgresql',
  }

}
