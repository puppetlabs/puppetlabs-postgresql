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
  $datadir = $postgresql::params::datadir,
  $initdb_path = $postgresql::params::initdb_path,
  $user = 'postgres',
  $group = 'postgres',
  $encoding = 'UTF8',
  $options=''
) inherits postgresql::params {

  exec {"${initdb_path} --encoding '$encoding' --pgdata '$datadir'":
    creates => "${datadir}/PG_VERSION",
    user    => "$user",
    group   => "$group",
  }
}
