define postgresql::server::grant_role (
  $group,
  $role,
  $psql_db          = $postgresql::server::default_database,
  $psql_user        = $postgresql::server::user,
  $port             = $postgresql::server::port,
  $connect_settings = $postgresql::server::default_connect_settings,
) {

  postgresql_psql {"GRANT '${group}' TO '${role}'":
    db               => $psql_db,
    psql_user        => $psql_user,
    port             => $port,
    unless           => "select pg_roles.rolname,usename from pg_user join pg_auth_members on (pg_user.usesysid = pg_auth_members.member) join pg_roles on (pg_roles.oid = pg_auth_members.roleid) where pg_roles.rolname ='${group}' and pg_user.usename = '${role}'",
    connect_settings => $connect_settings,
  }

  if ! $connect_settings or empty($connect_settings) {
    Class['postgresql::server']->Postgresql_psql["GRANT '${group}' TO '${role}'"]
  }
  if defined(Postgresql::Server::Role[$role]) {
    Postgresql::Server::Role[$role]->Postgresql_psql["GRANT '${group}' TO '${role}'"]
  }
  if defined(Postgresql::Server::Role[$group]) {
    Postgresql::Server::Role[$group]->Postgresql_psql["GRANT '${group}' TO '${role}'"]
  }
}
