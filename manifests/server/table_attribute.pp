define postgresql::server::table_attribute (
  Enum['absent','present'] $ensure = 'present',
  String  $db,
  String  $table,
  String  $attribute,
  String  $value,
  String  $psql_user        = $postgresql::server::user,
  String  $psql_group       = $postgresql::server::group,
  Integer $port             = $postgresql::server::port,
  Hash    $connect_settings = $postgresql::server::default_connect_settings,
  String  $psql_path        = $postgresql::server::psql_path
) {

  Postgresql_psql {
    db               => $db,
    psql_user        => $psql_user,
    psql_group       => $psql_group,
    port             => $port,
    connect_settings => $connect_settings,
    psql_path        => $psql_path,
  }

  $create_command = "ALTER TABLE ${table} SET ( ${attribute} = ${value} )"
  $reset_command = "ALTER TABLE ${table} RESET ( ${attribute} )"

  if $ensure == 'present' {
    postgresql_psql { "${db}: ${create_command}" :
      command => $create_command,
      unless  => "SELECT 1 FROM pg_class WHERE relname = '${table}' AND '${attribute}=${value}' = ANY (reloptions)",
    }
  } else {
    postgresql_psql { "${db}: ${reset_command}" :
      command => $reset_command,
      onlyif  => "SELECT 1 FROM pg_class WHERE relname = '${table}' AND CAST(reloptions as text) LIKE '%{attribute}%'",
    }
  }
}
