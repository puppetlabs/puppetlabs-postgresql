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

class postgresql_tests::test_db($db, $version = '8.4') {

  package {"postgresql-$version": 
    ensure => present,
  }

  service {"postgresql-$version":
    ensure  => running,
    require => Package["postgresql-$version"],
  }

  postgresql::db { $db:
    version  => $version,
    encoding => 'SQL_ASCII', # Unfortunately, this puppet module will not make the package install with UTF-8 encoding
    require  => Service["postgresql-$version"],
  }
}
