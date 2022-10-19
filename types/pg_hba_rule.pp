# @summary type for all parameters in the postgresql::server::hba_rule defined resource
# @see https://github.com/puppetlabs/puppetlabs-postgresql/blob/main/manifests/server/pg_hba_rule.pp
type Postgresql::Pg_hba_rule = Struct[{
    Optional[description]        => String,
    type                         => Postgresql::Pg_hba_rule_type,
    database                     => String,
    user                         => String,
    Optional[address]            => Optional[Postgresql::Pg_hba_rule_address],
    auth_method                  => String,
    Optional[auth_option]        => Optional[String],
    Optional[order]              => Variant[String,Integer],
    Optional[target]             => Stdlib::Absolutepath,
    Optional[postgresql_version] => String,
}]
