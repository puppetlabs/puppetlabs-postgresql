class postgresql($databases = {}) {
  validate_hash($databases)
  create_resources('postgresql::server::db', hiera_hash('postgresql::databases', {}))
}
