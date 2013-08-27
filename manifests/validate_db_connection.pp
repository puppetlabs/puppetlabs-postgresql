# This type validates that a successful postgres connection can be established
# between the node on which this resource is run and a specified postgres
# instance (host/port/user/password/database name).
#
# See README.md for more details.
define postgresql::validate_db_connection(
  $database_host,
  $database_name,
  $database_password,
  $database_username,
  $database_port = 5432
) {
  require postgresql::client

  $psql_path = $postgresql::params::psql_path

  # TODO: port to ruby
  $psql = "${psql_path} --tuples-only --quiet -h ${database_host} -U ${database_username} -p ${database_port} --dbname ${database_name}"

  $exec_name = "validate postgres connection for ${database_host}/${database_name}"
  exec { $exec_name:
    command     => '/bin/false',
    unless      => "/bin/echo \"SELECT 1\" | ${psql}",
    cwd         => '/tmp',
    environment => "PGPASSWORD=${database_password}",
    logoutput   => 'on_failure',
    require     => Package['postgresql-client'],
  }

  # This is a little bit of puppet magic.  What we want to do here is make
  # sure that if the validation and the database instance creation are being
  # applied on the same machine, then the database resource is applied *before*
  # the validation resource.  Otherwise, the validation is guaranteed to fail
  # on the first run.
  #
  # We accomplish this by using Puppet's resource collection syntax to search
  # for the Database resource in our current catalog; if it exists, the
  # appropriate relationship is created here.
  Postgresql::Server::Database<|title == $database_name|> -> Exec[$exec_name]
}
