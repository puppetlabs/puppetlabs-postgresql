# @summary This class installs the python libs for postgresql.
#
# @param package_name
#  The name of the PostgreSQL Python package.
# @param package_ensure
#  Ensure the python libs for postgresql are installed.
#
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
