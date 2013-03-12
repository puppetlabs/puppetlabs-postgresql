# puppet-postgresql
# For all details and documentation:
# http://github.com/inkling/puppet-postgresql
#
# Copyright 2012- Inkling Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

define postgresql::role(
    $ensure      = 'present',
    $password_hash,
    $createdb    = false,
    $createrole  = false,
    $db          = 'postgres',
    $login       = false,
    $superuser   = false,
    $replication = false,
    $username    = $title
) {
  include postgresql::params

  $login_sql       = $login       ? { true => 'LOGIN'       , default => 'NOLOGIN' }
  $createrole_sql  = $createrole  ? { true => 'CREATEROLE'  , default => 'NOCREATEROLE' }
  $createdb_sql    = $createdb    ? { true => 'CREATEDB'    , default => 'NOCREATEDB' }
  $superuser_sql   = $superuser   ? { true => 'SUPERUSER'   , default => 'NOSUPERUSER' }
  $replication_sql = $replication ? { true => 'REPLICATION' , default => '' }

  if ( $ensure == 'present' ) {
    # TODO: FIXME: Will not correct the superuser / createdb / createrole / login / replication status of a role that already exists
    postgresql::psql {"CREATE ROLE \"${username}\" ENCRYPTED PASSWORD '${password_hash}' ${login_sql} ${createrole_sql} ${createdb_sql} ${superuser_sql} ${replication_sql}":
      db        => $db,
      psql_user => $postgresql::params::user,
      unless    => "SELECT rolname FROM pg_roles WHERE rolname='${username}'",
    }
  } else {
    # Absent: Need to re-assign all database objects owned by role to be dropped to superuser
    postgresql::psql {"REASSIGN OWNED BY ${username} TO ${$postgresql::params::user}":
      db        => $db,
      psql_user => $postgresql::params::user,
      onlyif    => "SELECT rolname FROM pg_roles WHERE rolname='${username}'",
    } ~>

    # TODO: FIXME:
    # Now that all objects are re-assigned, we need to drop the privileges.
    # This is really dangerous. It will only be executed once the objects are re-assigned, however,
    # I'd like to do a check to make sure that ony privilege objects are left to be dropped.
    postgresql::psql {"DROP OWNED BY ${username}":
      db          => $db,
      psql_user   => $postgresql::params::user,
      refreshonly => true,
#      unless      => "SELECT '${username}', datname, array(select privs from unnest(ARRAY[( CASE WHEN has_database_privilege('${username}',c.oid,'CONNECT') THEN 'CONNECT' ELSE NULL END), (CASE WHEN has_database_privilege('${username}',c.oid,'CREATE') THEN 'CREATE' ELSE NULL END), (CASE WHEN has_database_privilege('${username}',c.oid,'TEMPORARY') THEN 'TEMPORARY' ELSE NULL END), (CASE WHEN has_database_privilege('${username}',c.oid,'TEMP') THEN 'CONNECT' ELSE NULL END)])foo(privs) WHERE privs IS NOT NULL) FROM pg_database c WHERE has_database_privilege('${username}',c.oid,'CONNECT,CREATE,TEMPORARY,TEMP') AND datname != 'template0'",
    } ~>

    postgresql::psql {"DROP ROLE IF EXISTS \"${username}\"":
      db          => $db,
      refreshonly => true,
      psql_user   => $postgresql::params::user,
    }
  }
}
