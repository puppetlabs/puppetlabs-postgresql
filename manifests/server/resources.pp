# PRIVATE CLASS: do not call directly
# This creates roles, table_grants, database_grants directly from resource
# hash variables in postgresql::server.
class postgresql::server::resources {
  $roles           = $postgresql::server::roles
  $database_grants = $postgresql::server::database_grants
  $table_grants    = $postgresql::server::table_grants

  # Create roles
  create_resources('postgresql::server::role', $roles)

  # Create database grants
  create_resources('postgresql::server::database_grant', $database_grants)

  # Create table grants
  create_resources('postgresql::server::table_grant', $table_grants)
}
