# @ summary Define for conveniently creating a role, database and assigning the correctpermissions.
# 
# @param user
# @param password
# @param comment
# @param dbname
# @param encoding
# @param locale
# @param grant
# @param tablespace
# @param template
# @param istemplate
# @param owner 
#
#
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
