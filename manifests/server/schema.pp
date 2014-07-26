# = Type: postgresql::server::schema
#
# Create a new schema owned by someone
#
# == Requires:
#
# The database must exists and the postgres' user should have enough privileges
#
# == Sample Usage:
#
# postgresql::server::schema {'private':
#     db => 'template1',
# }
#
define postgresql::server::schema (
        $db,
        $schema = $title,
        $owner  = $postgresql::server::user,
        ) {
# Set the defaults for the postgresql_psql resource
    Postgresql_psql {
        psql_user    => $postgresql::server::user,
        psql_group   => $postgresql::server::group,
        psql_path    => $postgresql::server::psql_path,
    }

    postgresql_psql {"CREATE SCHEMA \"${schema}\" AUTHORIZATION \"${owner}\"":
        db     => $db,
        unless => "SELECT 1 FROM \"information_schema\".\"schemata\" WHERE
            schema_name='${schema}'",
    }
}
