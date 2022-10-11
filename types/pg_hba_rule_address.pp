# @summary Supported address types
# @see https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
type Postgresql::Pg_hba_rule_address = Variant[
  Stdlib::IP::Address::V4::CIDR,
  Stdlib::IP::Address::V6::CIDR,
  Stdlib::Fqdn,
  Enum['all', 'samehost', 'samenet'],
  # RegExp for a DNS domain - also starting with a single dot
  Pattern[/^\.(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]$/],
]
