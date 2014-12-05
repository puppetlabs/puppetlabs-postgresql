# Activate an extension on a postgresql database
define postgresql::server::extension (
  $database,
  $package_name = undef,
  $package_ensure = 'present',
) {
  postgresql_psql {"Add ${title} extension to ${database}":
    db      => $database,
    command => "CREATE EXTENSION ${name}",
    unless  => "SELECT extname FROM pg_extension WHERE extname = '${name}'",
    require => Postgresql::Server::Database[$database],
  }

  if $package_name {
    package { "Postgresql extension ${title}":
      ensure => $package_ensure,
      name   => $package_name,
    }
  }
}
