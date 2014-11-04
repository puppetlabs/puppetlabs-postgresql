# Activate an extension on a postgresql database
define postgresql::server::extension (
  $database,
) {
  postgresql_psql {"Add ${title} extension to ${database}":
    db      => $database,
    command => "CREATE EXTENSION ${name}",
    unless  => "SELECT extname FROM pg_extension WHERE extname = '${name}'",
    require => Postgresql::Server::Database[$database],
  }
}
