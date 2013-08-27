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
  $password_hash    = false,
  $createdb         = false,
  $createrole       = false,
  $db               = 'postgres',
  $login            = false,
  $superuser        = false,
  $replication      = false,
  $connection_limit = '-1',
  $username         = $title
) {
  include postgresql::params

  $login_sql       = $login       ? { true => 'LOGIN'       , default => 'NOLOGIN' }
  $createrole_sql  = $createrole  ? { true => 'CREATEROLE'  , default => 'NOCREATEROLE' }
  $createdb_sql    = $createdb    ? { true => 'CREATEDB'    , default => 'NOCREATEDB' }
  $superuser_sql   = $superuser   ? { true => 'SUPERUSER'   , default => 'NOSUPERUSER' }
  $replication_sql = $replication ? { true => 'REPLICATION' , default => '' }
  if ($password_hash != false) {
    $password_sql = "ENCRYPTED PASSWORD '${password_hash}'"
  } else {
    $password_sql = ''
  }

  Postgresql_psql {
    db         => $db,
    psql_user  => $postgresql::params::user,
    psql_group => $postgresql::params::group,
    psql_path  => $postgresql::params::psql_path,
    require    => Postgresql_psql["CREATE ROLE \"${username}\" ${password_sql} ${login_sql} ${createrole_sql} ${createdb_sql} ${superuser_sql} ${replication_sql} CONNECTION LIMIT ${connection_limit}"],
  }

  postgresql_psql {"CREATE ROLE \"${username}\" ${password_sql} ${login_sql} ${createrole_sql} ${createdb_sql} ${superuser_sql} ${replication_sql} CONNECTION LIMIT ${connection_limit}":
    unless  => "SELECT rolname FROM pg_roles WHERE rolname='${username}'",
    require => undef,
  }

  postgresql_psql {"ALTER ROLE \"${username}\" ${superuser_sql}":
    unless => "SELECT rolname FROM pg_roles WHERE rolname='${username}' and rolsuper=${superuser}",
  }

  postgresql_psql {"ALTER ROLE \"${username}\" ${createdb_sql}":
    unless => "SELECT rolname FROM pg_roles WHERE rolname='${username}' and rolcreatedb=${createdb}",
  }

  postgresql_psql {"ALTER ROLE \"${username}\" ${createrole_sql}":
    unless => "SELECT rolname FROM pg_roles WHERE rolname='${username}' and rolcreaterole=${createrole}",
  }

  postgresql_psql {"ALTER ROLE \"${username}\" ${login_sql}":
    unless => "SELECT rolname FROM pg_roles WHERE rolname='${username}' and rolcanlogin=${login}",
  }

  if(versioncmp($postgresql::params::version, '9.1') >= 0) {
    postgresql_psql {"ALTER ROLE \"${username}\" ${replication_sql}":
      unless => "SELECT rolname FROM pg_roles WHERE rolname='${username}' and rolreplication=${replication}",
    }
  }

  postgresql_psql {"ALTER ROLE \"${username}\" CONNECTION LIMIT ${connection_limit}":
    unless => "SELECT rolname FROM pg_roles WHERE rolname='${username}' and rolconnlimit=${connection_limit}",
  }

  if $password_hash {
    if($password_hash =~ /^md5.+/) {
      $pwd_hash_sql = $password_hash
    } else {
      $pwd_md5 = md5("${password_hash}${username}")
      $pwd_hash_sql = "md5${pwd_md5}"
    }
    postgresql_psql {"ALTER ROLE \"${username}\" ${password_sql}":
      unless => "SELECT usename FROM pg_shadow WHERE usename='${username}' and passwd='${pwd_hash_sql}'",
    }
  }
}
