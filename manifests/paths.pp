# Class: postgresql::params
#
#   The postgresql configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::paths {  
  include postgresql::version
  
  $version = $postgresql::version::version  
  case $::osfamily {
    'RedHat': {
      if $version == $::postgres_default_version {
        $service_name = 'postgresql'
        $bindir       = '/usr/bin'
        $datadir      = '/var/lib/pgsql/data/'
      }
      else {
        $service_name = "postgresql-${version}"
        $bindir       = "/usr/pgsql-${version}/bin"
        $datadir      = "/var/lib/pgsql/${version}/data/"
      } # case
    }

    'Debian': {
      case $::operatingsystem {
        'Debian': {
            $service_name       = 'postgresql'
        }

        'Ubuntu': {
            case $::lsbmajdistrelease {
                # thanks, ubuntu
                '10':       { $service_name = "postgresql-${::postgres_default_version}" }
                default:    { $service_name = 'postgresql' }
            }
        }
      }

      $bindir                   = "/usr/lib/postgresql/${::postgres_default_version}/bin"
      $datadir                  = "/var/lib/postgresql/${::postgres_default_version}/main"
      $service_status           = "/etc/init.d/${service_name} status | /bin/egrep -q 'Running clusters: .+'"
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
  $pg_hba_conf_path     = "${datadir}pg_hba.conf"
  $postgresql_conf_path = "${datadir}postgresql.conf"
  

}
