# @summary Manages the config for a postgresql::server instance
#
# @param ip_mask_deny_postgres_user Specifies the IP mask from which remote connections should be denied for the postgres superuser.
#   Default value: '0.0.0.0/0', which denies any remote connection.
# @param ip_mask_allow_all_users
#   Overrides PostgreSQL defaults for remote connections. By default, PostgreSQL does not allow database user accounts to connect via TCP
#   from remote machines. If you'd like to allow this, you can override this setting.
#   Set to '0.0.0.0/0' to allow database users to connect from any remote machine, or '192.168.0.0/1' to allow connections from any machine
#   on your local '192.168' subnet.
#   Default value: '127.0.0.1/32'.
# @param listen_addresses Address list on which the PostgreSQL service will listen
# @param port
#   Specifies the port for the PostgreSQL server to listen on.
#   Note: The same port number is used for all IP addresses the server listens on. Also, for Red Hat systems and early Debian systems,
#   changing the port causes the server to come to a full stop before being able to make the change.
#   Default value: 5432. Meaning the Postgres server listens on TCP port 5432.
# @param ipv4acls Lists strings for access control for connection method, users, databases, IPv4 addresses.
# @param ipv6acls Lists strings for access control for connection method, users, databases, IPv6 addresses.
# @param pg_hba_conf_path Specifies the path to your pg_hba.conf file.
# @param pg_ident_conf_path Specifies the path to your pg_ident.conf file.
# @param postgresql_conf_path Specifies the path to your postgresql.conf file.
# @param postgresql_conf_mode Sets the mode of your postgresql.conf file. Only relevant if manage_postgresql_conf_perms is true.
# @param recovery_conf_path Specifies the path to your recovery.conf file.
# @param pg_hba_conf_defaults
#   If false, disables the defaults supplied with the module for pg_hba.conf. This is useful if you disagree with the defaults and wish to
#   override them yourself. Be sure that your changes of course align with the rest of the module, as some access is required to perform
#   basic psql operations for example.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
# @param version Sets PostgreSQL version
# @param manage_pg_hba_conf Boolean. Whether to manage the pg_hba.conf.
# @param manage_pg_ident_conf Boolean. Overwrites the pg_ident.conf file.
# @param manage_recovery_conf Boolean. Specifies whether or not manage the recovery.conf.
# @param manage_postgresql_conf_perms
#   Whether to manage the postgresql conf file permissions. This means owner,
#   group and mode. Contents are not managed but should be managed through
#   postgresql::server::config_entry.
# @param datadir PostgreSQL data directory
# @param logdir PostgreSQL log directory
# @param service_name Overrides the default PostgreSQL service name.
# @param service_enable Enable the PostgreSQL service
# @param log_line_prefix PostgreSQL log line prefix
# @param timezone Set timezone for the PostgreSQL instance
# @param password_encryption Specify the type of encryption set for the password.
# @param extra_systemd_config
#   Adds extra config to systemd config file, can for instance be used to add extra openfiles. This can be a multi line string
define postgresql::server::instance::config (
  String[1]                                      $ip_mask_deny_postgres_user   = $postgresql::server::ip_mask_deny_postgres_user,
  String[1]                                      $ip_mask_allow_all_users      = $postgresql::server::ip_mask_allow_all_users,
  Optional[Variant[String[1], Array[String[1]]]] $listen_addresses             = $postgresql::server::listen_addresses,
  Variant[String[1], Stdlib::Port]               $port                         = $postgresql::server::port,
  Array[String[1]]                               $ipv4acls                     = $postgresql::server::ipv4acls,
  Array[String[1]]                               $ipv6acls                     = $postgresql::server::ipv6acls,
  Variant[String[1], Stdlib::Absolutepath]       $pg_hba_conf_path             = $postgresql::server::pg_hba_conf_path,
  Variant[String[1], Stdlib::Absolutepath]       $pg_ident_conf_path           = $postgresql::server::pg_ident_conf_path,
  Variant[String[1], Stdlib::Absolutepath]       $postgresql_conf_path         = $postgresql::server::postgresql_conf_path,
  Optional[Stdlib::Filemode]                     $postgresql_conf_mode         = $postgresql::server::postgresql_conf_mode,
  Variant[String[1], Stdlib::Absolutepath]       $recovery_conf_path           = $postgresql::server::recovery_conf_path,
  Boolean                                        $pg_hba_conf_defaults         = $postgresql::server::pg_hba_conf_defaults,
  String[1]                                      $user                         = $postgresql::server::user,
  String[1]                                      $group                        = $postgresql::server::group,
  Optional[String[1]]                            $version                      = $postgresql::server::_version,
  Boolean                                        $manage_pg_hba_conf           = $postgresql::server::manage_pg_hba_conf,
  Boolean                                        $manage_pg_ident_conf         = $postgresql::server::manage_pg_ident_conf,
  Boolean                                        $manage_recovery_conf         = $postgresql::server::manage_recovery_conf,
  Boolean                                        $manage_postgresql_conf_perms = $postgresql::server::manage_postgresql_conf_perms,
  String[1]                                      $datadir                      = $postgresql::server::datadir,
  Optional[String[1]]                            $logdir                       = $postgresql::server::logdir,
  String[1]                                      $service_name                 = $postgresql::server::service_name,
  Boolean                                        $service_enable               = $postgresql::server::service_enable,
  Optional[String[1]]                            $log_line_prefix              = $postgresql::server::log_line_prefix,
  Optional[String[1]]                            $timezone                     = $postgresql::server::timezone,
  Optional[Postgresql::Pg_password_encryption]   $password_encryption          = $postgresql::server::password_encryption,
  Optional[String]                               $extra_systemd_config         = $postgresql::server::extra_systemd_config,
) {
  if $port =~ String {
    deprecation('postgres_port', 'Passing a string to the port parameter is deprecated. Stdlib::Port will be the enforced datatype in the next major release')
  }
  if ($manage_pg_hba_conf == true) {
    # Prepare the main pg_hba file
    concat { $pg_hba_conf_path:
      owner  => $user,
      group  => $group,
      mode   => '0640',
      warn   => true,
      notify => Class['postgresql::server::reload'],
    }

    if $pg_hba_conf_defaults {
      Postgresql::Server::Pg_hba_rule {
        database => 'all',
        user => 'all',
      }

      # Lets setup the base rules
      $local_auth_option = $version ? {
        '8.1'   => 'sameuser',
        default => undef,
      }

      postgresql::server::pg_hba_rule {
        "local access as postgres user for instance ${name}":
          type        => 'local',
          user        => $user,
          auth_method => 'ident',
          auth_option => $local_auth_option,
          order       => 1;

        "local access to database with same name for instance ${name}":
          type        => 'local',
          auth_method => 'ident',
          auth_option => $local_auth_option,
          order       => 2;

        "allow localhost TCP access to postgresql user for instance ${name}":
          type        => 'host',
          user        => $user,
          address     => '127.0.0.1/32',
          auth_method => 'md5',
          order       => 3;

        "deny access to postgresql user for instance ${name}":
          type        => 'host',
          user        => $user,
          address     => $ip_mask_deny_postgres_user,
          auth_method => 'reject',
          order       => 4;

        "allow access to all users for instance ${name}":
          type        => 'host',
          address     => $ip_mask_allow_all_users,
          auth_method => 'md5',
          order       => 100;

        "allow access to ipv6 localhost for instance ${name}":
          type        => 'host',
          address     => '::1/128',
          auth_method => 'md5',
          order       => 101;
      }
    }

    # $ipv4acls and $ipv6acls are arrays of rule strings
    # They are converted into hashes we can iterate over to create postgresql::server::pg_hba_rule resources.
    (
      postgresql::postgresql_acls_to_resources_hash($ipv4acls, 'ipv4acls', 10) +
      postgresql::postgresql_acls_to_resources_hash($ipv6acls, 'ipv6acls', 102)
    ).each | String $key, Hash $attrs| {
      postgresql::server::pg_hba_rule { $key:
        * => $attrs,
      }
    }
  }

  if $manage_postgresql_conf_perms {
    file { $postgresql_conf_path:
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => $postgresql_conf_mode,
    }
  }

  if $listen_addresses {
    postgresql::server::config_entry { "listen_addresses_for_instance_${name}":
      key   => 'listen_addresses',
      value => $listen_addresses,
    }
  }

  # ensure that SELinux has a proper label for the port defined
  if $postgresql::server::manage_selinux == true and $facts['os']['selinux']['enabled'] == true {
    case $facts['os']['family'] {
      'RedHat', 'Linux': {
        if $facts['os']['name'] == 'Amazon' {
          $package_name = 'policycoreutils'
        }
        else {
          $package_name = $facts['os']['release']['major'] ? {
            '5'     => 'policycoreutils',
            '6'     => 'policycoreutils-python',
            '7'     => 'policycoreutils-python',
            default => 'policycoreutils-python-utils',
          }
        }
      }
      default: {
        $package_name = 'policycoreutils'
      }
    }

    ensure_packages([$package_name])

    $exec_command = ['/usr/sbin/semanage', 'port', '-a', '-t', 'postgresql_port_t', '-p', 'tcp', $port]
    $exec_unless = "/usr/sbin/semanage port -l | grep -qw ${port}"
    exec { "/usr/sbin/semanage port -a -t postgresql_port_t -p tcp ${port}":
      command => $exec_command,
      unless  => $exec_unless,
      before  => Postgresql::Server::Config_entry["port_for_instance_${name}"],
      require => Package[$package_name],
    }
  }

  postgresql::server::config_entry { "port_for_instance_${name}":
    key   => 'port',
    value => $port,
  }

  if ($password_encryption) and (versioncmp($version, '10') >= 0) {
    postgresql::server::config_entry { "password_encryption_for_instance_${name}":
      key   => 'password_encryption',
      value => $password_encryption,
    }
  }

  postgresql::server::config_entry { "data_directory_for_instance_${name}":
    key   => 'data_directory',
    value => $datadir,
  }
  if $timezone {
    postgresql::server::config_entry { "timezone_for_instance_${name}":
      key   => 'timezone',
      value => $timezone,
    }
  }
  if $logdir {
    postgresql::server::config_entry { "log_directory_for_instance_${name}":
      key   => 'log_directory',
      value => $logdir,
    }
  }
  # Allow timestamps in log by default
  if $log_line_prefix {
    postgresql::server::config_entry { "log_line_prefix_for_instance_${name}":
      key   => 'log_line_prefix',
      value => $log_line_prefix,
    }
  }

  if ($manage_pg_ident_conf == true) {
    concat { $pg_ident_conf_path:
      owner  => $user,
      group  => $group,
      mode   => '0640',
      warn   => true,
      notify => Class['postgresql::server::reload'],
    }
  }
  # lint:ignore:140chars
  # RHEL 7 and 8 both support drop-in files for systemd units. Gentoo also supports drop-in files.
  # Edit 02/2023 RHEL basedc Systems and Gentoo need Variables set for $PGPORT, $DATA_DIR or $PGDATA, thats what the drop-in file is for.
  # lint:endignore:140chars
  if $facts['os']['family'] in ['RedHat', 'Gentoo'] and $facts['service_provider'] == 'systemd' {
    postgresql::server::instance::systemd { $service_name:
      port                 => $port,
      datadir              => $datadir,
      extra_systemd_config => $extra_systemd_config,
    }
  }
}
