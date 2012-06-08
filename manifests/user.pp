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

define postgresql::user($username=$title, $password, $version='9.1', $db = 'postgres', $createdb=false, $superuser=false, $createrole=false) {
  postgresql::role {$username:
    db         => $db,
    password   => $password,
    version    => $version,
    login      => true,
    createdb   => $createdb,
    superuser  => $superuser,
    createrole => $createrole,
  }
}
