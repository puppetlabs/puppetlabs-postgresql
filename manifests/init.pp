# Class: postgresql
#
#   This class installs postgresql client software.
#
#   *Note* don't forget to make sure to add any necessary yum or apt
#   repositories if specifying a custom version.
#
# Parameters:
#   [*version*] - The postgresql version to install.
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql (
  $version = $::postgres_default_version,
) {
  class { 'postgresql::params':
    version => $version,
  }
}
