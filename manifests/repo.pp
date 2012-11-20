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
class postgresql::repo($version = $postgresql::version::version) {
  include postgresql::version
  
  if $version != $::postgres_default_version {

    case $::osfamily {      
      'RedHat': {
        $repo_name = "postgresql${version}"
        yumrepo { 'postgresql-repo':
          name     => $repo_name,
          baseurl  => "http://yum.postgresql.org/${version}/redhat/rhel-\$releasever-\$basearch",
          descr    => "Postgresql ${version} Yum Repo",
          enabled  => 1,
          gpgcheck => 0,
        }
      }
      default: {
        # TODO add Debian apt repos.
      }
    }
  }

}