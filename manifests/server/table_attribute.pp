define postgresql::server::table_attribute (
  String  $db,
  String  $table,
  String  $attribute,
  String  $value,
  String  $psql_user         = $postgresql::server::user,
  String  $psql_group        = $postgresql::server::group,
  Integer $port              = $postgresql::server::port,
  Hash    $connect_settings  = $postgresql::server::default_connect_settings,
  String  $psql_path         = $postgresql::server::psql_path
) {

  $command = "ALTER TABLE ${table} SET ( ${attribute} = ${value} )"

  postgresql_psql { "${db}: ${command}" :
      command          => $command,
      unless           => "SELECT 1 FROM pg_class WHERE relname = '${table}' AND '${attribute}=${value}' = ANY (reloptions)",
      db               => $db,
      psql_user        => $psql_user,
      psql_group       => $psql_group,
      port             => $port,
      connect_settings => $connect_settings,
      psql_path        => $psql_path,
    }
}
