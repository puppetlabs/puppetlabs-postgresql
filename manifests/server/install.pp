# PRIVATE CLASS: do not call directly
class postgresql::server::install {
  $package_ensure      = $postgresql::server::package_ensure
  $package_name        = $postgresql::server::package_name

  $_package_ensure = $package_ensure ? {
    true     => 'present',
    false    => 'purged',
    'absent' => 'purged',
    default => $package_ensure,
  }

  package { $package_name:
    ensure => $_package_ensure,

    # This is searched for to create relationships with the package repos, be
    # careful about its removal
    tag    => 'postgresql',
  }

}
