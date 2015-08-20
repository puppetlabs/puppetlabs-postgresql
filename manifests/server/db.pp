# Define for conveniently creating a role, database and assigning the correct
# permissions. See README.md for more details.
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
  $owner      = undef,
  $ensure     = 'present',
) {

  if $ensure == 'present' {
    Postgresql::Server::Role[$user] ->
    Postgresql::Server::Database[$dbname] ->
    Postgresql::Server::Database_grant["GRANT ${user} - ${grant} - ${dbname}"]
  } elsif $ensure == 'absent' {
    Postgresql::Server::Database[$dbname] ->
    Postgresql::Server::Role[$user]
  }


  if ! defined(Postgresql::Server::Database[$dbname]) {
    postgresql::server::database { $dbname:
      ensure     => $ensure,
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
      ensure        => $ensure,
      password_hash => $password,
    }
  }

  if ! defined(Postgresql::Server::Database_grant["GRANT ${user} - ${grant} - ${dbname}"]) and $ensure == 'present' {
    postgresql::server::database_grant { "GRANT ${user} - ${grant} - ${dbname}":
      ensure    => $ensure,
      privilege => $grant,
      db        => $dbname,
      role      => $user,
    } -> Postgresql::Validate_db_connection<| database_name == $dbname |>
  }

  if($tablespace != undef and defined(Postgresql::Server::Tablespace[$tablespace])) {
    Postgresql::Server::Tablespace[$tablespace]->Postgresql::Server::Database[$name]
  }
}
