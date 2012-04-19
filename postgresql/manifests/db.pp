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

define postgresql::db(
  $dbname = $title,
  $version = '9.1',
  $encoding = 'UTF8',
  $options='' )
{
  # TODO: This should be found based on the operating system; currently hardcoded to Ubuntu's path choice
  exec {"/usr/lib/postgresql/${version}/bin/createdb --encoding '$encoding' '$dbname'":
    unless  => "/usr/lib/postgresql/${version}/bin/psql --command=\"SELECT datname FROM pg_database WHERE datname=\'$dbname\' \" --pset=tuples_only | grep -q $dbname",
    user    => 'postgres',
  }
}
