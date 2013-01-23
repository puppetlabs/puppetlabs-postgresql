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

class postgresql::initdb(
  $datadir     = $postgresql::params::datadir,
  $encoding    = 'UTF8',
  $group       = 'postgres',
  $initdb_path = $postgresql::params::initdb_path,
  $user        = 'postgres'
) inherits postgresql::params {

  $datadirparts = split($datadir,'/')
  file { "/${datadirparts[1]}":
    ensure  => directory,
    owner   => $user,
    group   => $group;
  }

  if $postgresql::params::locale == undef {
    $initdb_command = "${initdb_path} --encoding '${encoding}' --pgdata '${datadir}'"
  } else {
    $initdb_command = "${initdb_path} --encoding '${encoding}' --pgdata '${datadir}' --locale '${postgresql::params::locale}'"
  }
  
  exec { $initdb_command:
    creates => "${datadir}/PG_VERSION",
    user    => $user,
    group   => $group
  }

  File["/${datadirparts[1]}"] -> Exec[$initdb_command]

  if defined(Package["$postgresql::params::server_package_name"]) {
    Package["$postgresql::params::server_package_name"] ->
        Exec[$initdb_command]
  }
}
