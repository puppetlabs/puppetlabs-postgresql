# @summary Overrides the default PostgreSQL superuser
#
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
#   Default value: 5432. Meaning the Postgres server listens on TCP port 5432.
# @param psql_path Specifies the path to the psql command.
# @param port
#   Specifies the port for the PostgreSQL server to listen on.
#   Note: The same port number is used for all IP addresses the server listens on. Also, for Red Hat systems and early Debian systems,
#   changing the port causes the server to come to a full stop before being able to make the change.
# @param database Specifies the name of the database to connect with. On most systems this is 'postgres'.
# @param module_workdir Working directory for the PostgreSQL module
# @param postgres_password
#   Sets the password for the postgres user to your specified value. By default, this setting uses the superuser account in the Postgres
#   database, with a user called postgres and no password.
define postgresql::server::instance::passwd (
  String[1]                                                   $user              = $postgresql::server::user,
  String[1]                                                   $group             = $postgresql::server::group,
  Stdlib::Absolutepath                                        $psql_path         = $postgresql::server::psql_path,
  Stdlib::Port                                                $port              = $postgresql::server::port,
  String[1]                                                   $database          = $postgresql::server::default_database,
  Stdlib::Absolutepath                                        $module_workdir    = $postgresql::server::module_workdir,
  Optional[Variant[String[1], Sensitive[String[1]], Integer]] $postgres_password = $postgresql::server::postgres_password,
) {
  $real_postgres_password = if $postgres_password =~ Sensitive {
    $postgres_password.unwrap
  } else {
    $postgres_password
  }

  # psql will default to connecting as $user if you don't specify name
  $_datbase_user_same = $database == $user
  $_dboption = $_datbase_user_same ? {
    false => " --dbname ${stdlib::shell_escape($database)}",
    default => ''
  }

  if $real_postgres_password {
    # NOTE: this password-setting logic relies on the pg_hba.conf being
    #  configured to allow the postgres system user to connect via psql
    #  without specifying a password ('ident' or 'trust' security). This is
    #  the default for pg_hba.conf.
    $escaped = postgresql::postgresql_escape($real_postgres_password)
    $exec_command = "${stdlib::shell_escape($psql_path)}${_dboption} -c \"ALTER ROLE \\\"${stdlib::shell_escape($user)}\\\" PASSWORD \${NEWPASSWD_ESCAPED}\"" # lint:ignore:140chars
    exec { "set_postgres_postgrespw_${name}":
      # This command works w/no password because we run it as postgres system
      # user
      command     => $exec_command,
      user        => $user,
      group       => $group,
      logoutput   => true,
      cwd         => $module_workdir,
      environment => [
        "PGPASSWORD=${real_postgres_password}",
        "PGPORT=${port}",
        "NEWPASSWD_ESCAPED=${escaped}",
      ],
      # With this command we're passing -h to force TCP authentication, which
      # does require a password.  We specify the password via the PGPASSWORD
      # environment variable. If the password is correct (current), this
      # command will exit with an exit code of 0, which will prevent the main
      # command from running.
      unless      => "${psql_path} -h localhost -p ${port} -c 'select 1' > /dev/null",
      path        => '/usr/bin:/usr/local/bin:/bin',
    }
  }
}
