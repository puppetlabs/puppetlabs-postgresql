# Class: postgresql::packages
#
#   The postgresql packages. Figures out the package names based on
#   the version parameter passed to the postgresql class.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::packages {
  include postgresql
  
  $version = $postgresql::version
  
  case $::osfamily {
    'RedHat': {
      if $version == $::postgres_default_version {
        $client_package_name = 'postgresql'
        $server_package_name = 'postgresql-server'
        $devel_package_name  = 'postgresql-devel'
      } else {
        $version_parts       = split($version, '[.]')
        $package_version     = "${version_parts[0]}${version_parts[1]}"
        $client_package_name = "postgresql${package_version}"
        $server_package_name = "postgresql${package_version}-server"
        $devel_package_name  = "postgresql${package_version}-devel"
      }
    }

    'Debian': {

      $client_package_name = 'postgresql-client'
      $server_package_name = 'postgresql'
      $devel_package_name  = 'libpq-dev'

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
    }
    
  }


}
