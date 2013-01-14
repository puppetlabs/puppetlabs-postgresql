# Class: postgresql
#
#   This is a base class that can be used to modify catalog-wide settings relating
#   to the various types in class contained in the postgresql module.
#
#   If you don't declare this class in your catalog, sensible defaults will
#   be used.  However, if you choose to declare it, it needs to appear *before*
#   any other types or classes from the postgresql module.
#
#   For examples, see the files in the `tests` directory; in particular,
#    `/server-yum-postgresql-org.pp`.
#
# Parameters:
#   [*version*] - The postgresql version to install.  If not specified, the
#                 module will use whatever version is the default for your
#                 OS distro.
#   [*manage_package_repo*] - This determines whether or not the module should
#                 attempt to manage the postgres package repository for your
#                 distro.  Defaults to `false`, but if set to `true`, it can
#                 be used to set up the official postgres yum/apt package
#                 repositories for you.
#   [*package_source*] - This setting is only used if `manage_package_repo` is
#                 set to `true`.  It determines which package repository should
#                 be used to install the postgres packages.  Currently supported
#                 values include `yum.postgresql.org`.
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql (
  $version = $::postgres_default_version,
  $manage_package_repo = false,
  $package_source      = undef
) {
  class { 'postgresql::params':
    version             => $version,
    manage_package_repo => $manage_package_repo,
    package_source      => $package_source
  }
}
