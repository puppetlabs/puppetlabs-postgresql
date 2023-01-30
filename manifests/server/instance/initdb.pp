# lint:ignore:140chars
# @param needs_initdb Explicitly calls the initdb operation after server package is installed
#   and before the PostgreSQL service is started.
# @param initdb_path Specifies the path to the initdb command.
# @param datadir PostgreSQL data directory
# @param xlogdir PostgreSQL xlog directory
# @param logdir PostgreSQL log directory
# @param manage_datadir Set to false if you have file{ $datadir: } already defined
# @param manage_logdir Set to false if you have file{ $logdir: } already defined
# @param manage_xlogdir Set to false if you have file{ $xlogdir: } already defined
# @param encoding Sets the default encoding for all databases created with this module.
#   On certain operating systems this is also used during the template1 initialization, so it becomes a default outside of the module as well.
# @param locale Sets the default database locale for all databases created with this module.
#   On certain operating systems this is used during the template1 initialization as well, so it becomes a default outside of the module.
# @param data_checksums Boolean. Use checksums on data pages to help detect corruption by the I/O system that would otherwise be silent.
#   Warning: This option is used during initialization by initdb, and cannot be changed later. If set, checksums are calculated for all objects, in all databases.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
# @param module_workdir Working directory for the PostgreSQL module
# lint:endignore:140chars
define postgresql::server::instance::initdb (
  Boolean $needs_initdb             = $postgresql::server::needs_initdb,
  $initdb_path                      = $postgresql::server::initdb_path,
  $datadir                          = $postgresql::server::datadir,
  $xlogdir                          = $postgresql::server::xlogdir,
  $logdir                           = $postgresql::server::logdir,
  Boolean $manage_datadir           = $postgresql::server::manage_datadir,
  Boolean $manage_logdir            = $postgresql::server::manage_logdir,
  Boolean $manage_xlogdir           = $postgresql::server::manage_xlogdir,
  $encoding                         = $postgresql::server::encoding,
  $locale                           = $postgresql::server::locale,
  Optional[Boolean] $data_checksums = $postgresql::server::data_checksums,
  $group                            = $postgresql::server::group,
  $user                             = $postgresql::server::user,
  $module_workdir                   = $postgresql::server::module_workdir,
) {
  if $facts['os']['family'] == 'RedHat' and $facts['os']['selinux']['enabled'] == true {
    $seltype = 'postgresql_db_t'
    $logdir_type = 'postgresql_log_t'
  }

  else {
    $seltype = undef
    $logdir_type = undef
  }

  if($manage_datadir) {
    # Make sure the data directory exists, and has the correct permissions.
    file { $datadir:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      seltype => $seltype,
    }
  } else {
    # changes an already defined datadir
    File <| title == $datadir |> {
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      seltype => $seltype,
    }
  }

  if($xlogdir) {
    if($manage_xlogdir) {
      # Make sure the xlog directory exists, and has the correct permissions.
      file { $xlogdir:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '0700',
        seltype => $seltype,
      }
    } else {
      # changes an already defined xlogdir
      File <| title == $xlogdir |> {
        ensure  => directory,
        owner   => $user,
        group   => $group,
        mode    => '0700',
        seltype => $seltype,
      }
    }
  }

  if($logdir) {
    if($manage_logdir) {
      # Make sure the log directory exists, and has the correct permissions.
      file { $logdir:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        seltype => $logdir_type,
      }
    } else {
      # changes an already defined logdir
      File <| title == $logdir |> {
        ensure  => directory,
        owner   => $user,
        group   => $group,
        seltype => $logdir_type,
      }
    }
  }

  if($needs_initdb) {
    # Build up the initdb command.
    #
    # We optionally add the locale switch if specified. Older versions of the
    # initdb command don't accept this switch. So if the user didn't pass the
    # parameter, lets not pass the switch at all.
    $ic_base = "${initdb_path} --pgdata '${datadir}'"
    $ic_xlog = $xlogdir ? {
      undef   => $ic_base,
      default => "${ic_base} -X '${xlogdir}'"
    }

    # The xlogdir need to be present before initdb runs.
    # If xlogdir is default it's created by package installer
    if($xlogdir) {
      $require_before_initdb = [$datadir, $xlogdir]
    } else {
      $require_before_initdb = [$datadir]
    }

    # PostgreSQL 11 no longer allows empty encoding
    $ic_encoding = $encoding ? {
      undef   => $ic_xlog,
      default => "${ic_xlog} --encoding '${encoding}'"
    }

    $ic_locale = $locale ? {
      undef   => $ic_encoding,
      default => "${ic_encoding} --locale '${locale}'"
    }

    $initdb_command = $data_checksums ? {
      undef   => $ic_locale,
      false   => $ic_locale,
      default => "${ic_locale} --data-checksums"
    }

    # This runs the initdb command, we use the existance of the PG_VERSION
    # file to ensure we don't keep running this command.
    exec { 'postgresql_initdb':
      command   => $initdb_command,
      creates   => "${datadir}/PG_VERSION",
      user      => $user,
      group     => $group,
      logoutput => on_failure,
      require   => File[$require_before_initdb],
      cwd       => $module_workdir,
    }
  } elsif $encoding != undef {
    include postgresql::server::late_initdb
  }
}
