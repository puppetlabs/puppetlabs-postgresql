# @summary This installs a PostgreSQL server
#
# @param postgres_password
# @param package_name
# @param package_ensure
#
# @param plperl_package_name
# @param plpython_package_name
#
# @param service_ensure
# @param service_enable
# @param service_manage
# @param service_name
# @param service_restart_on_change
# @param service_provider
# @param service_reload
# @param service_status
# @param default_database
# @param default_connect_settings
# @param listen_addresses
# @param port
# @param ip_mask_deny_postgres_user
# @param ip_mask_allow_all_users
# @param ipv4acls
# @param ipv6acls
#
# @param initdb_path
# @param createdb_path
# @param psql_path
# @param pg_hba_conf_path
# @param pg_ident_conf_path
# @param postgresql_conf_path
# @param recovery_conf_path
#
# @param datadir
# @param xlogdir
# @param logdir
#
# @param log_line_prefix
#
# @param pg_hba_conf_defaults
#
# @param user
# @param group
#
# @param needs_initdb
#
# @param encoding
# @param locale
# @param data_checksums
# @param timezone
#
# @param manage_pg_hba_conf
# @param manage_pg_ident_conf
# @param manage_recovery_conf
# @param module_workdir
#
# @param roles
# @param config_entries
# @param pg_hba_rules
#
# @param version
#
#
class postgresql::server (
  $postgres_password          = undef,

  $package_name               = $postgresql::params::server_package_name,
  $package_ensure             = $postgresql::params::package_ensure,

  $plperl_package_name        = $postgresql::params::plperl_package_name,
  $plpython_package_name      = $postgresql::params::plpython_package_name,

  $service_ensure             = $postgresql::params::service_ensure,
  $service_enable             = $postgresql::params::service_enable,
  $service_manage             = $postgresql::params::service_manage,
  $service_name               = $postgresql::params::service_name,
  $service_restart_on_change  = $postgresql::params::service_restart_on_change,
  $service_provider           = $postgresql::params::service_provider,
  $service_reload             = $postgresql::params::service_reload,
  $service_status             = $postgresql::params::service_status,
  $default_database           = $postgresql::params::default_database,
  $default_connect_settings   = $postgresql::globals::default_connect_settings,
  $listen_addresses           = $postgresql::params::listen_addresses,
  $port                       = $postgresql::params::port,
  $ip_mask_deny_postgres_user = $postgresql::params::ip_mask_deny_postgres_user,
  $ip_mask_allow_all_users    = $postgresql::params::ip_mask_allow_all_users,
  $ipv4acls                   = $postgresql::params::ipv4acls,
  $ipv6acls                   = $postgresql::params::ipv6acls,

  $initdb_path                = $postgresql::params::initdb_path,
  $createdb_path              = $postgresql::params::createdb_path,
  $psql_path                  = $postgresql::params::psql_path,
  $pg_hba_conf_path           = $postgresql::params::pg_hba_conf_path,
  $pg_ident_conf_path         = $postgresql::params::pg_ident_conf_path,
  $postgresql_conf_path       = $postgresql::params::postgresql_conf_path,
  $recovery_conf_path         = $postgresql::params::recovery_conf_path,

  $datadir                    = $postgresql::params::datadir,
  $xlogdir                    = $postgresql::params::xlogdir,
  $logdir                     = $postgresql::params::logdir,

  $log_line_prefix            = $postgresql::params::log_line_prefix,

  $pg_hba_conf_defaults       = $postgresql::params::pg_hba_conf_defaults,

  $user                       = $postgresql::params::user,
  $group                      = $postgresql::params::group,

  $needs_initdb               = $postgresql::params::needs_initdb,

  $encoding                   = $postgresql::params::encoding,
  $locale                     = $postgresql::params::locale,
  $data_checksums             = $postgresql::params::data_checksums,
  $timezone                   = $postgresql::params::timezone,

  $manage_pg_hba_conf         = $postgresql::params::manage_pg_hba_conf,
  $manage_pg_ident_conf       = $postgresql::params::manage_pg_ident_conf,
  $manage_recovery_conf       = $postgresql::params::manage_recovery_conf,
  $module_workdir             = $postgresql::params::module_workdir,

  Hash[String, Hash] $roles         = {},
  Hash[String, Any] $config_entries = {},
  Hash[String, Hash] $pg_hba_rules  = {},

  #Deprecated
  $version                    = undef,
) inherits postgresql::params {
  if $version != undef {
    warning('Passing "version" to postgresql::server is deprecated; please use postgresql::globals instead.')
    $_version = $version
  } else {
    $_version = $postgresql::params::version
  }

  if $createdb_path != undef{
    warning('Passing "createdb_path" to postgresql::server is deprecated, it can be removed safely for the same behaviour')
  }

  # Reload has its own ordering, specified by other defines
  class { 'postgresql::server::reload':
    require => Class['postgresql::server::install'],
  }

  contain postgresql::server::install
  contain postgresql::server::initdb
  contain postgresql::server::config
  contain postgresql::server::service
  contain postgresql::server::passwd

  Class['postgresql::server::install']
  -> Class['postgresql::server::initdb']
  -> Class['postgresql::server::config']
  -> Class['postgresql::server::service']
  -> Class['postgresql::server::passwd']

  $roles.each |$rolename, $role| {
    postgresql::server::role { $rolename:
      * => $role,
    }
  }

  $config_entries.each |$entry, $value| {
    postgresql::server::config_entry { $entry:
      value => $value,
    }
  }

  $pg_hba_rules.each |$rule_name, $rule| {
    postgresql::server::pg_hba_rule { $rule_name:
      * => $rule,
    }
  }
}
