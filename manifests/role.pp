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
    $password_hash,
    $createdb   = false,
    $createrole = false,
    $db         = 'postgres',
    $login      = false,
    $superuser  = false,
    $username   = $title
) {
  include postgresql::params

  $login_sql      = $login      ? { true => 'LOGIN'     , default => 'NOLOGIN' }
  $createrole_sql = $createrole ? { true => 'CREATEROLE', default => 'NOCREATEROLE' }
  $createdb_sql   = $createdb   ? { true => 'CREATEDB'  , default => 'NOCREATEDB' }
  $superuser_sql  = $superuser  ? { true => 'SUPERUSER' , default => 'NOSUPERUSER' }

  # TODO: FIXME: Will not correct the superuser / createdb / createrole / login status of a role that already exists
  postgresql_psql {"CREATE ROLE ${username} ENCRYPTED PASSWORD '${password_hash}' $login_sql $createrole_sql $createdb_sql $superuser_sql":
    db           => $db,
    psql_user    => 'postgres',
    unless       => "SELECT rolname FROM pg_roles WHERE rolname='$username'",
    cwd          => $postgresql::params::datadir,
  }
}
