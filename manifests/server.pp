# @summary This installs a PostgreSQL server
#
# @param postgres_password
#   Sets the password for the postgres user to your specified value. By default, this setting uses the superuser account in the Postgres
#   database, with a user called postgres and no password.
# @param package_name Specifies the name of the package to use for installing the server software.
# @param package_ensure Passes a value through to the package resource when creating the server instance.
#
# @param plperl_package_name Sets the default package name for the PL/Perl extension.
# @param plpython_package_name Sets the default package name for the PL/Python extension.
#
# @param service_ensure Ensure service is installed
# @param service_enable Enable the PostgreSQL service
# @param service_manage Defines whether or not Puppet should manage the service.
# @param service_name Overrides the default PostgreSQL service name.
# @param service_restart_on_change
#   Overrides the default behavior to restart your PostgreSQL service when a config entry has been changed that requires a service restart
#   to become active.
# @param service_provider Overrides the default PostgreSQL service provider.
# @param service_reload Overrides the default reload command for your PostgreSQL service.
# @param service_status Overrides the default status check command for your PostgreSQL service.
# @param default_database Specifies the name of the default database to connect with. On most systems this is 'postgres'.
# @param default_connect_settings
#   Specifies a hash of environment variables used when connecting to a remote server. Becomes the default for other defined types, such as
#   postgresql::server::role.
#
# @param listen_addresses Address list on which the PostgreSQL service will listen
# @param port
#   Specifies the port for the PostgreSQL server to listen on.
#   Note: The same port number is used for all IP addresses the server listens on.
#   Also, for Red Hat systems and early Debian systems, changing the port causes the server to come to a full stop before being able to make
#   the change.
#   Default value: 5432. Meaning the Postgres server listens on TCP port 5432.
#
# @param ip_mask_deny_postgres_user Specifies the IP mask from which remote connections should be denied for the postgres superuser.
#   Default value: '0.0.0.0/0', which denies any remote connection.
#
# @param ip_mask_allow_all_users
#   Overrides PostgreSQL defaults for remote connections. By default, PostgreSQL does not allow database user accounts to connect via TCP
#   from remote machines. If you'd like to allow this, you can override this setting.
#   Set to '0.0.0.0/0' to allow database users to connect from any remote machine, or '192.168.0.0/1' to allow connections from any machine
#   on your local '192.168' subnet.
#   Default value: '127.0.0.1/32'.
#
# @param ipv4acls Lists strings for access control for connection method, users, databases, IPv4 addresses;
# @param ipv6acls Lists strings for access control for connection method, users, databases, IPv6 addresses.
#
# @param initdb_path Specifies the path to the initdb command.
# @param psql_path Specifies the path to the psql command.
# @param pg_hba_conf_path Specifies the path to your pg_hba.conf file.
# @param pg_ident_conf_path Specifies the path to your pg_ident.conf file.
# @param postgresql_conf_path Specifies the path to your postgresql.conf file.
# @param postgresql_conf_mode Sets the mode of your postgresql.conf file. Only relevant if manage_postgresql_conf_perms is true.
# @param recovery_conf_path Specifies the path to your recovery.conf file.
#
# @param datadir PostgreSQL data directory
# @param xlogdir PostgreSQL xlog directory
# @param logdir PostgreSQL log directory
#
# @param log_line_prefix PostgreSQL log line prefix
#
# @param pg_hba_conf_defaults
#   If false, disables the defaults supplied with the module for pg_hba.conf. This is useful if you disagree with the defaults and wish to
#   override them yourself. Be sure that your changes of course align with the rest of the module, as some access is required to perform
#   basic psql operations for example.
#
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
#
# @param needs_initdb Explicitly calls the initdb operation after server package is installed, and before the PostgreSQL service is started.
#
# @param encoding
#   Sets the default encoding for all databases created with this module. On certain operating systems this is also used during the
#   template1 initialization, so it becomes a default outside of the module as well.
# @param locale
#   Sets the default database locale for all databases created with this module. On certain operating systems this is used during the
#   template1 initialization as well, so it becomes a default outside of the module.
# @param data_checksums
#   Use checksums on data pages to help detect corruption by the I/O system that would otherwise be silent.
#   Warning: This option is used during initialization by initdb, and cannot be changed later.
#   If set, checksums are calculated for all objects, in all databases.
#
# @param timezone Set timezone for the PostgreSQL instance
#
# @param manage_pg_hba_conf Boolean. Whether to manage the pg_hba.conf.
# @param manage_pg_ident_conf Boolean. Overwrites the pg_ident.conf file.
# @param manage_recovery_conf Boolean. Specifies whether or not manage the recovery.conf.
# @param manage_postgresql_conf_perms
#   Whether to manage the postgresql conf file permissions. This means owner,
#   group and mode. Contents are not managed but should be managed through
#   postgresql::server::config_entry.
# @param manage_selinux Specifies whether or not manage the conf file for selinux.
# @param module_workdir Working directory for the PostgreSQL module
#
# @param manage_datadir Set to false if you have file{ $datadir: } already defined
# @param manage_logdir Set to false if you have file{ $logdir: } already defined
# @param manage_xlogdir Set to false if you have file{ $xlogdir: } already defined
# @param password_encryption Specify the type of encryption set for the password.
# @param pg_hba_auth_password_encryption
#   Specify the type of encryption set for the password in pg_hba_conf,
#   this value is usefull if you want to start enforcing scram-sha-256, but give users transition time.
# @param roles Specifies a hash from which to generate postgresql::server::role resources.
# @param config_entries Specifies a hash from which to generate postgresql::server::config_entry resources.
# @param pg_hba_rules Specifies a hash from which to generate postgresql::server::pg_hba_rule resources.
#
# @param backup_enable Whether a backup job should be enabled.
# @param backup_options A hash of options that should be passed through to the backup provider.
# @param backup_provider Specifies the backup provider to use.
#
# @param extra_systemd_config
#   Adds extra config to systemd config file, can for instance be used to add extra openfiles. This can be a multi line string
# @param auth_host auth method used by default for host authorization
# @param auth_local  auth method used by default for local authorization
# @param lc_messages locale used for logging and system messages
# @param username username of user running the postgres instance
#
class postgresql::server (
  Optional[Variant[String[1], Sensitive[String[1]], Integer]] $postgres_password = undef,

  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = $postgresql::params::package_ensure, # lint:ignore:140chars
  String[1]                                          $package_name                 = $postgresql::params::server_package_name,

  Optional[String[1]]                                $plperl_package_name          = $postgresql::params::plperl_package_name,
  Optional[String[1]]                                $plpython_package_name        = $postgresql::params::plpython_package_name,

  Variant[Enum['running', 'stopped'], Boolean]       $service_ensure               = $postgresql::params::service_ensure,
  Boolean                                            $service_enable               = $postgresql::params::service_enable,
  Boolean                                            $service_manage               = $postgresql::params::service_manage,
  String[1]                                          $service_name                 = $postgresql::params::service_name,
  Boolean                                            $service_restart_on_change    = $postgresql::params::service_restart_on_change,
  Optional[String[1]]                                $service_provider             = $postgresql::params::service_provider,
  String[1]                                          $service_reload               = $postgresql::params::service_reload,
  Optional[String[1]]                                $service_status               = $postgresql::params::service_status,
  String[1]                                          $default_database             = $postgresql::params::default_database,
  Hash                                               $default_connect_settings     = $postgresql::globals::default_connect_settings,
  Optional[Variant[String[1], Array[String[1]]]]     $listen_addresses             = $postgresql::params::listen_addresses,
  Stdlib::Port                                       $port                         = $postgresql::params::port,
  String[1]                                          $ip_mask_deny_postgres_user   = $postgresql::params::ip_mask_deny_postgres_user,
  String[1]                                          $ip_mask_allow_all_users      = $postgresql::params::ip_mask_allow_all_users,
  Array[String[1]]                                   $ipv4acls                     = $postgresql::params::ipv4acls,
  Array[String[1]]                                   $ipv6acls                     = $postgresql::params::ipv6acls,

  Stdlib::Absolutepath                               $initdb_path                  = $postgresql::params::initdb_path,
  Stdlib::Absolutepath                               $psql_path                    = $postgresql::params::psql_path,
  Stdlib::Absolutepath                               $pg_hba_conf_path             = $postgresql::params::pg_hba_conf_path,
  Stdlib::Absolutepath                               $pg_ident_conf_path           = $postgresql::params::pg_ident_conf_path,
  Stdlib::Absolutepath                               $postgresql_conf_path         = $postgresql::params::postgresql_conf_path,
  Optional[Stdlib::Filemode]                         $postgresql_conf_mode         = $postgresql::params::postgresql_conf_mode,
  Stdlib::Absolutepath                               $recovery_conf_path           = $postgresql::params::recovery_conf_path,

  Stdlib::Absolutepath                               $datadir                      = $postgresql::params::datadir,
  Optional[Stdlib::Absolutepath]                     $xlogdir                      = $postgresql::params::xlogdir,
  Optional[Stdlib::Absolutepath]                     $logdir                       = $postgresql::params::logdir,

  Optional[String[1]]                                $log_line_prefix              = $postgresql::params::log_line_prefix,

  Boolean                                            $pg_hba_conf_defaults         = $postgresql::params::pg_hba_conf_defaults,

  String[1]                                          $user                         = $postgresql::params::user,
  String[1]                                          $group                        = $postgresql::params::group,

  Boolean                                            $needs_initdb                 = $postgresql::params::needs_initdb,

  Optional[String[1]]                                $auth_host                    = undef,
  Optional[String[1]]                                $auth_local                   = undef,
  Optional[String[1]]                                $encoding                     = $postgresql::params::encoding,
  Optional[String[1]]                                $locale                       = $postgresql::params::locale,
  Optional[String[1]]                                $lc_messages                  = undef,
  Optional[Boolean]                                  $data_checksums               = $postgresql::params::data_checksums,
  Optional[String[1]]                                $username                     = $user,
  Optional[String[1]]                                $timezone                     = $postgresql::params::timezone,

  Boolean                                            $manage_pg_hba_conf           = $postgresql::params::manage_pg_hba_conf,
  Boolean                                            $manage_pg_ident_conf         = $postgresql::params::manage_pg_ident_conf,
  Boolean                                            $manage_recovery_conf         = $postgresql::params::manage_recovery_conf,
  Boolean                                            $manage_postgresql_conf_perms = $postgresql::params::manage_postgresql_conf_perms,
  Boolean                                            $manage_selinux               = $postgresql::params::manage_selinux,
  Stdlib::Absolutepath                               $module_workdir               = $postgresql::params::module_workdir,

  Boolean                                            $manage_datadir               = $postgresql::params::manage_datadir,
  Boolean                                            $manage_logdir                = $postgresql::params::manage_logdir,
  Boolean                                            $manage_xlogdir               = $postgresql::params::manage_xlogdir,
  Postgresql::Pg_password_encryption                 $password_encryption          = $postgresql::params::password_encryption,
  Optional[Postgresql::Pg_password_encryption]       $pg_hba_auth_password_encryption = undef,
  Optional[String]                                   $extra_systemd_config         = $postgresql::params::extra_systemd_config,

  Hash[String, Hash]                                 $roles                        = {},
  Hash[String, Any]                                  $config_entries               = {},
  Postgresql::Pg_hba_rules                           $pg_hba_rules                 = {},

  Boolean                                            $backup_enable                = $postgresql::params::backup_enable,
  Hash                                               $backup_options               = {},
  Enum['pg_dump']                                    $backup_provider              = $postgresql::params::backup_provider,
) inherits postgresql::params {
  $_version = $postgresql::params::version

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
      ensure => bool2str($value =~ Undef, 'absent', 'present'),
      value  => $value,
    }
  }

  $pg_hba_rules.each |String[1] $rule_name, Postgresql::Pg_hba_rule $rule| {
    postgresql::server::pg_hba_rule { $rule_name:
      * => $rule,
    }
  }

  if $backup_enable {
    case $backup_provider {
      'pg_dump': {
        class { 'postgresql::backup::pg_dump':
          * => $backup_options,
        }
      }
      default: {
        fail("Unsupported backup provider '${backup_provider}'.")
      }
    }
  }
}
