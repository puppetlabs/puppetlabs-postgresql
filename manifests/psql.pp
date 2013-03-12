# Leverage the exec command to do all the dirty work and provide us with all the fancy features.
define postgresql::psql (
  $command      = $title,
  $require      = undef,
  $subscribe    = undef,
  $unless       = undef,
  $onlyif       = undef,
  $refreshonly  = undef,
  $db           = undef,
  $cwd          = $postgresql::params::datadir,
  $psql_path    = $postgresql::params::psql_path,
  $psql_user    = $postgresql::params::user,
  $tag          = "postgresql",
)
{
  # Build the command
  if ($db != undef) {
    $psql_db = "-d $db"
  } else {
    $psql_db = ""
  }
  
  # main command
  $main_cmd = regsubst("$command", '"', '\"', 'G')
  $sql_command = "$psql_path $psql_db -t -c \"$main_cmd\""

  # unless
  if $unless {
    $unless_cmd = regsubst("SELECT COUNT(*) FROM ($unless) count", '"', '\"', 'G')
    $sql_unless = "[ `$psql_path $psql_db -t -c \"$unless_cmd\" 2> /dev/null | head -1 | tr -d ' '` -gt 0 ]"
  } else {
    $sql_unless = undef
  }

  # onlyif
  if $onlyif {
    $onlyif_cmd = regsubst("SELECT COUNT(*) FROM ($onlyif) count", '"', '\"', 'G')
    $sql_onlyif = "[ `$psql_path $psql_db -t -c \"$onlyif_cmd\" 2> /dev/null | head -1 | tr -d ' '` -gt 0 ]"
  } else {
    $sql_onlyif = undef
  }

  exec { $title:
    command     => $sql_command,
    unless      => $sql_unless,
    onlyif      => $sql_onlyif,
    require     => $require,
    subscribe   => $subscribe,
    refreshonly => $refreshonly,
    cwd         => $cwd,
    user        => $psql_user,
    tag         => $tag,
  }
}
