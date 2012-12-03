# TODO: add real docs

# This class allows you to use a newer version of postgres, rather than your
# system's default version.
#
# Note that it is important that you use the '->', or a
# before/require metaparameter to make sure that the `package_source_info`
# class is evaluated before any of the other classes in the module.
#
# Also note that this class includes the ability to automatically manage
# the yumrepo resource.  If you'd prefer to manage the repo yourself, simply pass
# 'false' or omit the 'manage_repo' parameter--it defaults to 'false'.  You will
# still need to use the 'package_source_info' class to specify the postgres version
# number, though, in order for the other classes to be able to find the
# correct paths to the postgres dirs.

class postgresql::package_source_info(
    $version,
    $manage_repo = false,
    $source = ''
) {

  if ($manage_repo) {
    case $::osfamily {
      'RedHat': {
         if ! $source {
           $pkg_source = 'yum.postgresql.org'
         } else {
           $pkg_source = $source
         }

         case $pkg_source {
           'yum.postgresql.org': {
              class { "postgresql::package_source::yum_postgresql_org":
                version => $version
              }
           }

           default: {
             fail("Unsupported package source '${pkg_source}' for ${::osfamily} OS family. Currently the only supported source is 'yum.postgresql.org'")
           }
         }

      }

      default: {
        fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
      }
    }
  }
}