# Class: postgresql::server
#
# == Class: postgresql::server
# Manages the installation of the postgresql server.  manages the package and
# service.
#
# === Parameters:
# [*package_name*] - name of package
# [*service_name*] - name of service
#
# Configuration:
#   Advanced configuration setting parameters can be placed into 'postgresql_puppet_extras.conf' (located in the same
#   folder as 'postgresql.conf'). You can manage that file as a normal puppet file resource, or however you see fit;
#   which gives you complete control over the settings. Any value you specify in that file will override any existing
#   value set in the templated version.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::server (
  $ensure           = 'present',
  $package_name     = $postgresql::params::server_package_name,
  $package_ensure   = 'present',
  $service_name     = $postgresql::params::service_name,
  $service_provider = $postgresql::params::service_provider,
  $service_status   = $postgresql::params::service_status,
  $config_hash      = {},
  $datadir          = $postgresql::params::datadir
) inherits postgresql::params {

  if ($ensure == 'absent') {
    service { 'postgresqld':
      ensure    => stopped,
      name      => $service_name,
      enable    => false,
      provider  => $service_provider,
      hasstatus => true,
      status    => $service_status,
    }->
    package { 'postgresql-server':
      ensure  => purged,
      name    => $package_name,
      tag     => 'postgresql',
    }->
    file { $datadir:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  } else {
    package { 'postgresql-server':
      ensure  => $package_ensure,
      name    => $package_name,
      tag     => 'postgresql',
    }

    $config_class = {
      'postgresql::config' => $config_hash,
    }

    create_resources( 'class', $config_class )

    service { 'postgresqld':
      ensure    => running,
      name      => $service_name,
      enable    => true,
      require   => Package['postgresql-server'],
      provider  => $service_provider,
      hasstatus => true,
      status    => $service_status,
    }

    if ($postgresql::params::needs_initdb) {
      include postgresql::initdb

      case $::osfamily {
        'Debian': {

          # Disable the creation of "main" clusters when postgresql server packages are installed
          # Requires postgresql-common (=> 142) to do something.
          Apt::Source['apt.postgresql.org']->
          package { 'postgresql-common':
            ensure => latest,
          }->
          file_line { 'createcluster.conf_create_main_cluster':
            path   => '/etc/postgresql-common/createcluster.conf',
            match  => '^\s*create_main_cluster',
            line   => 'create_main_cluster = false',
          }->
          Package<| tag == 'postgresql' |>

          # Register the postgresql datadir to debian scripts
          exec { 'postgresql_debian_register':
            path        => '/usr/bin:/usr/sbin:/bin:/sbin',
            command     => "pg_createcluster ${postgresql::params::version} main --datadir '${postgresql::params::datadir}'",
            unless      => "test -f /etc/postgresql/${postgresql::params::version}/main/postgresql.conf",
            require     => Exec['postgresql_initdb'],
            before      => Class['postgresql::config'],
          }

        }

        'RedHat', 'Linux': {
          # Save the postgresql datadir location for init scripts
          file { "/etc/sysconfig/pgsql/${postgresql::params::service_name}":
            ensure  => file,
            content => inline_template('PGDATA=<%=scope.lookupvar(\'postgresql::params::datadir\')%>'),
            require => Package['postgresql-server'],
            before  => Service['postgresqld'],
          }
        }

        default: {
          fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
        }
      }

      Package['postgresql-server'] -> Class['postgresql::initdb'] -> Class['postgresql::config'] -> Service['postgresqld']
    }
    else  {
      Package['postgresql-server'] -> Class['postgresql::config'] -> Service['postgresqld']
    }

    exec { 'reload_postgresql':
      path        => '/usr/bin:/usr/sbin:/bin:/sbin',
      command     => "service ${service_name} reload",
      onlyif      => $service_status,
      refreshonly => true,
    }
  }

}
