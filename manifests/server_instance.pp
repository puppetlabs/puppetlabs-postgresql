# @summary define to install and manage additional postgresql instances
# @param instance_name The name of the instance.
# @param instance_user The user to run the instance as.
# @param instance_group The group to run the instance as.
# @param instance_user_homedirectory The home directory of the instance user.
# @param manage_instance_user_and_group Should Puppet manage the instance user and it's primary group?.
# @param instance_directories directories needed for the instance. Option to manage the directory properties for each directory.
# @param initdb_settings Specifies a hash witn parameters for postgresql::server::instance::initdb
# @param config_settings Specifies a hash with parameters for postgresql::server::instance::config
# @param service_settings Specifies a hash with parameters for postgresql::server:::instance::service
# @param passwd_settings Specifies a hash with parameters for postgresql::server::instance::passwd
# @param roles Specifies a hash from which to generate postgresql::server::role resources.
# @param config_entries Specifies a hash from which to generate postgresql::server::config_entry resources.
# @param pg_hba_rules Specifies a hash from which to generate postgresql::server::pg_hba_rule resources.
# @param databases Specifies a hash from which to generate postgresql::server::database resources.
# @param databases_and_users Specifies a hash from which to generate postgresql::server::db resources.
# @param database_grants Specifies a hash from which to generate postgresql::server::database_grant resources.
# @param table_grants Specifies a hash from which to generate postgresql::server::table_grant resources.
define postgresql::server_instance (
  String[1] $instance_name                          = $name,
  Boolean $manage_instance_user_and_group           = true,
  Hash $instance_directories                        = {},
  String[1] $instance_user                          = $instance_name,
  String[1] $instance_group                         = $instance_name,
  Stdlib::Absolutepath $instance_user_homedirectory = "/opt/pgsql/data/home/${instance_user}",
  Hash $initdb_settings                             = {},
  Hash $config_settings                             = {},
  Hash $service_settings                            = {},
  Hash $passwd_settings                             = {},
  Hash $roles                                       = {},
  Hash $config_entries                              = {},
  Hash $pg_hba_rules                                = {},
  Hash $databases_and_users                         = {},
  Hash $databases                                   = {},
  Hash $database_grants                             = {},
  Hash $table_grants                                = {},
) {
  unless($facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '8') {
    warning('This define postgresql::server_instance is only tested on RHEL8')
  }
  $instance_directories.each |Stdlib::Absolutepath $directory, Hash $directory_settings| {
    file { $directory:
      * => $directory_settings,
    }
  }

  if $manage_instance_user_and_group {
    user { $instance_user:
      managehome => true,
      system     => true,
      home       => $instance_user_homedirectory,
      gid        => $instance_group,
    }
    group { $instance_group:
      system => true,
    }
  }
  postgresql::server::instance::initdb { $instance_name:
    * => $initdb_settings,
  }
  postgresql::server::instance::config { $instance_name:
    * => $config_settings,
  }
  postgresql::server::instance::service { $instance_name:
    *    => $service_settings,
    port => $config_settings['port'],
    user => $instance_user,
  }
  postgresql::server::instance::passwd { $instance_name:
    * => $passwd_settings,
  }

  $roles.each |$rolename, $role| {
    postgresql::server::role { $rolename:
      *          => $role,
      psql_user  => $instance_user,
      psql_group => $instance_group,
      port       => $config_settings['port'],
      instance   => $instance_name,
    }
  }

  $config_entries.each |$entry, $settings| {
    $value   = $settings['value']
    $comment = $settings['comment']
    postgresql::server::config_entry { "${entry}_${$instance_name}":
      ensure  => bool2str($value =~ Undef, 'absent', 'present'),
      key     => $entry,
      value   => $value,
      comment => $comment,
      path    => $config_settings['postgresql_conf_path'],
    }
  }
  $pg_hba_rules.each |String[1] $rule_name, Postgresql::Pg_hba_rule $rule| {
    $rule_title = "${rule_name} for instance ${name}"
    postgresql::server::pg_hba_rule { $rule_title:
      *      => $rule,
      target => $config_settings['pg_hba_conf_path'], # TODO: breaks if removed
    }
  }
  $databases_and_users.each |$database, $database_details| {
    postgresql::server::db { $database:
      *          => $database_details,
      psql_user  => $instance_user,
      psql_group => $instance_group,
      port       => $config_settings['port'],
    }
  }
  $databases.each |$database, $database_details| {
    postgresql::server::database { $database:
      *     => $database_details,
      user  => $instance_user,
      group => $instance_group,
      port  => $config_settings['port'],
    }
  }
  $database_grants.each |$db_grant_title, $dbgrants| {
    postgresql::server::database_grant { $db_grant_title:
      *          => $dbgrants,
      psql_user  => $instance_user,
      psql_group => $instance_group,
      port       => $config_settings['port'],
    }
  }
  $table_grants.each |$table_grant_title, $tgrants| {
    postgresql::server::table_grant { $table_grant_title:
      *         => $tgrants,
      psql_user => $instance_user,
      port      => $config_settings['port'],
    }
  }
}
