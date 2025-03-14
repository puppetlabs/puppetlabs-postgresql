# @summary Installs PostgreSQL client software. Set the following parameters if you have a custom version you would like to install.
#
# @note
#  Make sure to add any necessary yum or apt repositories if specifying a custom version.
#
# @param file_ensure
#   Ensure the connection validation script is present
# @param validcon_script_path
#   Deprecated: absolute path for the postgresql connection validation script that is now ensured absent.
# @param package_name
#   Sets the name of the PostgreSQL client package.
# @param package_ensure
#   Ensure the client package is installed
class postgresql::client (
  Enum['file', 'absent'] $file_ensure          = 'file',
  Stdlib::Absolutepath   $validcon_script_path = $postgresql::params::validcon_script_path,
  String[1]              $package_name         = $postgresql::params::client_package_name,
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'present',
) inherits postgresql::params {
  if $package_name != 'UNSET' {
    package { 'postgresql-client':
      ensure => $package_ensure,
      name   => $package_name,
      tag    => 'puppetlabs-postgresql',
    }
  }

  file { $validcon_script_path:
    ensure => absent,
  }
}
