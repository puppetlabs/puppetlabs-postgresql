# Define for creating a database role. See README.md for more information
define postgresql::server::role(
  $password_hash    = false,
  $createdb         = false,
  $createrole       = false,
  $db               = $postgresql::server::default_database,
  $ensure           = 'present',
  $port             = undef,
  $login            = true,
  $inherit          = true,
  $superuser        = false,
  $replication      = false,
  $connection_limit = '-1',
  $username         = $title,
  $dialect          = $postgresql::server::dialect,
  $connect_settings = $postgresql::server::default_connect_settings,
) {
  $psql_user      = $postgresql::server::user
  $psql_group     = $postgresql::server::group
  $psql_path      = $postgresql::server::psql_path
  $module_workdir = $postgresql::server::module_workdir

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

  # Dialect determines keyword for role definition
  if $dialect == 'postgres' {
    $role_keyword = "ROLE"
    $role_table = "pg_roles"
    $role_column_prefix = "rol"
    $role_connection_limit = $connection_limit
    $password_table = "pg_shadow"

  } elsif $dialect == 'redshift' {
    $role_keyword = "USER"
    $role_table = "pg_user_info"
    $role_column_prefix = "use"
    if ($connection_limit == '-1') {
      $role_connection_limit = "UNLIMITED"
    } else {
      $role_connection_limit = $connection_limit
    }
    $password_table = "pg_shadow"

  } else {
    fail("dialect must be set to a valid value")
  }

  if $ensure == 'absent' {
    Postgresql_psql {
      db         => $db,
      port       => $port_override,
      psql_user  => $psql_user,
      psql_group => $psql_group,
      psql_path  => $psql_path,
      connect_settings => $connect_settings,
      cwd        => $module_workdir,
      require    => [
        Postgresql_psql["${title}: DROP ${role_keyword} ${username}"],
        Class['postgresql::server'],
      ],
    }
  
    postgresql_psql { "${title}: DROP ${role_keyword} ${username}":
      command     => "DROP ${role_keyword} \"${username}\"",
      unless      => "SELECT 1 WHERE NOT EXISTS (SELECT 1 FROM ${role_table} WHERE ${role_column_prefix}name = '${username}')",
      environment => $environment,
      require     => Class['Postgresql::Server'],
    }
  } else {
    # If possible use the version of the remote database, otherwise
    # fallback to our local DB version
    if $connect_settings != undef and has_key( $connect_settings, 'DBVERSION') {
      $version = $connect_settings['DBVERSION']
    } else {
      $version = $postgresql::server::_version
    }
  
    if ($dialect == 'postgres') {
      $login_sql       = $login       ? { true => 'LOGIN',       default => 'NOLOGIN' }
    } elsif ($dialect == 'redshift') {
      if ($login != false) {
        $login_sql = $login
      } else {
        $login_sql = ''
      }
    }
    $inherit_sql     = $inherit     ? { true => 'INHERIT',     default => 'NOINHERIT' }
    $createrole_sql  = $createrole  ? { true => "CREATE${role_keyword}",  default => "NOCREATE${role_keyword}" }
    $createdb_sql    = $createdb    ? { true => 'CREATEDB',    default => 'NOCREATEDB' }
    $superuser_sql   = $superuser   ? { true => 'SUPERUSER',   default => 'NOSUPERUSER' }
    $replication_sql = $replication ? { true => 'REPLICATION', default => '' }
    if ($password_hash != false) {
      $environment  = "NEWPGPASSWD=${password_hash}"
      if ($dialect == 'postgres') {
        $password_sql = "ENCRYPTED PASSWORD '\$NEWPGPASSWD'"
      } elsif ($dialect == 'redshift') {
        # Redshift does not define the ENCRYPTED keyword to interpret a hash
        $password_sql = "PASSWORD '\$NEWPGPASSWD'"
      }
    } else {
      if ($dialect == 'postgres') {
        $password_sql = ''
      } elsif ($dialect == 'redshift') {
        $password_sql = "PASSWORD DISABLE"
      }
      $environment  = []
    }
  
    Postgresql_psql {
      db         => $db,
      port       => $port_override,
      psql_user  => $psql_user,
      psql_group => $psql_group,
      psql_path  => $psql_path,
      connect_settings => $connect_settings,
      cwd        => $module_workdir,
      require    => [
        Postgresql_psql["${title}: CREATE ${role_keyword} ${username} ENCRYPTED PASSWORD ****"],
        Class['postgresql::server'],
      ],
    }
  
    if ($dialect == 'postgres') {
      $options_sql = "${createrole_sql} ${createdb_sql} ${login_sql} ${superuser_sql} ${replication_sql}"
    } elsif ($dialect == 'redshift') {
      $options_sql = "${createrole_sql} ${createdb_sql}"
    }
    
    postgresql_psql { "${title}: CREATE ${role_keyword} ${username} ENCRYPTED PASSWORD ****":
      command     => "CREATE ${role_keyword} \"${username}\" ${password_sql} ${options_sql} CONNECTION LIMIT ${role_connection_limit}",
      unless      => "SELECT 1 FROM ${role_table} WHERE ${role_column_prefix}name = '${username}'",
      environment => $environment,
      require     => Class['Postgresql::Server'],
    }
  
    postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${createdb_sql}":
      command => "ALTER ${role_keyword} \"${username}\" ${createdb_sql}",
      unless => "SELECT 1 FROM ${role_table} WHERE ${role_column_prefix}name = '${username}' AND ${role_column_prefix}createdb = ${createdb}",
    }
  
    if ($dialect == 'postgres') {
      postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${createrole_sql}":
        command => "ALTER ${role_keyword} \"${username}\" ${createrole_sql}",
        unless => "SELECT 1 FROM ${role_table} WHERE ${role_column_prefix}name = '${username}' AND rolcreaterole = ${createrole}",
      }
  
      postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${superuser_sql}":
        command => "ALTER ${role_keyword} \"${username}\" ${superuser_sql}",
        unless => "SELECT 1 FROM ${role_table} WHERE rolname = '${username}' AND rolsuper = ${superuser}",
      }
    
      postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${login_sql}":
        command => "ALTER ${role_keyword} \"${username}\" ${login_sql}",
        unless => "SELECT 1 FROM ${role_table} WHERE rolname = '${username}' AND rolcanlogin = ${login}",
      }
    
      postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${inherit_sql}":
        command => "ALTER ${role_keyword} \"${username}\" ${inherit_sql}",
        unless => "SELECT 1 FROM ${role_table} WHERE rolname = '${username}' AND rolinherit = ${inherit}",
      }
    
      if(versioncmp($version, '9.1') >= 0) {
        if $replication_sql == '' {
          postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" NOREPLICATION":
            command => "ALTER ${role_keyword} \"${username}\" NOREPLICATION",
            unless => "SELECT 1 FROM ${role_table} WHERE rolname = '${username}' AND rolreplication = ${replication}",
          }
        } else {
          postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${replication_sql}":
            command => "ALTER ${role_keyword} \"${username}\" ${replication_sql}",
            unless => "SELECT 1 FROM ${role_table} WHERE rolname = '${username}' AND rolreplication = ${replication}",
          }
        }
      }
    } elsif ($dialect == 'redshift') {
  
      # CREATEUSER actually defines superuser privileges in Redshift: http://docs.aws.amazon.com/redshift/latest/dg/r_CREATE_USER.html
      postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${createrole_sql}":
        command => "ALTER ${role_keyword} \"${username}\" ${createrole_sql}",
        unless => "SELECT 1 FROM ${role_table} WHERE usename = '${username}' AND usesuper = ${createrole}",
      }

      # $login can act as a string in Redshift, which is useful for passing PASSWORD DISABLE
      postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" ${login_sql}":
        command => "ALTER ${role_keyword} \"${username}\" ${login_sql}",
        # pg_shadow cannot be selected from in Redshift, even by superusers. As such, this command will always be run when invoked.
        #unless => "SELECT 1 FROM ${password_table} WHERE usename = '${username}' AND passwd = ''",
      }
    }
  
    postgresql_psql {"${title}: ALTER ${role_keyword} \"${username}\" CONNECTION LIMIT ${role_connection_limit}":
      command => "ALTER ${role_keyword} \"${username}\" CONNECTION LIMIT ${role_connection_limit}",
      unless => "SELECT 1 FROM ${role_table} WHERE ${role_column_prefix}name = '${username}' AND ${role_column_prefix}connlimit = '${role_connection_limit}'",
    }
  
    if $password_hash {
      if($password_hash =~ /^md5.+/) {
        $pwd_hash_sql = $password_hash
      } else {
        $pwd_md5 = md5("${password_hash}${username}")
        $pwd_hash_sql = "md5${pwd_md5}"
      }
      if ($dialect == 'postgres') {
        postgresql_psql { "${title}: ALTER ${role_keyword} ${username} ENCRYPTED PASSWORD ****":
          command     => "ALTER ${role_keyword} \"${username}\" ${password_sql}",
          unless      => "SELECT 1 FROM ${password_table} WHERE usename = '${username}' AND passwd = '${pwd_hash_sql}'",
          environment => $environment,
        }
      } elsif ($dialect == 'redshift') {
        postgresql_psql { "${title}: ALTER ${role_keyword} ${username} ENCRYPTED PASSWORD ****":
          command     => "ALTER ${role_keyword} \"${username}\" ${password_sql}",
          # pg_shadow cannot be selected from in Redshift, even by superusers. As such, this command will always be run when invoked.
          #unless      => "SELECT 1 FROM ${password_table} WHERE usename = '${username}' AND passwd = '${pwd_hash_sql}'",
          environment => $environment,
        }
      }
    }
  }
}
