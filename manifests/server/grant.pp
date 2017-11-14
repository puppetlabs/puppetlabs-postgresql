# Define for granting permissions to roles. See README.md for more details.
define postgresql::server::grant (
  String $role,
  String $db,
  Optional[String] $privilege      = undef,
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
  String $dialect                  = $postgresql::server::dialect,
  Boolean $refreshonly             = $postgresql::server::refreshonly,
  Hash $connect_settings           = $postgresql::server::default_connect_settings,
) {

  $group     = $postgresql::server::group
  $psql_path = $postgresql::server::psql_path

  $_lowercase_role = downcase($role)
  if ($_lowercase_role =~ /^group (.*)/ and $dialect != 'redshift') {
    fail('GROUP syntax is only available in the Redshift dialect')
  }

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
          '^$',
          '^CONNECT$',
          '^CREATE$',
          '^TEMP$',
          '^TEMPORARY$'
        ]                => $_privilege,
        default          => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_database_privilege'
      $on_db = $psql_db
      $onlyif_function = undef
    }
    'SCHEMA': {
      $unless_privilege = $_privilege ? {
        'ALL'            => 'CREATE',
        'ALL PRIVILEGES' => 'CREATE',
        Pattern[
          '^$',
          '^CREATE$',
          '^USAGE$'
        ]                => $_privilege,
        default          => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_schema_privilege'
      $on_db = $db
      $onlyif_function = undef
    }
    'SEQUENCE': {
      if $dialect == 'redshift' {
        fail('redshift does not support sequences (object_type: SEQUENCE)')
      }
      $unless_privilege = $_privilege ? {
        'ALL'   => 'USAGE',
        Pattern[
          '^$',
          '^ALL PRIVILEGES$',
          '^SELECT$',
          '^UPDATE$',
          '^USAGE$'
        ]       => $_privilege,
        default => fail('Illegal value for $privilege parameter'),
      }
      $unless_function = 'has_sequence_privilege'
      $on_db = $db
      $onlyif_function = undef
    }
    'ALL SEQUENCES IN SCHEMA': {
      if $dialect == 'redshift' {
        fail('redshift does not support sequences (object_type: ALL SEQUENCES IN SCHEMA)')
      }
      case $_privilege {
        Pattern[
          '^$',
          '^ALL$',
          '^ALL PRIVILEGES$',
          '^SELECT$',
          '^UPDATE$',
          '^USAGE$'
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
      $custom_unless = "SELECT 1 FROM (
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
                     (regexp_split_to_array(regexp_replace(privs,E'/.*',''),'='))[1] AS grantee,
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
        AND privilege_type='${_privilege}'
        ) P
        HAVING count(P.sequence_name) = 0"
    }
    'TABLE': {
      $unless_privilege = $_privilege ? {
        'ALL'   => 'INSERT',
        Pattern[
          '^$',
          '^ALL$',
          '^ALL PRIVILEGES$',
          '^DELETE$',
          '^REFERENCES$',
          '^SELECT$',
          '^TRIGGER$',
          '^TRUNCATE$',
          '^UPDATE$'
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
          '^$',
          '^ALL$',
          '^ALL PRIVILEGES$',
          '^DELETE$',
          '^INSERT$',
          '^REFERENCES$',
          '^SELECT$',
          '^TRIGGER$',
          '^TRUNCATE$',
          '^UPDATE$'
        ]:       { }
        default: { fail('Illegal value for $privilege parameter') }
      }
      $unless_function = 'custom'
      $on_db = $db
      $onlyif_function = undef

      $schema = $object_name

      # Again there seems to be no easy way in plain SQL to check if ALL
      # PRIVILEGES are granted on a table. By convention we use INSERT
      # here to represent ALL PRIVILEGES (truly terrible).
      $custom_privilege = $_privilege ? {
        'ALL'            => 'INSERT',
        'ALL PRIVILEGES' => 'INSERT',
        default          => $_privilege,
      }

      # This checks if there is a difference between the tables in the
      # specified schema and the tables for which the role has the specified
      # privilege. It uses the EXCEPT clause which computes the set of rows
      # that are in the result of the first SELECT statement but not in the
      # result of the second one. It then counts the number of rows from this
      # operation. If this number is zero then the role has the specified
      # privilege for all tables in the schema and the whole query returns a
      # single row, which satisfies the `unless` parameter of Postgresql_psql.
      # If this number is not zero then there is at least one table for which
      # the role does not have the specified privilege, making it necessary to
      # execute the GRANT statement.
      $custom_unless = "SELECT 1 FROM (
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema='${schema}'
          EXCEPT DISTINCT
        SELECT table_name
        FROM information_schema.role_table_grants
        WHERE grantee='${role}'
        AND table_schema='${schema}'
        AND privilege_type='${custom_privilege}'
        ) P
        HAVING count(P.table_name) = 0"
    }
    'LANGUAGE': {
      $unless_privilege = $_privilege ? {
        'ALL'            => 'USAGE',
        'ALL PRIVILEGES' => 'USAGE',
        Pattern[
          '^$',
          '^CREATE$',
          '^USAGE$'
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
      $_schema = $_object_name[0]
      $_relation = $_object_name[1]
    }
    default: {
      $_granted_object = $_object_name
      $_togrant_object = $_object_name
      $_schema = $_object_name
      $_relation = '%'
    }
  }

  if ($dialect == 'redshift' and ($_lowercase_role =~ /^group (.*)/ or $_object_type == 'ALL TABLES IN SCHEMA')) {
    # Built-in functions such as has_table_privilege don't work on
    # groups in Redshift at this writing. Similarly,
    # information_schema role tables do not appear to be consistently
    # kept up to date. We can extract aclitem[] information from
    # pg_default_acl or pg_namespace, but it seems pg_class no longer
    # exposes its relacl attribute. As such, we warn when we cannot
    # select a suitable UNLESS strategy, allowing the consumer to
    # update their catalog runs accordingly.
    #
    # See https://docs.aws.amazon.com/redshift/latest/dg/c_unsupported-postgresql-functions.html
    # for why we can't use the same custom loop as for postgres.
    if $_object_type == 'SCHEMA' {
      $_custom_unless = "SELECT 1 WHERE EXISTS (
      SELECT nsp.oid
        from
         pg_namespace nsp
        WHERE nsp.nspname = '${_schema}')
      AND FALSE != ALL (SELECT charindex('USAGE',
              case when charindex('r',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'SELECT' else '' end
            ||case when charindex('w',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'UPDATE' else '' end
            ||case when charindex('a',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'INSERT' else '' end
            ||case when charindex('d',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'DELETE' else '' end
            ||case when charindex('R',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'RULE' else '' end
            ||case when charindex('x',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'REFERENCES' else '' end
            ||case when charindex('t',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'TRIGGER' else '' end
            ||case when charindex('X',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'EXECUTE' else '' end
            ||case when charindex('U',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'USAGE' else '' end
            ||case when charindex('C',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'CREATE' else '' end
            ||case when charindex('T',split_part(split_part(array_to_string(nspacl, '|'),'${_lowercase_role}',2 ) ,'/',1)) > 0 then 'TEMPORARY' else '' end) > 0
      from
        pg_namespace nsp
      WHERE
        nsp.nspname = '${_schema}')"
      $_unless = $_custom_unless
    } else {
      warning('pg_class does not expose enough information to provide an UNLESS statement. Please ensure your code only runs this statement on catalog refresh!')
      $_unless = undef
    }
  } else {
    $_unless = $unless_function ? {
        false    => undef,
        'custom' => $custom_unless,
        default  => "SELECT 1 WHERE ${unless_function}('${role}',
                    '${_granted_object}', '${unless_privilege}')",
    }
  }

  $_onlyif = $onlyif_function ? {
    'table_exists'    => "SELECT true FROM pg_tables WHERE tablename = '${_togrant_object}'",
    'language_exists' => "SELECT true from pg_language WHERE lanname = '${_togrant_object}'",
    default           => undef,
  }

  if ($role =~ /^group (.*)/) {
    $_quoted_role = "group \"${1}\""
  } else {
    $_quoted_role = "\"${role}\""
  }

  $grant_cmd = "GRANT ${_privilege} ON ${_object_type} \"${_togrant_object}\" TO
      ${_quoted_role}"
  postgresql_psql { "${title}: grant:${name}":
    command          => $grant_cmd,
    db               => $on_db,
    port             => $port_override,
    connect_settings => $connect_settings,
    psql_user        => $psql_user,
    psql_group       => $group,
    psql_path        => $psql_path,
    unless           => $_unless,
    onlyif           => $_onlyif,
    refreshonly      => $refreshonly,
    require          => Class['postgresql::server']
  }

  if ($role != undef) {
    if ($_lowercase_role =~ /^group (.*)/) {
      Postgresql::Server::Dbgroup<| |> -> Postgresql_psql["${title}: grant:${name}"]
    } else {
      Postgresql::Server::Role<| |> -> Postgresql_psql["${title}: grant:${name}"]
    }
  }

  if ($db != undef) {
    Postgresql::Server::Database<| |> -> Postgresql_psql["${title}: grant:${name}"]
  }
}
