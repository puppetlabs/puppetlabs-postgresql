# == Class: postgresql::server::pg_hba_rules
#
#  Helper class to create serveral pg_hba_rule ressource
#  in one call
#
class postgresql::server::pg_hba_rules (
  $pg_hba_rules = {}
) {
  validate_hash($pg_hba_rules)
  create_resources('postgresql::server::pg_hba_rule', $pg_hba_rules)
}
