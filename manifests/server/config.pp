# @api private
class postgresql::server::config {
  $ip_mask_deny_postgres_user   = $postgresql::server::ip_mask_deny_postgres_user
  $ip_mask_allow_all_users      = $postgresql::server::ip_mask_allow_all_users
  $listen_addresses             = $postgresql::server::listen_addresses
  $port                         = $postgresql::server::port
  $ipv4acls                     = $postgresql::server::ipv4acls
  $ipv6acls                     = $postgresql::server::ipv6acls
  $pg_hba_conf_path             = $postgresql::server::pg_hba_conf_path
  $pg_ident_conf_path           = $postgresql::server::pg_ident_conf_path
  $postgresql_conf_path         = $postgresql::server::postgresql_conf_path
  $postgresql_conf_mode         = $postgresql::server::postgresql_conf_mode
  $recovery_conf_path           = $postgresql::server::recovery_conf_path
  $pg_hba_conf_defaults         = $postgresql::server::pg_hba_conf_defaults
  $user                         = $postgresql::server::user
  $group                        = $postgresql::server::group
  $version                      = $postgresql::server::_version
  $manage_pg_hba_conf           = $postgresql::server::manage_pg_hba_conf
  $manage_pg_ident_conf         = $postgresql::server::manage_pg_ident_conf
  $manage_recovery_conf         = $postgresql::server::manage_recovery_conf
  $manage_postgresql_conf_perms = $postgresql::server::manage_postgresql_conf_perms
  $datadir                      = $postgresql::server::datadir
  $logdir                       = $postgresql::server::logdir
  $service_name                 = $postgresql::server::service_name
  $service_enable               = $postgresql::server::service_enable
  $log_line_prefix              = $postgresql::server::log_line_prefix
  $timezone                     = $postgresql::server::timezone
  $password_encryption          = $postgresql::server::password_encryption
  $extra_systemd_config         = $postgresql::server::extra_systemd_config

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
        'local access as postgres user':
          type        => 'local',
          user        => $user,
          auth_method => 'ident',
          auth_option => $local_auth_option,
          order       => 1;

        'local access to database with same name':
          type        => 'local',
          auth_method => 'ident',
          auth_option => $local_auth_option,
          order       => 2;

        'allow localhost TCP access to postgresql user':
          type        => 'host',
          user        => $user,
          address     => '127.0.0.1/32',
          auth_method => 'md5',
          order       => 3;

        'deny access to postgresql user':
          type        => 'host',
          user        => $user,
          address     => $ip_mask_deny_postgres_user,
          auth_method => 'reject',
          order       => 4;

        'allow access to all users':
          type        => 'host',
          address     => $ip_mask_allow_all_users,
          auth_method => 'md5',
          order       => 100;

        'allow access to ipv6 localhost':
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
    postgresql::server::config_entry { 'listen_addresses':
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

    exec { "/usr/sbin/semanage port -a -t postgresql_port_t -p tcp ${port}":
      unless  => "/usr/sbin/semanage port -l | grep -qw ${port}",
      before  => Postgresql::Server::Config_entry['port'],
      require => Package[$package_name],
    }
  }

  postgresql::server::config_entry { 'port':
    value => $port,
  }

  if ($password_encryption) and (versioncmp($version, '10') >= 0) {
    postgresql::server::config_entry { 'password_encryption':
      value => $password_encryption,
    }
  }

  postgresql::server::config_entry { 'data_directory':
    value => $datadir,
  }
  if $timezone {
    postgresql::server::config_entry { 'timezone':
      value => $timezone,
    }
  }
  if $logdir {
    postgresql::server::config_entry { 'log_directory':
      value => $logdir,
    }
  }
  # Allow timestamps in log by default
  if $log_line_prefix {
    postgresql::server::config_entry { 'log_line_prefix':
      value => $log_line_prefix,
    }
  }

  # RedHat-based systems hardcode some PG* variables in the init script, and need to be overriden
  # in /etc/sysconfig/pgsql/postgresql. Create a blank file so we can manage it with augeas later.
  if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '7') < 0 {
    file { '/etc/sysconfig/pgsql/postgresql':
      ensure  => file,
      replace => false,
    }

    # The init script from the packages of the postgresql.org repository
    # sources an alternate sysconfig file.
    # I. e. /etc/sysconfig/pgsql/postgresql-9.3 for PostgreSQL 9.3
    # Link to the sysconfig file set by this puppet module
    file { "/etc/sysconfig/pgsql/postgresql-${version}":
      ensure  => link,
      target  => '/etc/sysconfig/pgsql/postgresql',
      require => File['/etc/sysconfig/pgsql/postgresql'],
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

  # RHEL 7 and 8 both support drop-in files for systemd units.  The old include directive is deprecated and may be removed in future systemd releases.
  # Gentoo also supports drop-in files.
  if $facts['os']['family'] in ['RedHat', 'Gentoo'] and $facts['service_provider'] == 'systemd' {
    # While Puppet 6.1 and newer can do a daemon-reload if needed, systemd
    # doesn't appear to report that correctly in all cases.
    # One such case seems to be when an overriding unit file is removed from /etc
    # and the original one from /lib *should* be used again.
    #
    # This can be removed when Puppet < 6.1 support is dropped *and* the file
    # old-systemd-override is removed.
    exec { 'restart-systemd':
      command     => 'systemctl daemon-reload',
      refreshonly => true,
      path        => '/bin:/usr/bin:/usr/local/bin',
      before      => Class['postgresql::server::service'],
    }

    file {
      default:
        ensure => file,
        owner  => root,
        group  => root,
        notify => [Exec['restart-systemd'], Class['postgresql::server::service']],
        before => Class['postgresql::server::reload'];

      'systemd-conf-dir':
        ensure => directory,
        path   => "/etc/systemd/system/${service_name}.service.d";

      # Template uses:
      # - $facts['os']['name']
      # - $facts['os']['release']['major']
      # - $service_name
      # - $port
      # - $datadir
      # - $extra_systemd_config
      'systemd-override':
        path    => "/etc/systemd/system/${service_name}.service.d/${service_name}.conf",
        content => template('postgresql/systemd-override.erb'),
        require => File['systemd-conf-dir'];
    }

    if $service_enable != 'mask' {
      # Remove old unit file to avoid conflicts
      file { 'old-systemd-override':
        ensure => absent,
        path   => "/etc/systemd/system/${service_name}.service",
        notify => [Exec['restart-systemd'], Class['postgresql::server::service']],
        before => Class['postgresql::server::reload'],
      }
    }
  }
}
