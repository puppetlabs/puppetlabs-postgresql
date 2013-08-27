# PRIVATE CLASS: do not call directly
class postgresql::server::install {
  $package_ensure = $postgresql::server::package_ensure
  $package_name   = $postgresql::server::package_name

  package { 'postgresql-server':
    ensure => $package_ensure,
    name   => $package_name,

    # This is searched for to create relationships with the package repos, be
    # careful about its removal
    tag    => 'postgresql',
  }
}
