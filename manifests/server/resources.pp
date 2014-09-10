# PRIVATE CLASS: do not call directly
# This creates roles, table_grants, database_grants and hba rules directly from
# resource hash variables in postgresql::server.
class postgresql::server::resources {
  $roles           = $postgresql::server::roles
  $database_grants = $postgresql::server::database_grants
  $table_grants    = $postgresql::server::table_grants
  $hba_rules       = $postgresql::server::hba_rules

  # Create roles
  create_resources('postgresql::server::role', $roles)

  # Create database grants
  create_resources('postgresql::server::database_grant', $database_grants)

  # Create table grants
  create_resources('postgresql::server::table_grant', $table_grants)

  # Create hba rules
  create_resources('postgresql::server::pg_hba_rule', $hba_rules)
}
