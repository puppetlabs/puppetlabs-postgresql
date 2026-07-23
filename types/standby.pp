# @summary validates a hash of entries for postgresql::server's $standby parameter
# @see https://github.com/ikonia/puppetlabs-postgresql/blob/be/manifests/server/recovery.pp
type Postgresql::Standby = Hash[String[1], Postgresql::Recovery]
