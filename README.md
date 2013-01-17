Transferred from Inkling
========================

This Puppet module was originally authored by Inkling Systems. The maintainer preferred
that Puppet Labs take ownership of the module for future improvement and maintenance as
Puppet Labs is using it in the PuppetDB module.  Existing pull requests and issues were
transferred over, please fork and continue to contribute here instead of Inkling.
Previously: https://github.com/inkling/puppet-postgresql 

Puppet module for PostgreSQL resources
======================================

This module provides the following classes and types for managing postgres:

 * `postgresql::server`
 * `postgresql::client`
 * `postgresql::db`
 * `postgresql::database`
 * `postgresql::role`
 * `postgresql::database_user` (just for clarity; users are roles in postgres)
 * `postgresql::database_grant`
 * `postgresql::initdb`

And the fallback, analogous to exec resources, only for SQL statements:

 * `postgresql_psql`

Basic usage
-----------

Manage a PostgreSQL server with sane defaults (login via `sudo -u postgres psql`):

```Puppet
include postgresql::server
```

...or a custom configuration:

```Puppet
class { 'postgresql::server':
    config_hash => {
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users'    => '0.0.0.0/0',
        'listen_addresses'           => '*',
        'ipv4acls'                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
        'manage_redhat_firewall'     => true,
        'postgres_password'          => 'TPSrep0rt!',
    },
}
```

Simple management of a database and user:

```Puppet
postgresl::db { 'mydatabasename':
   user     => 'mydatabaseuser',
   password => 'mypassword'
}
```

Manage users / roles and permissions:

```Puppet
postgresql::database_user{'marmot':
    password => 'foo',
}

postgresql::database_grant{'grant select to marmot':
   grantee   => 'marmot',
   on_object => 'my_table',
   perm      => 'select',
   require   => Postgresql::User['marmot'],
}
```

etc, etc.


Automated testing
-----------------

Install and setup an [RVM](http://beginrescueend.com/) with 
[vagrant](http://vagrantup.com/), 
[sahara](https://github.com/jedi4ever/sahara), and 
[rspec](http://rspec.info/)

    $ curl -L get.rvm.io | bash -s stable
    $ rvm install 1.9.3
    $ rvm use --create 1.9.3@puppet-postgresql
    $ gem install vagrant sahara rspec

Run the tests like so:

    $ (cd spec; vagrant up)
    $ rspec -f -d -c

The test suite will snapshot the VM and rollback between each test.

Next, take a look at the manifests used for the automated tests.

    spec/
        test_module/
            manifests/
                test_*.pp


Contributors
------------

 * Andrew Moon
 * [Kenn Knowles](https://github.com/kennknowles) ([@kennknowles](https://twitter.com/KennKnowles))
 * Adrien Thebo
 * Albert Koch
 * Andreas Ntaflos
 * Brett Porter
 * Chris Price
 * dharwood
 * Etienne Pelletier
 * Florin Broasca
 * Henrik
 * Hunter Haugen
 * Jari Bakken
 * Jordi Boggiano
 * Ken Barber
 * nzakaria
 * Richard Arends
 * Spenser Gilliland
 * stormcrow
 * William Van Hevelingen


Copyright and License
---------------------

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
