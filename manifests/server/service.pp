# @api private
class postgresql::server::service {
  postgresql::server::instance::service { 'main':
    service_ensure   => $postgresql::server::service_ensure,
    service_enable   => $postgresql::server::service_enable,
    service_manage   => $postgresql::server::service_manage,
    service_name     => $postgresql::server::service_name,
    service_provider => $postgresql::server::service_provider,
    service_status   => $postgresql::server::service_status,
    user             => $postgresql::server::user,
    port             => $postgresql::server::port,
    default_database => $postgresql::server::default_database,
    psql_path        => $postgresql::server::psql_path,
    connect_settings => $postgresql::server::default_connect_settings,
  }
}
