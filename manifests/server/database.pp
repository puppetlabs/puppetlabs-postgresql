# @summary Define for creating a database.
#
# @param comment Sets a comment on the database.
# @param dbname Sets the name of the database.
# @param owner Sets name of the database owner.
# @param tablespace Sets tablespace for where to create this database.
# @param template Specifies the name of the template database from which to build this database. Default value: 'template0'.
# @param encoding Overrides the character set during creation of the database.
# @param locale Overrides the locale during creation of the database.
# @param istemplate Defines the database as a template if set to true.
# @param instance The name of the Postgresql database instance.
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param psql_path Specifies the path to the psql command.
# @param default_db Specifies the name of the default database to connect with. On most systems this is 'postgres'.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
# @param port Specifies the port for the PostgreSQL server to listen on.
define postgresql::server::database (
  Optional[String[1]]  $comment          = undef,
  String[1]            $dbname           = $title,
  Optional[String[1]]  $owner            = undef,
  Optional[String[1]]  $tablespace       = undef,
  String[1]            $template         = 'template0',
  Optional[String[1]]  $encoding         = $postgresql::server::encoding,
  Optional[String[1]]  $locale           = $postgresql::server::locale,
  Boolean              $istemplate       = false,
  String[1]            $instance         = 'main',
  Hash                 $connect_settings = $postgresql::server::default_connect_settings,
  String[1]            $user             = $postgresql::server::user,
  String[1]            $group            = $postgresql::server::group,
  Stdlib::Absolutepath $psql_path        = $postgresql::server::psql_path,
  String[1]            $default_db       = $postgresql::server::default_database,
  Stdlib::Port         $port             = $postgresql::server::port
) {
  $version = pick($connect_settings['DBVERSION'], $postgresql::server::_version)
  $port_override = pick($connect_settings['PGPORT'], $port)

  # Set the defaults for the postgresql_psql resource
  Postgresql_psql {
    db               => $default_db,
    psql_user        => $user,
    psql_group       => $group,
    psql_path        => $psql_path,
    port             => $port_override,
    connect_settings => $connect_settings,
    instance         => $instance,
  }

  # Optionally set the locale switch. Older versions of createdb may not accept
  # --locale, so if the parameter is undefined its safer not to pass it.
  $locale_option = $locale ? {
    undef   => '',
    default => "LC_COLLATE = '${locale}' LC_CTYPE = '${locale}'",
  }
  $public_revoke_privilege = 'CONNECT'

  $template_option = $template ? {
    undef   => '',
    default => "TEMPLATE = \"${template}\"",
  }

  $encoding_option = $encoding ? {
    undef   => '',
    default => "ENCODING = '${encoding}'",
  }

  $tablespace_option = $tablespace ? {
    undef   => '',
    default => "TABLESPACE \"${tablespace}\"",
  }

  postgresql_psql { "CREATE DATABASE \"${dbname}\"":
    command => "CREATE DATABASE \"${dbname}\" WITH ${template_option} ${encoding_option} ${locale_option} ${tablespace_option}",
    unless  => "SELECT 1 FROM pg_database WHERE datname = '${dbname}'",
    require => Class['postgresql::server::service'],
  }

  # This will prevent users from connecting to the database unless they've been
  #  granted privileges.
  ~> postgresql_psql { "REVOKE ${public_revoke_privilege} ON DATABASE \"${dbname}\" FROM public":
    refreshonly => true,
  }

  Postgresql_psql["CREATE DATABASE \"${dbname}\""]
  -> postgresql_psql { "UPDATE pg_database SET datistemplate = ${istemplate} WHERE datname = '${dbname}'":
    unless => "SELECT 1 FROM pg_database WHERE datname = '${dbname}' AND datistemplate = ${istemplate}",
  }

  if $comment {
    Postgresql_psql["CREATE DATABASE \"${dbname}\""]
    -> postgresql_psql { "COMMENT ON DATABASE \"${dbname}\" IS '${comment}'":
      unless => "SELECT 1 FROM pg_catalog.pg_database d WHERE datname = '${dbname}' AND pg_catalog.shobj_description(d.oid, 'pg_database') = '${comment}'", # lint:ignore:140chars
      db     => $dbname,
    }
  }

  if $owner {
    postgresql_psql { "ALTER DATABASE \"${dbname}\" OWNER TO \"${owner}\"":
      unless  => "SELECT 1 FROM pg_database JOIN pg_roles rol ON datdba = rol.oid WHERE datname = '${dbname}' AND rolname = '${owner}'",
      require => Postgresql_psql["CREATE DATABASE \"${dbname}\""],
    }

    if defined(Postgresql::Server::Role[$owner]) {
      Postgresql::Server::Role[$owner] -> Postgresql_psql["ALTER DATABASE \"${dbname}\" OWNER TO \"${owner}\""]
    }
  }

  if $tablespace {
    postgresql_psql { "ALTER DATABASE \"${dbname}\" SET ${tablespace_option}":
      unless  => "SELECT 1 FROM pg_database JOIN pg_tablespace spc ON dattablespace = spc.oid WHERE datname = '${dbname}' AND spcname = '${tablespace}'", # lint:ignore:140chars
      require => Postgresql_psql["CREATE DATABASE \"${dbname}\""],
    }

    if defined(Postgresql::Server::Tablespace[$tablespace]) {
      # The tablespace must be there, before we create the database.
      Postgresql::Server::Tablespace[$tablespace] -> Postgresql_psql["CREATE DATABASE \"${dbname}\""]
    }
  }
}
