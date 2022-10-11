# @summary enum for all different types for the pg_hba_conf
# @see https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
type Postgresql::Pg_hba_rule_type = Enum['local', 'host', 'hostssl', 'hostnossl', 'hostgssenc', 'hostnogssenc']
