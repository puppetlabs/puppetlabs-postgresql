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

class postgresql_tests::test_grant_select($user, $password, $db, $table, $version = '8.4') {

  package {"postgresql-$version": 
    ensure => present,
  }

  service {"postgresql-$version":
    ensure  => running,
    require => Package["postgresql-$version"],
  }

  # Since we are not testing pg_hba or any of that, make a local user for ident auth
  user { $user:
    ensure => present,
  }

  postgresql::user { $user:
    password => $password,
    version  => $version,
    require  => [ Service["postgresql-$version"],
                  User[$user] ],
  }

  postgresql::psql { "CREATE TABLE $table (foo int)":
    version => $version,
    db      => $db,
    unless  => "SELECT tablename from pg_tables where tablename = '$table'",
  }

  postgresql::grant { "GRANT SELECT ON $table TO $user":
    version   => $version,
    perm      => 'SELECT',
    grantee   => $user,
    on_object => $table,
    user      => 'postgres',
    require   => [ Postgresql::Psql["CREATE TABLE $table (foo int)"],
                   Postgresql::User[$user] ]
  }
}
