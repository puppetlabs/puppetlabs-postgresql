# @summary validates a hash of entries for postgresql::server::pg_hab_conf
# @see https://github.com/puppetlabs/puppetlabs-postgresql/blob/main/manifests/server/pg_hba_rule.pp
type Postgresql::Pg_hba_rules = Hash[String[1], Postgresql::Pg_hba_rule]
