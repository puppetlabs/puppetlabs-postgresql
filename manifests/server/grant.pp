# @summary Define for granting permissions to roles.
#
# @param role Specifies the role or user whom you are granting access to.
# @param db Specifies the database to which you are granting access.
# @param privilege Specifies the privilege to grant. Valid options: 'ALL', 'ALL PRIVILEGES' or 'object_type' dependent string.
# @param object_type Specifies the type of object to which you are granting privileges. Valid options: 'DATABASE', 'SCHEMA', 'SEQUENCE', 'ALL SEQUENCES IN SCHEMA', 'TABLE' or 'ALL TABLES IN SCHEMA'.
# @param object_name Specifies name of object_type to which to grant access, can be either a string or a two element array. String: 'object_name' Array: ['schema_name', 'object_name']
# @param psql_db Specifies the database to execute the grant against. This should not ordinarily be changed from the default
# @param psql_user Sets the OS user to run psql.
# @param port Port to use when connecting.
# @param onlyif_exists Create grant only if doesn't exist
# @param connect_settings Specifies a hash of environment variables used when connecting to a remote server.
# @param ensure Specifies whether to grant or revoke the privilege. Default is to grant the privilege. Valid values: 'present', 'absent'.
define postgresql::server::grant (
  String $role,
  String $db,
  String $privilege      = '',
  Pattern[#/(?i:^COLUMN$)/,
    /(?i:^ALL SEQUENCES IN SCHEMA$)/,
    /(?i:^ALL TABLES IN SCHEMA$)/,
    /(?i:^DATABASE$)/,
    #/(?i:^FOREIGN DATA WRAPPER$)/,
    #/(?i:^FOREIGN SERVER$)/,
    #/(?i:^FUNCTION$)/,
    /(?i:^LANGUAGE$)/,
    #/(?i:^PROCEDURAL LANGUAGE$)/,
    /(?i:^TABLE$)/,
    #/(?i:^TABLESPACE$)/,
    /(?i:^SCHEMA$)/,
    /(?i:^SEQUENCE$)/
    #/(?i:^VIEW$)/
  ] $object_type                   = 'database',
  Optional[Variant[
            Array[String,2,2],
            String[1]]
  ] $object_name                   = undef,
  String $psql_db                  = $postgresql::server::default_database,
  String $psql_user                = $postgresql::server::user,
  Integer $port                    = $postgresql::server::port,
  Boolean $onlyif_exists           = false,
  Hash $connect_settings           = $postgresql::server::default_connect_settings,
  Enum['present',
        'absent'
  ] $ensure                        = 'present',
) {

  case $ensure {
    default: {
      # default is 'present'
      $sql_command = 'GRANT %s ON %s "%s" TO "%s"'
      $unless_is = true
    }
    'absent': {
      $sql_command = 'REVOKE %s ON %s "%s" FROM "%s"'
      $unless_is = false
    }
  }

  $group     = $postgresql::server::group
  $psql_path = $postgresql::server::psql_path

  if ! $object_name {
    $_object_name = $db
  } else {
    $_object_name = $object_name
  }

  #
  # Port, order of precedence: $port parameter, $connect_settings[PGPORT], $postgresql::server::port
  #
  if $port != undef {
    $port_override = $port
  } elsif $connect_settings != undef and has_key( $connect_settings, 'PGPORT') {
    $port_override = undef
  } else {
    $port_override = $postgresql::server::port
  }

  ## Munge the input values
  $_object_type = upcase($object_type)
  $_privilege   = upcase($privilege)

  # You can use ALL TABLES IN SCHEMA by passing schema_name to object_name
  # You can use ALL SEQUENCES IN SCHEMA by passing schema_name to object_name

  ## Validate that the object type's privilege is acceptable
  # TODO: this is a terrible hack; if they pass "ALL" as the desired privilege,
  #  we need a way to test for it--and has_database_privilege does not
  #  recognize 'ALL' as a valid privilege name. So we probably need to
  #  hard-code a mapping between 'ALL' and the list of actual privileges that
  #  it entails, and loop over them to check them.  That sort of thing will
  #  probably need to wait until we port this over to ruby, so, for now, we're
  #  just going to assume that if they have "CREATE" privileges on a database,
  #  then they have "ALL".  (I told you that it was terrible!)
  case $_object_type {
    'DATABASE': {
      $unless_privilege = $_privilege ? {
        'ALL'            => 'CREATE',
        'ALL PRIVILEGES' => 'CREATE',
        Pattern[
          /^$/,
          /^CONNECT$/,
          /^CREATE$/,
          /^TEMP$/,
          /^TEMPORARY$/
        ]                => $_privilege,
        default          => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_database_privilege'
      $on_db = $psql_db
      $onlyif_function = $ensure ? {
        default  => undef,
        'absent' =>  'role_exists',
      }
    }
    'SCHEMA': {
      $unless_privilege = $_privilege ? {
        'ALL'            => 'CREATE',
        'ALL PRIVILEGES' => 'CREATE',
        Pattern[
          /^$/,
          /^CREATE$/,
          /^USAGE$/
        ]                => $_privilege,
        default          => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_schema_privilege'
      $on_db = $db
      $onlyif_function = undef
    }
    'SEQUENCE': {
      $unless_privilege = $_privilege ? {
        'ALL'   => 'USAGE',
        Pattern[
          /^$/,
          /^ALL PRIVILEGES$/,
          /^SELECT$/,
          /^UPDATE$/,
          /^USAGE$/
        ]       => $_privilege,
        default => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_sequence_privilege'
      $on_db = $db
      $onlyif_function = undef
    }
    'ALL SEQUENCES IN SCHEMA': {
      case $_privilege {
        Pattern[
          /^$/,
          /^ALL$/,
          /^ALL PRIVILEGES$/,
          /^SELECT$/,
          /^UPDATE$/,
          /^USAGE$/
        ]:       { }
        default: { fail('Illegal value for $privilege parameter') }
      }
      $unless_function = 'custom'
      $on_db = $db
      $onlyif_function = undef

      $schema = $object_name

      $custom_privilege = $_privilege ? {
        'ALL'            => 'USAGE',
        'ALL PRIVILEGES' => 'USAGE',
        default          => $_privilege,
      }

      # This checks if there is a difference between the sequences in the
      # specified schema and the sequences for which the role has the specified
      # privilege. It uses the EXCEPT clause which computes the set of rows
      # that are in the result of the first SELECT statement but not in the
      # result of the second one. It then counts the number of rows from this
      # operation. If this number is zero then the role has the specified
      # privilege for all sequences in the schema and the whole query returns a
      # single row, which satisfies the `unless` parameter of Postgresql_psql.
      # If this number is not zero then there is at least one sequence for which
      # the role does not have the specified privilege, making it necessary to
      # execute the GRANT statement.
      if $ensure == 'present' {
        $custom_unless = "SELECT 1 WHERE NOT EXISTS (
          SELECT sequence_name
          FROM information_schema.sequences
          WHERE sequence_schema='${schema}'
            EXCEPT DISTINCT
          SELECT object_name as sequence_name
          FROM (
            SELECT object_schema,
                   object_name,
                   grantee,
                   CASE privs_split
                     WHEN 'r' THEN 'SELECT'
                     WHEN 'w' THEN 'UPDATE'
                     WHEN 'U' THEN 'USAGE'
                   END AS privilege_type
              FROM (
                SELECT DISTINCT
                       object_schema,
                       object_name,
                       regexp_replace((regexp_split_to_array(regexp_replace(privs,E'/.*',''),'='))[1],'\"','','g') AS grantee,
                       regexp_split_to_table((regexp_split_to_array(regexp_replace(privs,E'/.*',''),'='))[2],E'\\s*') AS privs_split
                  FROM (
                   SELECT n.nspname as object_schema,
                           c.relname as object_name,
                           regexp_split_to_table(array_to_string(c.relacl,','),',') AS privs
                      FROM pg_catalog.pg_class c
                           LEFT JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
                     WHERE c.relkind = 'S'
                           AND n.nspname NOT IN ( 'pg_catalog', 'information_schema' )
                  ) P1
              ) P2
          ) P3
          WHERE grantee='${role}'
          AND object_schema='${schema}'
          AND privilege_type='${custom_privilege}'
          )"
      } else {
        # ensure == absent
        $custom_unless = "SELECT 1 WHERE NOT EXISTS (
          SELECT object_name as sequence_name
          FROM (
            SELECT object_schema,
                   object_name,
                   grantee,
                   CASE privs_split
                     WHEN 'r' THEN 'SELECT'
                     WHEN 'w' THEN 'UPDATE'
                     WHEN 'U' THEN 'USAGE'
                   END AS privilege_type
              FROM (
                SELECT DISTINCT
                       object_schema,
                       object_name,
                       regexp_replace((regexp_split_to_array(regexp_replace(privs,E'/.*',''),'='))[1],'\"','','g') AS grantee,
                       regexp_split_to_table((regexp_split_to_array(regexp_replace(privs,E'/.*',''),'='))[2],E'\\s*') AS privs_split
                  FROM (
                   SELECT n.nspname as object_schema,
                           c.relname as object_name,
                           regexp_split_to_table(array_to_string(c.relacl,','),',') AS privs
                      FROM pg_catalog.pg_class c
                           LEFT JOIN pg_catalog.pg_namespace n ON c.relnamespace = n.oid
                     WHERE c.relkind = 'S'
                           AND n.nspname NOT IN ( 'pg_catalog', 'information_schema' )
                  ) P1
              ) P2
          ) P3
          WHERE grantee='${role}'
          AND object_schema='${schema}'
          AND privilege_type='${custom_privilege}'
          )"
      }
    }
    'TABLE': {
      $unless_privilege = $_privilege ? {
        'ALL'   => 'INSERT',
        Pattern[
          /^$/,
          /^ALL$/,
          /^ALL PRIVILEGES$/,
          /^DELETE$/,
          /^INSERT$/,
          /^REFERENCES$/,
          /^SELECT$/,
          /^TRIGGER$/,
          /^TRUNCATE$/,
          /^UPDATE$/
        ]       => $_privilege,
        default => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_table_privilege'
      $on_db = $db
      $onlyif_function = $onlyif_exists ? {
        true    => 'table_exists',
        default => undef,
      }
    }
    'ALL TABLES IN SCHEMA': {
      case $_privilege {
        Pattern[
          /^$/,
          /^ALL$/,
          /^ALL PRIVILEGES$/,
          /^DELETE$/,
          /^INSERT$/,
          /^REFERENCES$/,
          /^SELECT$/,
          /^TRIGGER$/,
          /^TRUNCATE$/,
          /^UPDATE$/
        ]:       { }
        default: { fail('Illegal value for $privilege parameter') }
      }
      $unless_function = 'custom'
      $on_db = $db
      $onlyif_function = undef

      $schema = $object_name

      # Again there seems to be no easy way in plain SQL to check if ALL
      # PRIVILEGES are granted on a table.
      # There are currently 7 possible priviliges:
      # ('SELECT','UPDATE','INSERT','DELETE','TRIGGER','REFERENCES','TRUNCATE')
      # This list is consistant from Postgresql 8.0
      #
      # There are 4 cases to cover, each with it's own distinct unless clause:
      #    grant ALL
      #    grant SELECT (or INSERT or DELETE ...)
      #    revoke ALL
      #    revoke SELECT (or INSERT or DELETE ...)

      if $ensure == 'present' {
        if $_privilege == 'ALL' or $_privilege == 'ALL PRIVILEGES' {
          # GRANT ALL
          $custom_unless = "SELECT 1 WHERE NOT EXISTS
             ( SELECT 1 FROM pg_catalog.pg_tables AS t,
               (VALUES ('SELECT'), ('UPDATE'), ('INSERT'), ('DELETE'), ('TRIGGER'), ('REFERENCES'), ('TRUNCATE')) AS p(privilege_type)
               WHERE t.schemaname = '${schema}'
                 AND NOT EXISTS (
                   SELECT 1 FROM information_schema.role_table_grants AS g
                   WHERE g.grantee = '${role}'
                     AND g.table_schema = '${schema}'
                     AND g.privilege_type = p.privilege_type
                   )
             )"

        } else {
          # GRANT $_privilege
          $custom_unless = "SELECT 1 WHERE NOT EXISTS
             ( SELECT 1 FROM pg_catalog.pg_tables AS t
               WHERE t.schemaname = '${schema}'
                 AND NOT EXISTS (
                   SELECT 1 FROM information_schema.role_table_grants AS g
                   WHERE g.grantee = '${role}'
                     AND g.table_schema = '${schema}'
                     AND g.privilege_type = '${_privilege}'
                     AND g.table_name = t.tablename
                   )
             )"
        }
      } else {
        if $_privilege == 'ALL' or $_privilege == 'ALL PRIVILEGES' {
          # REVOKE ALL
          $custom_unless = "SELECT 1 WHERE NOT EXISTS
             ( SELECT table_name FROM information_schema.role_table_grants
               WHERE grantee = '${role}' AND table_schema ='${schema}'
             )"
        } else {
          # REVOKE $_privilege
          $custom_unless = "SELECT 1 WHERE NOT EXISTS
             ( SELECT table_name FROM information_schema.role_table_grants
               WHERE grantee = '${role}' AND table_schema ='${schema}'
               AND privilege_type = '${_privilege}'
             )"
        }
      }

    }
    'LANGUAGE': {
      $unless_privilege = $_privilege ? {
        'ALL'            => 'USAGE',
        'ALL PRIVILEGES' => 'USAGE',
        Pattern[
          /^$/,
          /^CREATE$/,
          /^USAGE$/
        ]                => $_privilege,
        default          => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_language_privilege'
      $on_db = $db
      $onlyif_function = $onlyif_exists ? {
        true    => 'language_exists',
        default => undef,
      }
    }

    default: {
      fail("Missing privilege validation for object type ${_object_type}")
    }
  }

  # This is used to give grant to "schemaname"."tablename"
  # If you need such grant, use:
  # postgresql::grant { 'table:foo':
  #   role        => 'joe',
  #   ...
  #   object_type => 'TABLE',
  #   object_name => [$schema, $table],
  # }
  case $_object_name {
    Array:   {
      $_togrant_object = join($_object_name, '"."')
      # Never put double quotes into has_*_privilege function
      $_granted_object = join($_object_name, '.')
    }
    default: {
      $_granted_object = $_object_name
      $_togrant_object = $_object_name
    }
  }

  $_unless = $unless_function ? {
      false    => undef,
      'custom' => $custom_unless,
      default  => "SELECT 1 WHERE ${unless_function}('${role}',
                  '${_granted_object}', '${unless_privilege}') = ${unless_is}",
  }

  $_onlyif = $onlyif_function ? {
    'table_exists'    => "SELECT true FROM pg_tables WHERE tablename = '${_togrant_object}'",
    'language_exists' => "SELECT true from pg_language WHERE lanname = '${_togrant_object}'",
    'role_exists'     => "SELECT 1 FROM pg_roles WHERE rolname = '${role}'",
    default           => undef,
  }

  $grant_cmd = sprintf($sql_command, $_privilege, $_object_type, $_togrant_object, $role)

  postgresql_psql { "grant:${name}":
    command          => $grant_cmd,
    db               => $on_db,
    port             => $port_override,
    connect_settings => $connect_settings,
    psql_user        => $psql_user,
    psql_group       => $group,
    psql_path        => $psql_path,
    unless           => $_unless,
    onlyif           => $_onlyif,
  }

  if($role != undef and defined(Postgresql::Server::Role[$role])) {
    Postgresql::Server::Role[$role]->Postgresql_psql["grant:${name}"]
  }

  if($db != undef and defined(Postgresql::Server::Database[$db])) {
    Postgresql::Server::Database[$db]->Postgresql_psql["grant:${name}"]
  }
}
