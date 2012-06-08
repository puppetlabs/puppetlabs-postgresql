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
class postgresql::params {

  case $::operatingsystem {
    "Ubuntu": {
      $service_provider = upstart
    }
    default: {
      $service_provider = undef
    }
  }

  case $::osfamily {
    'RedHat': {
      $service_name          = 'postgresql'
      $client_package_name   = 'postgresql'
      $server_package_name   = 'postgresql-server'
      $needs_initdb          = true
      $initdb_path           = '/usr/bin/initdb'
      $datadir               = '/var/lib/pgsql/data/'
    }

    'Debian': {
      $service_name         = "postgresql-${::postgres_default_version}"
      $client_package_name  = 'postgresql-client'
      $server_package_name  = 'postgresql'
      $needs_initdb         = false
      $initdb_path          = "/usr/lib/postgresql/${::postgres_default_version}/bin/initdb"
      $datadir              = "/var/lib/postgresql/${::postgres_default_version}/main"
    }


    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
    }
  }

}
