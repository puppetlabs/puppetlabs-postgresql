# @summary Activate an extension on a postgresql database.
#
# @param database Specifies the database on which to activate the extension.
# @param extension Specifies the extension to activate. If left blank, uses the name of the resource.
# @param schema Specifies the schema on which to activate the extension.
# @param version Specifies the version of the extension which the database uses. When an extension package is updated, this does not automatically change the effective version in each database.
#   This needs be updated using the PostgreSQL-specific SQL ALTER EXTENSION...
#   version may be set to latest, in which case the SQL ALTER EXTENSION "extension" UPDATE is applied to this database (only).
#   version may be set to a specific version, in which case the extension is updated using ALTER EXTENSION "extension" UPDATE TO 'version'
#   eg. If extension is set to postgis and version is set to 2.3.3, this will apply the SQL ALTER EXTENSION "postgis" UPDATE TO '2.3.3' to this database only.
#   version may be omitted, in which case no ALTER EXTENSION... SQL is applied, and the version will be left unchanged.
#
# @param ensure Specifies whether to activate or deactivate the extension. Valid options: 'present' or 'absent'.
# @param package_name Specifies a package to install prior to activating the extension.
# @param package_ensure Overrides default package deletion behavior. By default, the package specified with package_name is installed when the extension is activated and removed when the extension is deactivated. To override this behavior, set the ensure value for the package.
# @param port Port to use when connecting.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param database_resource_name Specifies the resource name of the DB being managed. Defaults to the parameter $database, if left blank.
define postgresql::server::extension (
  $database,
  $extension                   = $name,
  Optional[String[1]] $schema  = undef,
  Optional[String[1]] $version = undef,
  String[1] $ensure            = 'present',
  $package_name                = undef,
  $package_ensure              = undef,
  Optional[Integer] $port      = undef,
  $connect_settings            = postgresql::default('default_connect_settings'),
  $database_resource_name      = $database,
) {
  $user             = postgresql::default('user')
  $group            = postgresql::default('group')
  $psql_path        = postgresql::default('psql_path')

  if( $database != 'postgres' ) {
    # The database postgres cannot managed by this module, so it is exempt from this dependency
    $default_psql_require = Postgresql::Server::Database[$database_resource_name]

    Postgresql_psql {
      require => $default_psql_require,
    }
  } else {
    $default_psql_require = undef
  }

  case $ensure {
    'present': {
      $command = "CREATE EXTENSION \"${extension}\""
      $unless_mod = undef
      $psql_cmd_require = $package_name ? {
        undef   => $default_psql_require,
        default => [$default_psql_require, Package[$package_name]],
      }
      $psql_cmd_before = []
    }

    'absent': {
      $command = "DROP EXTENSION \"${extension}\""
      $unless_mod = 'NOT '
      $psql_cmd_require = $default_psql_require
      $psql_cmd_before = $package_name ? {
        undef   => [],
        default => Package[$package_name],
      }
    }

    default: {
      fail("Unknown value for ensure '${ensure}'.")
    }
  }

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

  postgresql_psql { "${database}: ${command}":

    psql_user        => $user,
    psql_group       => $group,
    psql_path        => $psql_path,
    connect_settings => $connect_settings,

    db               => $database,
    port             => $port_override,
    command          => $command,
    unless           => "SELECT 1 WHERE ${unless_mod}EXISTS (SELECT 1 FROM pg_extension WHERE extname = '${extension}')",
    require          => $psql_cmd_require,
    before           => $psql_cmd_before,
  }

  if $ensure == 'present' and $schema {
    $set_schema_command = "ALTER EXTENSION \"${extension}\" SET SCHEMA \"${schema}\""

    postgresql_psql { "${database}: ${set_schema_command}":
      command          => $set_schema_command,
      unless           => @("END")
        SELECT 1
        WHERE EXISTS (
          SELECT 1
          FROM pg_extension e
            JOIN pg_namespace n ON e.extnamespace = n.oid
          WHERE e.extname = '${extension}' AND
                n.nspname = '${schema}'
        )
        |-END
      ,
      psql_user        => $user,
      psql_group       => $group,
      psql_path        => $psql_path,
      connect_settings => $connect_settings,
      db               => $database,
      port             => $port_override,
      require          => Postgresql_psql["${database}: ${command}"],
    }

    Postgresql::Server::Schema <| db == $database and schema == $schema |> -> Postgresql_psql["${database}: ${set_schema_command}"]
  }

  if $package_name {
    $_package_ensure = $package_ensure ? {
      undef   => $ensure,
      default => $package_ensure,
    }

    ensure_packages($package_name, {
        ensure  => $_package_ensure,
        tag     => 'puppetlabs-postgresql',
    })
  }
  if $version {
    if $version == 'latest' {
      $alter_extension_sql = "ALTER EXTENSION \"${extension}\" UPDATE"
      $update_unless = "SELECT 1 FROM pg_available_extensions WHERE name = '${extension}' AND default_version = installed_version"
    } else {
      $alter_extension_sql = "ALTER EXTENSION \"${extension}\" UPDATE TO '${version}'"
      $update_unless = "SELECT 1 FROM pg_extension WHERE extname='${extension}' AND extversion='${version}'"
    }
    postgresql_psql { "${database}: ${alter_extension_sql}":
      db               => $database,
      port             => $port_override,
      psql_user        => $user,
      psql_group       => $group,
      psql_path        => $psql_path,
      connect_settings => $connect_settings,
      command          => $alter_extension_sql,
      unless           => $update_unless,
    }
  }
}
