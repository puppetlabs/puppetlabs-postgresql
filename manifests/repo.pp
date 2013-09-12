# PRIVATE CLASS: do not use directly
class postgresql::repo (
  $ensure  = 'present',
  $version = undef
) inherits postgresql::params {
  if $ensure == 'present' or $ensure == true {
    case $::osfamily {
      'RedHat', 'Linux': {
        if $version == undef {
          fail("The parameter 'version' for 'postgresql::repo' is undefined. You must always define it when osfamily == Redhat or Linux")
        }
        class { 'postgresql::repo::yum_postgresql_org': }
      }

      'Debian': {
        class { 'postgresql::repo::apt_postgresql_org': }
      }

      default: {
        fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
      }
    }
  }
}
