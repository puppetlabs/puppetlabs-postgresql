# @summary Define for conveniently creating a role, database and assigning the correctpermissions.
# 
# @param user User to create and assign access to the database upon creation. Mandatory.
# @param password Required Sets the password for the created user.
# @param comment Defines a comment to be stored about the database using the PostgreSQL COMMENT command.
# @param dbname Sets the name of the database to be created.
# @param encoding Overrides the character set during creation of the database.
# @param locale Overrides the locale during creation of the database.
# @param grant Specifies the permissions to grant during creation. Default value: 'ALL'.
# @param tablespace Defines the name of the tablespace to allocate the created database to.
# @param template Specifies the name of the template database from which to build this database. Defaults value: template0.
# @param istemplate Specifies that the database is a template, if set to true.
# @param owner Sets a user as the owner of the database.
define postgresql::server::db (
  $user,
  $password,
  $comment    = undef,
  $dbname     = $title,
  $encoding   = $postgresql::server::encoding,
  $locale     = $postgresql::server::locale,
  $grant      = 'ALL',
  $tablespace = undef,
  $template   = 'template0',
  $istemplate = false,
  $owner      = undef
) {
  if ! defined(Postgresql::Server::Database[$dbname]) {
    postgresql::server::database { $dbname:
      comment    => $comment,
      encoding   => $encoding,
      tablespace => $tablespace,
      template   => $template,
      locale     => $locale,
      istemplate => $istemplate,
      owner      => $owner,
    }
  }

  if ! defined(Postgresql::Server::Role[$user]) {
    postgresql::server::role { $user:
      password_hash => $password,
      before        => Postgresql::Server::Database[$dbname],
    }
  }

  if ! defined(Postgresql::Server::Database_grant["GRANT ${user} - ${grant} - ${dbname}"]) {
    postgresql::server::database_grant { "GRANT ${user} - ${grant} - ${dbname}":
      privilege => $grant,
      db        => $dbname,
      role      => $user,
    } -> Postgresql_conn_validator<| db_name == $dbname |>
  }

  if($tablespace != undef and defined(Postgresql::Server::Tablespace[$tablespace])) {
    Postgresql::Server::Tablespace[$tablespace]->Postgresql::Server::Database[$name]
  }
}
