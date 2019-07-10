# @api private
class postgresql::server::install {
  $package_ensure             = $postgresql::server::package_ensure
  $package_name               = $postgresql::server::package_name
  $jit_enable                 = $postgresql::server::jit_enable
  $pgsql_llvmjit_package_name = $postgresql::server::pgsql_llvmjit_package_name

  $_package_ensure = $package_ensure ? {
    true     => 'present',
    false    => 'purged',
    'absent' => 'purged',
    default => $package_ensure,
  }

  package { 'postgresql-server':
    ensure => $_package_ensure,
    name   => $package_name,

    # This is searched for to create relationships with the package repos, be
    # careful about its removal
    tag    => 'puppetlabs-postgresql',
  }

  if $jit_enable == true {
    package { 'postgresql-jit-package':
      ensure => $_package_ensure,
      name   => $pgsql_llvmjit_package_name,

      # This is searched for to create relationships with the package repos, be
      # careful about its removal
      tag    => 'puppetlabs-postgresql',
    }
  }

}
