# Define for granting roles to users.
define postgresql::server::role_grant (
  $role,
  $user,
  $admin_option = false
) {

  if $admin_option {
    $grant_cmd = "GRANT \"${role}\" TO \"${user}\" WITH ADMIN OPTION"
  } else {
    $grant_cmd = "GRANT \"${role}\" TO \"${user}\""
  }

  postgresql_psql { $grant_cmd:
    db         => $on_db,
    psql_user  => $psql_user,
    psql_group => $group,
    psql_path  => $psql_path,
    unless     => "SELECT 1 WHERE pg_has_role('${user}', '${role}', 'USAGE')",
    require    => Class['postgresql::server']
  }

  if($role != undef and defined(Postgresql::Server::Role[$role])) {
    Postgresql::Server::Role[$role]->Postgresql_psql[$grant_cmd]
  }

  if($user != undef and defined(Postgresql::Server::Role[$user])) {
    Postgresql::Server::Role[$user]->Postgresql_psql[$grant_cmd]
  }
}
