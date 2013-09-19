# PRIVATE CLASS: do not call directly
class postgresql::server::install {
  $package_ensure = $postgresql::server::package_ensure
  $package_name   = $postgresql::server::package_name

  if($::operatingsystem == "Ubuntu" and $_package_ensure) {
    exec { "apt-get-autoremove-postgresql-server":
      command   => "apt-get autoremove --force --yes ${package_name}",
      onlyif    => "dpkg -l ${package_name} | grep -e '^ii'",
      logoutput => on_failure,
    }
  } else {
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
      tag    => 'postgresql',
    }
  }

}
