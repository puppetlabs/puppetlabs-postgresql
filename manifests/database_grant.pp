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
define postgresql::database_grant(
  $privilege,
  $db,
  $role,
  $psql_db   = undef,
  $psql_user = undef
) {
  include postgresql::params
  postgresql::grant { "database:${name}":
    role        => $role,
    db          => $db,
    privilege   => $privilege,
    object_type => 'DATABASE',
    object_name => $db,
    psql_db     => $psql_db,
    psql_user   => $psql_user,
  }
}
