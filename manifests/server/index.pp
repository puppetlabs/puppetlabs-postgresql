define postgresql::server::index (
  Enum['absent','present'] $ensure = 'present',
  String        $index_name        = $title,
  String        $db,
  String        $table,
  Array[String] $columns,
  String        $psql_user         = $postgresql::server::user,
  String        $psql_group        = $postgresql::server::group,
  Integer       $port              = $postgresql::server::port,
  Hash          $connect_settings  = $postgresql::server::default_connect_settings,
  String        $psql_path         = $postgresql::server::psql_path
) {
  $columns_string = join($columns, ',')

  Postgresql_psql {
    db               => $db,
    psql_user        => $psql_user,
    psql_group       => $psql_group,
    port             => $port,
    connect_settings => $connect_settings,
    psql_path        => $psql_path,
  }

  $index_existence_query = "SELECT 1 FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace WHERE c.relname = '${index_name}'"

  if $ensure == 'present' {
    postgresql_psql { "${db}: CREATE INDEX ${index_name}" :
      command => "CREATE INDEX ${index_name} ON ${table}(${columns_string})",
      unless  => $index_existence_query,
    }
  } else {
    postgresql_psql { "${db}: DROP INDEX ${index_name}" :
      command => "DROP INDEX ${index_name}",
      onlyif  => $index_existence_query,
    }
  }
}
