# This class installs the python libs for postgresql. See README.md for more
# details.
class postgresql::lib::python(
  String[1] $package_name   = $postgresql::params::python_package_name,
  String[1] $package_ensure = 'present'
) inherits postgresql::params {

  package { 'python-psycopg2':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

}
