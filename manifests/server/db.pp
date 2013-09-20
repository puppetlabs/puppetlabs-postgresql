# Define for conveniently creating a role, database and assigning the correct
# permissions. See README.md for more details.
define postgresql::server::db (
  $user,
  $password,
  $encoding   = $postgresql::server::encoding,
  $locale     = $postgresql::server::locale,
  $grant      = 'ALL',
  $tablespace = undef,
  $istemplate = false
) {
  postgresql::server::database { $name:
    encoding   => $encoding,
    tablespace => $tablespace,
    locale     => $locale,
    istemplate => $istemplate,
  }

  if ! defined(Postgresql::Server::Role[$user]) {
    postgresql::server::role { $user:
      password_hash => $password,
    }
  }

  postgresql::server::database_grant { "GRANT ${user} - ${grant} - ${name}":
    privilege => $grant,
    db        => $name,
    role      => $user,
  }

  if($tablespace != undef and defined(Postgresql::Server::Tablespace[$tablespace])) {
    Postgresql::Server::Tablespace[$tablespace]->Postgresql::Server::Database[$name]
  }
}
