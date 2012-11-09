# ==Class: postgresql::repo
#
#   A class to add repositories (yum, apt, etc) needed to
#   install non-default versions of Postgressql.
#
# === Variables
# [*postgresql::version::version*] contains the version number.
#
# === Authors
#
# Etienne Pelletier <epelletier@maestrodev.com>
#
class postgresql::repo {
  include postgresql::version

  case $::osfamily {
    'RedHat': {
      case $postgresql::version::version {
        '9.0': {
          yumrepo { 'postgresql90':
            baseurl  => 'http://yum.postgresql.org/9.0/redhat/rhel-$releasever-$basearch',
            descr    => 'Postgresql 9.0 Yum Repo',
            enabled  => 1,
            gpgcheck => 0,
          }
        }
        default: {

        }
      } # case
    }
    default: {

    }

  }

}