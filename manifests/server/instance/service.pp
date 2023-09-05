# @summary Manages the service for the postgres main instance (default) or additional instances
#
# @param service_ensure Ensure service is installed
# @param service_enable Enable the PostgreSQL service
# @param service_manage Defines whether or not Puppet should manage the service.
# @param service_name Overrides the default PostgreSQL service name.
# @param service_provider Overrides the default PostgreSQL service provider.
# @param service_status Overrides the default status check command for your PostgreSQL service.
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param port
#   Specifies the port for the PostgreSQL server to listen on.
#   Note: The same port number is used for all IP addresses the server listens on. Also, for Red Hat systems and early Debian systems,
#   changing the port causes the server to come to a full stop before being able to make the change.
#   Default value: 5432. Meaning the Postgres server listens on TCP port 5432.
# @param default_database Specifies the name of the default database to connect with. On most systems this is 'postgres'.
# @param psql_path Specifies the path to the psql command.
# @param connect_settings
#   Specifies a hash of environment variables used when connecting to a remote server. Becomes the default for other defined types,
#   such as postgresql::server::role.
define postgresql::server::instance::service (
  Variant[Enum['running', 'stopped'], Boolean] $service_ensure   = $postgresql::server::service_ensure,
  Boolean                                      $service_enable   = $postgresql::server::service_enable,
  Boolean                                      $service_manage   = $postgresql::server::service_manage,
  String[1]                                    $service_name     = $postgresql::server::service_name,
  Optional[String[1]]                          $service_provider = $postgresql::server::service_provider,
  String[1]                                    $service_status   = $postgresql::server::service_status,
  String[1]                                    $user             = $postgresql::server::user,
  Stdlib::Port                                 $port             = $postgresql::server::port,
  String[1]                                    $default_database = $postgresql::server::default_database,
  Stdlib::Absolutepath                         $psql_path        = $postgresql::server::psql_path,
  Hash                                         $connect_settings = $postgresql::server::default_connect_settings,
) {
  anchor { "postgresql::server::service::begin::${name}": }

  if $service_manage {
    service { "postgresqld_instance_${name}":
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
      postgresql_conn_validator { "validate_service_is_running_instance_${name}":
        run_as           => $user,
        db_name          => $default_database,
        port             => $port,
        connect_settings => $connect_settings,
        sleep            => 1,
        tries            => 60,
        psql_path        => $psql_path,
        require          => Service["postgresqld_instance_${name}"],
        before           => Anchor["postgresql::server::service::end::${name}"],
      }
      Postgresql::Server::Database <| title == $default_database |> -> Postgresql_conn_validator["validate_service_is_running_instance_${name}"]
    }
  }

  anchor { "postgresql::server::service::end::${name}": }
}
