# = Type: postgresql::server::schema
#
# Create a new schema. See README.md for more details.
#
# == Requires:
#
# The database must exist and the PostgreSQL user should have enough privileges
#
# == Sample Usage:
#
# postgresql::server::schema {'private':
#     db => 'template1',
# }
#
define postgresql::server::schema(
  $db = $postgresql::server::default_database,
  $owner  = undef,
  $schema = $title,
  $connect_settings = $postgresql::server::default_connect_settings,
  $change_ownership = false,
) {
  $user      = $postgresql::server::user
  $group     = $postgresql::server::group
  $psql_path = $postgresql::server::psql_path
  $version   = $postgresql::server::_version

  # If the connection settings do not contain a port, then use the local server port
  if $connect_settings != undef and has_key( $connect_settings, 'PGPORT') {
    $port = undef
  } else {
    $port = $postgresql::server::port
  }

  Postgresql_psql {
    db         => $db,
    psql_user  => $user,
    psql_group => $group,
    psql_path  => $psql_path,
    port       => $port,
    connect_settings => $connect_settings,
  }

  $schema_exists = "SELECT nspname FROM pg_namespace WHERE nspname='${schema}'"
  $authorization = $owner? {
    undef   => '',
    default => "AUTHORIZATION \"${owner}\"",
  }

  if $change_ownership {
    # Change owner for existing schema
    if !$owner {
      fail('Must specify an owner to change schema ownership.')
    }
    $schema_title   = "Change owner of schema '${schema}' to ${owner}"
    $schema_command = "ALTER SCHEMA \"${schema}\" OWNER TO ${owner}"
    postgresql_psql { $schema_title:
      command => $schema_command,
      onlyif  => $schema_exists,
      require => Class['postgresql::server'],
    }
  } else {
    # Create a new schema
    $schema_title   = "Create Schema '${title}'"
    $schema_command = "CREATE SCHEMA \"${schema}\" ${authorization}"
    postgresql_psql { $schema_title:
      command => $schema_command,
      unless  => $schema_exists,
      require => Class['postgresql::server'],
    }
  }

  if($owner != undef and defined(Postgresql::Server::Role[$owner])) {
    Postgresql::Server::Role[$owner]->Postgresql_psql[$schema_title]
  }
}
