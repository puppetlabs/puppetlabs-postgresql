# @summary Define for creating a database role.
#
# @param update_password If set to true, updates the password on changes. Set this to false to not modify the role's password after creation.
# @param password_hash Sets the hash to use during password creation.
# @param createdb Specifies whether to grant the ability to create new databases with this role.
# @param createrole Specifies whether to grant the ability to create new roles with this role.
# @param db Database used to connect to.
# @param port Port to use when connecting.
# @param login Specifies whether to grant login capability for the new role.
# @param inherit Specifies whether to grant inherit capability for the new role.
# @param superuser Specifies whether to grant super user capability for the new role.
# @param replication Provides provides replication capabilities for this role if set to true.
# @param connection_limit Specifies how many concurrent connections the role can make. Default value: '-1', meaning no limit.
# @param username Defines the username of the role to create.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param ensure Specify whether to create or drop the role. Specifying 'present' creates the role. Specifying 'absent' drops the role.
# @param psql_user Sets the OS user to run psql
# @param psql_group Sets the OS group to run psql
# @param psql_path Sets path to psql command
# @param module_workdir Specifies working directory under which the psql command should be executed. May need to specify if '/tmp' is on volume mounted with noexec option.
define postgresql::server::role (
  $update_password = true,
  $password_hash    = false,
  $createdb         = false,
  $createrole       = false,
  $db               = $postgresql::server::default_database,
  $port             = undef,
  $login            = true,
  $inherit          = true,
  $superuser        = false,
  $replication      = false,
  $connection_limit = '-1',
  $username         = $title,
  $connect_settings = $postgresql::server::default_connect_settings,
  $psql_user        = $postgresql::server::user,
  $psql_group       = $postgresql::server::group,
  $psql_path        = $postgresql::server::psql_path,
  $module_workdir   = $postgresql::server::module_workdir,
  Enum['present', 'absent'] $ensure = 'present',
) {
  #
  # Port, order of precedence: $port parameter, $connect_settings[PGPORT], $postgresql::server::port
  #
  if $port != undef {
    $port_override = $port
  } elsif $connect_settings != undef and has_key( $connect_settings, 'PGPORT') {
    $port_override = undef
  } else {
    $port_override = $postgresql::server::port
  }

  # If possible use the version of the remote database, otherwise
  # fallback to our local DB version
  if $connect_settings != undef and has_key( $connect_settings, 'DBVERSION') {
    $version = $connect_settings['DBVERSION']
  } else {
    $version = $postgresql::server::_version
  }

  Postgresql_psql {
    db         => $db,
    port       => $port_override,
    psql_user  => $psql_user,
    psql_group => $psql_group,
    psql_path  => $psql_path,
    connect_settings => $connect_settings,
    cwd        => $module_workdir,
    require    => Postgresql_psql["CREATE ROLE ${username} ENCRYPTED PASSWORD ****"],
  }

  if $ensure == 'present' {
    $login_sql       = $login       ? { true => 'LOGIN',       default => 'NOLOGIN' }
    $inherit_sql     = $inherit     ? { true => 'INHERIT',     default => 'NOINHERIT' }
    $createrole_sql  = $createrole  ? { true => 'CREATEROLE',  default => 'NOCREATEROLE' }
    $createdb_sql    = $createdb    ? { true => 'CREATEDB',    default => 'NOCREATEDB' }
    $superuser_sql   = $superuser   ? { true => 'SUPERUSER',   default => 'NOSUPERUSER' }
    $replication_sql = $replication ? { true => 'REPLICATION', default => '' }
    if ($password_hash != false) {
      $password_sql = "ENCRYPTED PASSWORD '${password_hash}'"
    } else {
      $password_sql = ''
    }

    postgresql_psql { "CREATE ROLE ${username} ENCRYPTED PASSWORD ****":
      command     => Sensitive("CREATE ROLE \"${username}\" ${password_sql} ${login_sql} ${createrole_sql} ${createdb_sql} ${superuser_sql} ${replication_sql} CONNECTION LIMIT ${connection_limit}"),
      unless      => "SELECT 1 FROM pg_roles WHERE rolname = '${username}'",
      require     => undef,
      sensitive   => true,
    }

    postgresql_psql { "ALTER ROLE \"${username}\" ${superuser_sql}":
      unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolsuper = ${superuser}",
    }

    postgresql_psql { "ALTER ROLE \"${username}\" ${createdb_sql}":
      unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolcreatedb = ${createdb}",
    }

    postgresql_psql { "ALTER ROLE \"${username}\" ${createrole_sql}":
      unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolcreaterole = ${createrole}",
    }

    postgresql_psql { "ALTER ROLE \"${username}\" ${login_sql}":
      unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolcanlogin = ${login}",
    }

    postgresql_psql { "ALTER ROLE \"${username}\" ${inherit_sql}":
      unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolinherit = ${inherit}",
    }

    if(versioncmp($version, '9.1') >= 0) {
      if $replication_sql == '' {
        postgresql_psql { "ALTER ROLE \"${username}\" NOREPLICATION":
          unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolreplication = ${replication}",
        }
      } else {
        postgresql_psql { "ALTER ROLE \"${username}\" ${replication_sql}":
          unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolreplication = ${replication}",
        }
      }
    }

    postgresql_psql { "ALTER ROLE \"${username}\" CONNECTION LIMIT ${connection_limit}":
      unless => "SELECT 1 FROM pg_roles WHERE rolname = '${username}' AND rolconnlimit = ${connection_limit}",
    }

    if $password_hash and $update_password {
      if($password_hash =~ /^md5.+/) {
        $pwd_hash_sql = $password_hash
      } else {
        $pwd_md5 = md5("${password_hash}${username}")
        $pwd_hash_sql = "md5${pwd_md5}"
      }
      postgresql_psql { "ALTER ROLE ${username} ENCRYPTED PASSWORD ****":
        command     => Sensitive("ALTER ROLE \"${username}\" ${password_sql}"),
        unless      => Sensitive("SELECT 1 FROM pg_shadow WHERE usename = '${username}' AND passwd = '${pwd_hash_sql}'"),
        sensitive   => true,
      }
    }
  } else {
    # ensure == absent
    postgresql_psql { "DROP ROLE \"${username}\"":
      onlyif  => "SELECT 1 FROM pg_roles WHERE rolname = '${username}'",
      require => undef,
    }
  }
}
