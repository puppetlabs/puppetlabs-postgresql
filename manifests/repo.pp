# @api private
class postgresql::repo (
  $version = undef,
  $proxy = undef,
  $baseurl = undef,
  $commonurl = undef,
) {
  case $facts['os']['family'] {
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
      fail("Unsupported managed repository for osfamily: ${facts['os']['family']}, operatingsystem: ${facts['os']['name']}, module ${module_name} currently only supports managing repos for osfamily RedHat and Debian")
    }
  }
}
