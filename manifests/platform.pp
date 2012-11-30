# Class: postgresql::platform
#
#   An abstraction for the postgresql platform.  Based on the desired version of
#   postgres, whether it is part of the OS distro, OS distro differences / defaults,
#   etc., figures out the package names, service names, paths, etc.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::platform {
  include postgresql
  
  $version = $postgresql::version

  case $::operatingsystem {
    default: {
      $service_provider = undef
    }
  }

  case $::osfamily {
    'RedHat': {
      if $version == $::postgres_default_version {
        $client_package_name = 'postgresql'
        $server_package_name = 'postgresql-server'
        $devel_package_name  = 'postgresql-devel'
        $service_name = 'postgresql'
        $bindir       = '/usr/bin'
        $datadir      = '/var/lib/pgsql/data'
        $confdir      = $datadir
      } else {
        $version_parts       = split($version, '[.]')
        $package_version     = "${version_parts[0]}${version_parts[1]}"
        $client_package_name = "postgresql${package_version}"
        $server_package_name = "postgresql${package_version}-server"
        $devel_package_name  = "postgresql${package_version}-devel"
        $service_name = "postgresql-${version}"
        $bindir       = "/usr/pgsql-${version}/bin"
        $datadir      = "/var/lib/pgsql/${version}/data"
        $confdir      = $datadir
      }
    }

    'Debian': {

      case $::operatingsystem {
        'Debian': {
            $service_name = 'postgresql'
        }

        'Ubuntu': {
            case $::lsbmajdistrelease {
                # thanks, ubuntu
                '10':       { $service_name = "postgresql-${::postgres_default_version}" }
                default:    { $service_name = 'postgresql' }
            }
        }
      }

      $client_package_name = 'postgresql-client'
      $server_package_name = 'postgresql'
      $devel_package_name  = 'libpq-dev'
      $bindir              = "/usr/lib/postgresql/${::postgres_default_version}/bin"
      $datadir             = "/var/lib/postgresql/${::postgres_default_version}/main"
      $confdir             = "/etc/postgresql/${::postgres_default_version}/main"
      $service_status      = "/etc/init.d/${service_name} status | /bin/egrep -q 'Running clusters: .+'"
      # TODO: not exactly sure yet what the right thing to do for Debian/Ubuntu is.
      #$persist_firewall_command = '/sbin/iptables-save > /etc/iptables/rules.v4'

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
    }
    
  }

  $initdb_path          = "${bindir}/initdb"
  $createdb_path        = "${bindir}/createdb"
  $psql_path            = "${bindir}/psql"
  $pg_hba_conf_path     = "${confdir}/pg_hba.conf"
  $postgresql_conf_path = "${confdir}/postgresql.conf"

}
