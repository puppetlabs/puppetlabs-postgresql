# lint:ignore:140chars
# @param service_ensure Ensure service is installed
# @param service_enable Enable the PostgreSQL service
# @param service_manage Defines whether or not Puppet should manage the service.
# @param service_name Overrides the default PostgreSQL service name.
# @param service_provider Overrides the default PostgreSQL service provider.
# @param service_status Overrides the default status check command for your PostgreSQL service.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param port Specifies the port for the PostgreSQL server to listen on. Note: The same port number is used for all IP addresses the server listens on. Also, for Red Hat systems and early Debian systems, changing the port causes the server to come to a full stop before being able to make the change.
#   Default value: 5432. Meaning the Postgres server listens on TCP port 5432.
# @param default_database Specifies the name of the default database to connect with. On most systems this is 'postgres'.
# @param psql_path Specifies the path to the psql command.
# @param default_connect_settings Specifies a hash of environment variables used when connecting to a remote server. Becomes the default for other defined types, such as postgresql::server::role.
# lint:endignore:140chars
define postgresql::server::instance_service (
  $service_ensure   = $postgresql::server::service_ensure,
  $service_enable   = $postgresql::server::service_enable,
  $service_manage   = $postgresql::server::service_manage,
  $service_name     = $postgresql::server::service_name,
  $service_provider = $postgresql::server::service_provider,
  $service_status   = $postgresql::server::service_status,
  $user             = $postgresql::server::user,
  $port             = $postgresql::server::port,
  $default_database = $postgresql::server::default_database,
  $psql_path        = $postgresql::server::psql_path,
  $connect_settings = $postgresql::server::default_connect_settings,
) {
  anchor { 'postgresql::server::service::begin': }

  if $service_manage {
    service { 'postgresqld':
      ensure    => $service_ensure,
      enable    => $service_enable,
      name      => $service_name,
      provider  => $service_provider,
      hasstatus => true,
      status    => $service_status,
    }

    if $service_ensure in ['running', true] {
      # This blocks the class before continuing if chained correctly, making
      # sure the service really is 'up' before continuing.
      #
      # Without it, we may continue doing more work before the database is
      # prepared leading to a nasty race condition.
      postgresql_conn_validator { 'validate_service_is_running':
        run_as           => $user,
        db_name          => $default_database,
        port             => $port,
        connect_settings => $connect_settings,
        sleep            => 1,
        tries            => 60,
        psql_path        => $psql_path,
        require          => Service['postgresqld'],
        before           => Anchor['postgresql::server::service::end'],
      }
      Postgresql::Server::Database <| title == $default_database |> -> Postgresql_conn_validator['validate_service_is_running']
    }
  }

  anchor { 'postgresql::server::service::end': }
}
