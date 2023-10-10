# @summary Define for creating a database role.
#
# @param update_password
#   If set to true, updates the password on changes. Set this to false to not modify the role's password after creation.
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
# @param module_workdir
#   Specifies working directory under which the psql command should be executed.
#   May need to specify if '/tmp' is on volume mounted with noexec option.
# @param hash Specify the hash method for pg password
# @param salt Specify the salt use for the scram-sha-256 encoding password (default username)
# @param instance The name of the Postgresql database instance.
define postgresql::server::role (
  Boolean                                     $update_password  = true,
  Variant[Boolean, String, Sensitive[String]] $password_hash    = false,
  Boolean                                     $createdb         = false,
  Boolean                                     $createrole       = false,
  String[1]                                   $db               = $postgresql::server::default_database,
  Stdlib::Port $port = postgresql::default('port'),
  Boolean                                     $login            = true,
  Boolean                                     $inherit          = true,
  Boolean                                     $superuser        = false,
  Boolean                                     $replication      = false,
  String[1]                                   $connection_limit = '-1',
  String[1]                                   $username         = $title,
  Hash                                        $connect_settings = $postgresql::server::default_connect_settings,
  String[1]                                   $psql_user        = $postgresql::server::user,
  String[1]                                   $psql_group       = $postgresql::server::group,
  Stdlib::Absolutepath                        $psql_path        = $postgresql::server::psql_path,
  String[1]                                   $module_workdir   = $postgresql::server::module_workdir,
  Enum['present', 'absent']                   $ensure           = 'present',
  Optional[Enum['md5', 'scram-sha-256']]      $hash             = undef,
  Optional[Variant[String[1], Integer]]       $salt             = undef,
  String[1]                                   $instance         = 'main',
) {
  $password_hash_unsensitive = if $password_hash =~ Sensitive[String] {
    $password_hash.unwrap
  } else {
    $password_hash
  }
  $port_override = pick($connect_settings['PGPORT'], $port)
  $version = pick($connect_settings['DBVERSION'], postgresql::default('version'))

  Postgresql_psql {
    db               => $db,
    port             => $port_override,
    psql_user        => $psql_user,
    psql_group       => $psql_group,
    psql_path        => $psql_path,
    connect_settings => $connect_settings,
    instance         => $instance,
    cwd              => $module_workdir,
    require          => Postgresql_psql["CREATE ROLE ${username} ENCRYPTED PASSWORD ****"],
  }

  if $ensure == 'present' {
    $login_sql       = $login       ? { true => 'LOGIN',       default => 'NOLOGIN' }
    $inherit_sql     = $inherit     ? { true => 'INHERIT',     default => 'NOINHERIT' }
    $createrole_sql  = $createrole  ? { true => 'CREATEROLE',  default => 'NOCREATEROLE' }
    $createdb_sql    = $createdb    ? { true => 'CREATEDB',    default => 'NOCREATEDB' }
    $superuser_sql   = $superuser   ? { true => 'SUPERUSER',   default => 'NOSUPERUSER' }
    $replication_sql = $replication ? { true => 'REPLICATION', default => '' }

    if $password_hash_unsensitive =~ Deferred {
      $password_sql = Deferred('postgresql::prepend_sql_password', [$password_hash_unsensitive])
    } elsif ($password_hash_unsensitive != false) {
      $password_sql = postgresql::prepend_sql_password($password_hash_unsensitive)
    } else {
      $password_sql = ''
    }

    if $password_sql =~ Deferred {
      $create_role_command = Deferred('sprintf', ["CREATE ROLE \"%s\" %s %s %s %s %s %s CONNECTION LIMIT %s",
          $username,
          $password_sql,
          $login_sql,
          $createrole_sql,
          $createdb_sql,
          $superuser_sql,
          $replication_sql,
          $connection_limit,
        ]
      )
    } else {
      $create_role_command = "CREATE ROLE \"${username}\" ${password_sql} ${login_sql} ${createrole_sql} ${createdb_sql} ${superuser_sql} ${replication_sql} CONNECTION LIMIT ${connection_limit}" # lint:ignore:140chars
    }

    postgresql_psql { "CREATE ROLE ${username} ENCRYPTED PASSWORD ****":
      command   => Sensitive($create_role_command),
      unless    => "SELECT 1 FROM pg_roles WHERE rolname = '${username}'",
      require   => undef,
      sensitive => true,
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

    $_hash = if $hash {
      $hash
    } elsif $connect_settings != undef and 'DBVERSION' in $connect_settings {
      versioncmp($version, '14') ? { -1 => 'md5', default => 'scram-sha-256' }
    } else {
      $postgresql::server::password_encryption
    }
    if $password_hash_unsensitive and $update_password {
      if $password_hash_unsensitive =~ Deferred {
        $pwd_hash_sql = Deferred ( 'postgresql::postgresql_password', [
            $username,
            $password_hash_unsensitive,
            false,
            $_hash,
            $salt,
          ]
        )
      } else {
        $pwd_hash_sql = postgresql::postgresql_password(
          $username,
          $password_hash_unsensitive,
          false,
          $_hash,
          $salt,
        )
      }
      if $pwd_hash_sql =~ Deferred {
        $pw_command = Deferred('sprintf', ["ALTER ROLE \"%s\" ENCRYPTED PASSWORD '%s'", $username, $pwd_hash_sql])
        $unless_pw_command = Deferred('sprintf', ["SELECT 1 FROM pg_shadow WHERE usename = '%s' AND passwd = '%s'",
            $username,
            $pwd_hash_sql,
          ]
        )
      } else {
        $pw_command = "ALTER ROLE \"${username}\" ENCRYPTED PASSWORD '${pwd_hash_sql}'"
        $unless_pw_command = "SELECT 1 FROM pg_shadow WHERE usename = '${username}' AND passwd = '${pwd_hash_sql}'"
      }
      postgresql_psql { "ALTER ROLE ${username} ENCRYPTED PASSWORD ****":
        command   => Sensitive($pw_command),
        unless    => Sensitive($unless_pw_command),
        sensitive => true,
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
