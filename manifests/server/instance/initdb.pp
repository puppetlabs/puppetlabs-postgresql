# @summary Manages initdb feature for a postgresql::server instance
#
# @param auth_host auth method used by default for host authorization
# @param auth_local  auth method used by default for local authorization
# @param data_checksums Boolean. Use checksums on data pages to help detect corruption by the I/O system that would otherwise be silent.
# @param datadir PostgreSQL data directory
# @param encoding
#   Sets the default encoding for all databases created with this module.
#   On certain operating systems this is also used during the template1 initialization,
#   so it becomes a default outside of the module as well.
# @param group Overrides the default postgres user group to be used for related files in the file system.
# @param initdb_path Specifies the path to the initdb command.
# @param lc_messages locale used for logging and system messages
# @param locale Sets the default database locale for all databases created with this module.
#   On certain operating systems this is used during the template1 initialization as well, so it becomes a default outside of the module.
#   Warning: This option is used during initialization by initdb, and cannot be changed later.
#   If set, checksums are calculated for all objects, in all databases.
# @param logdir PostgreSQL log directory
# @param manage_datadir Set to false if you have file{ $datadir: } already defined
# @param manage_logdir Set to false if you have file{ $logdir: } already defined
# @param manage_xlogdir Set to false if you have file{ $xlogdir: } already defined
# @param module_workdir Working directory for the PostgreSQL module
# @param needs_initdb Explicitly calls the initdb operation after server package is installed
#   and before the PostgreSQL service is started.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param username username of user running the postgres instance
# @param xlogdir PostgreSQL xlog/WAL directory
# @param port
#   Specifies the port for the PostgreSQL server to listen on.
#   Note: The same port number is used for all IP addresses the server listens on. Also, for Red Hat systems and early Debian systems,
#   changing the port causes the server to come to a full stop before being able to make the change.
# @param psql_path Specifies the path to the psql command.
define postgresql::server::instance::initdb (
  Optional[String[1]]            $auth_host      = $postgresql::server::auth_host,
  Optional[String[1]]            $auth_local     = $postgresql::server::auth_local,
  Optional[Boolean]              $data_checksums = $postgresql::server::data_checksums,
  Stdlib::Absolutepath           $datadir        = $postgresql::server::datadir,
  Optional[String[1]]            $encoding       = $postgresql::server::encoding,
  String[1]                      $group          = $postgresql::server::group,
  Stdlib::Absolutepath           $initdb_path    = $postgresql::server::initdb_path,
  Optional[String[1]]            $lc_messages    = $postgresql::server::lc_messages,
  Optional[String[1]]            $locale         = $postgresql::server::locale,
  Optional[Stdlib::Absolutepath] $logdir         = $postgresql::server::logdir,
  Boolean                        $manage_datadir = $postgresql::server::manage_datadir,
  Boolean                        $manage_logdir  = $postgresql::server::manage_logdir,
  Boolean                        $manage_xlogdir = $postgresql::server::manage_xlogdir,
  Stdlib::Absolutepath           $module_workdir = $postgresql::server::module_workdir,
  Boolean                        $needs_initdb   = $postgresql::server::needs_initdb,
  String[1]                      $user           = $postgresql::server::user,
  Optional[String[1]]            $username       = $postgresql::server::username,
  Optional[Stdlib::Absolutepath] $xlogdir        = $postgresql::server::xlogdir,
  Stdlib::Port                   $port           = $postgresql::server::port,
  Stdlib::Absolutepath           $psql_path      = $postgresql::server::psql_path,
) {
  if $facts['os']['family'] == 'RedHat' and $facts['os']['selinux']['enabled'] == true {
    $seltype = 'postgresql_db_t'
    $logdir_type = 'postgresql_log_t'
  } else {
    $seltype = undef
    $logdir_type = undef
  }

  if $manage_datadir {
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

  if $xlogdir {
    # The xlogdir need to be present before initdb runs.
    # If xlogdir is default it's created by package installer
    $require_before_initdb = [$datadir, $xlogdir]
    if$manage_xlogdir {
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
  } else {
    $require_before_initdb = [$datadir]
  }

  if $logdir {
    if $manage_logdir {
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

  if $needs_initdb {
    # Build up the initdb command.
    #
    # We optionally add the locale switch if specified. Older versions of the
    # initdb command don't accept this switch. So if the user didn't pass the
    # parameter, lets not pass the switch at all.

    $auth_host_parameter = $auth_host ? {
      undef   => undef,
      default => "--auth-host '${auth_host}'"
    }

    $auth_local_parameter = $auth_local ? {
      undef   => undef,
      default => "--auth-local '${auth_local}'"
    }

    $data_checksums_parameter = $data_checksums ? {
      undef   => undef,
      false   => undef,
      default => '--data-checksums'
    }

    $datadir_parameter = "--pgdata '${datadir}'"

    # PostgreSQL 11 no longer allows empty encoding
    $encoding_parameter = $encoding ? {
      undef   => undef,
      default => "--encoding '${encoding}'"
    }

    $lc_messages_parameter = $locale ? {
      undef   => undef,
      default => "--lc-messages '${lc_messages}'"
    }

    $locale_parameter = $locale ? {
      undef   => undef,
      default => "--locale '${locale}'"
    }

    $username_parameter = $username ? {
      undef   => undef,
      default => "--username '${username}'"
    }

    $xlogdir_parameter = $xlogdir ? {
      undef   => undef,
      default => "-X '${xlogdir}'"
    }

    $initdb_command = squeeze("${initdb_path} ${auth_host_parameter} ${auth_local_parameter} ${data_checksums_parameter} ${datadir_parameter} ${encoding_parameter} ${lc_messages_parameter} ${locale_parameter} ${username_parameter} ${xlogdir_parameter}", ' ') # lint:ignore:140chars

    # This runs the initdb command, we use the existance of the PG_VERSION
    # file to ensure we don't keep running this command.
    exec { "postgresql_initdb_instance_${name}":
      command   => $initdb_command,
      creates   => "${datadir}/PG_VERSION",
      user      => $user,
      group     => $group,
      logoutput => on_failure,
      require   => File[$require_before_initdb],
      cwd       => $module_workdir,
    }
  } elsif $encoding {
    postgresql::server::instance::late_initdb { $name:
      encoding       => $encoding,
      user           => $user,
      group          => $group,
      module_workdir => $module_workdir,
      psql_path      => $psql_path,
      port           => $port,
    }
  }
}
