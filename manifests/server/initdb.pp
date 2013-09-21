# PRIVATE CLASS: do not call directly
class postgresql::server::initdb {
  $ensure       = $postgresql::server::ensure
  $needs_initdb = $postgresql::server::needs_initdb
  $initdb_path  = $postgresql::server::initdb_path
  $datadir      = $postgresql::server::datadir
  $encoding     = $postgresql::server::encoding
  $locale       = $postgresql::server::locale
  $group        = $postgresql::server::group
  $user         = $postgresql::server::user

  if($ensure == 'present' or $ensure == true) {
    # Make sure the data directory exists, and has the correct permissions.
    file { $datadir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0700',
    }

    if($needs_initdb) {
      # Build up the initdb command.
      #
      # We optionally add the locale switch if specified. Older versions of the
      # initdb command don't accept this switch. So if the user didn't pass the
      # parameter, lets not pass the switch at all.
      $ic_base = "${initdb_path} --encoding '${encoding}' --pgdata '${datadir}'"
      $initdb_command = $locale ? {
        undef   => $ic_base,
        default => "${ic_base} --locale '${locale}'"
      }

      # This runs the initdb command, we use the existance of the PG_VERSION
      # file to ensure we don't keep running this command.
      exec { 'postgresql_initdb':
        command   => $initdb_command,
        creates   => "${datadir}/PG_VERSION",
        user      => $user,
        group     => $group,
        logoutput => on_failure,
        before    => File[$datadir],
      }
    }
  } else {
    # Purge data directory if ensure => absent
    file { $datadir:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }
}
