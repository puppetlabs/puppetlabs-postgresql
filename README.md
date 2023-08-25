# postgresql

#### Table of Contents

1. [Module Description - What does the module do?](#module-description)
2. [Setup - The basics of getting started with postgresql module](#setup)
    * [What postgresql affects](#what-postgresql-affects)
    * [Getting started with postgresql](#getting-started-with-postgresql)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Configure a server](#configure-a-server)
    * [Create a database](#create-a-database)
    * [Manage users, roles, and permissions](#manage-users-roles-and-permissions)
    * [Manage ownership of DB objects](#manage-ownership-of-db-objects)
    * [Override defaults](#override-defaults)
    * [Create an access rule for pg_hba.conf](#create-an-access-rule-for-pg_hbaconf)
    * [Create user name maps for pg_ident.conf](#create-user-name-maps-for-pg_identconf)
    * [Validate connectivity](#validate-connectivity)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributors - List of module contributors](#contributors)
7. [Tests](#tests)
8. [Contributors - List of module contributors](#contributors)

## Module description

The postgresql module allows you to manage PostgreSQL databases with Puppet.

PostgreSQL is a high-performance, free, open-source relational database server. The postgresql module allows you to manage packages, services, databases, users, and common security settings in PostgreSQL.

## Setup

### What postgresql affects

* Package, service, and configuration files for PostgreSQL
* Listened-to ports
* IP and mask (optional)

### Getting started with postgresql

To configure a basic default PostgreSQL server, declare the `postgresql::server` class.

```puppet
class { 'postgresql::server':
}
```

## Usage

### Configure a server

For default settings, declare the `postgresql::server` class as above. To customize PostgreSQL server settings, specify the [parameters](#postgresqlserver) you want to change:

```puppet
class { 'postgresql::server':
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  ipv4acls                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
  postgres_password          => 'TPSrep0rt!',
}
```

After configuration, test your settings from the command line:

```shell
psql -h localhost -U postgres
psql -h my.postgres.server -U
```

If you get an error message from these commands, your permission settings restrict access from the location you're trying to connect from. Depending on whether you want to allow connections from that location, you might need to adjust your permissions.

For more details about server configuration parameters, consult the [PostgreSQL Runtime Configuration documentation](http://www.postgresql.org/docs/current/static/runtime-config.html).

### Create a database

You can set up a variety of PostgreSQL databases with the `postgresql::server::db` defined type. For instance, to set up a database for PuppetDB:

```puppet
class { 'postgresql::server':
}

postgresql::server::db { 'mydatabasename':
  user     => 'mydatabaseuser',
  password => postgresql::postgresql_password('mydatabaseuser', 'mypassword'),
}
```

### Manage users, roles, and permissions

To manage users, roles, and permissions:

```puppet
class { 'postgresql::server':
}

postgresql::server::role { 'marmot':
  password_hash => postgresql::postgresql_password('marmot', 'mypasswd'),
}

postgresql::server::database_grant { 'test1':
  privilege => 'ALL',
  db        => 'test1',
  role      => 'marmot',
}

postgresql::server::table_grant { 'my_table of test2':
  privilege => 'ALL',
  table     => 'my_table',
  db        => 'test2',
  role      => 'marmot',
}
```

This example grants **all** privileges on the test1 database and on the `my_table` table of the test2 database to the specified user or group. After the values are added into the PuppetDB config file, this database would be ready for use.

### Manage ownership of DB objects

To change the ownership of all objects within a database using REASSIGN OWNED:

```puppet
postgresql::server::reassign_owned_by { 'new owner is meerkat':
  db       => 'test_db',
  old_role => 'marmot',
  new_role => 'meerkat',
}
```

This would run the PostgreSQL statement 'REASSIGN OWNED' to update to ownership of all tables, sequences, functions and views currently owned by the role 'marmot' to be owned by the role 'meerkat' instead.

This applies to objects within the nominated database, 'test_db' only.

For Postgresql >= 9.3, the ownership of the database is also updated.

### Override defaults

The `postgresql::globals` class allows you to configure the main settings for this module globally, so that other classes and defined resources can use them. By itself, it does nothing.

For example, to overwrite the default `locale` and `encoding` for all classes, use the following:

```puppet
class { 'postgresql::globals':
  encoding => 'UTF-8',
  locale   => 'en_US.UTF-8',
}

class { 'postgresql::server':
}
```

To use a specific version of the PostgreSQL package:

```puppet
class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.2',
}

class { 'postgresql::server':
}
```

### Manage remote users, roles, and permissions

Remote SQL objects are managed using the same Puppet resources as local SQL objects, along with a [`connect_settings`](#connect_settings) hash. This provides control over how Puppet connects to the remote Postgres instances and which version is used for generating SQL commands.

The `connect_settings` hash can contain environment variables to control Postgres client connections, such as 'PGHOST', 'PGPORT', 'PGPASSWORD', and 'PGSSLKEY'. See the [PostgreSQL Environment Variables](http://www.postgresql.org/docs/9.4/static/libpq-envars.html)  documentation for a complete list of variables.

Additionally, you can specify the target database version with the special value of 'DBVERSION'. If the `connect_settings` hash is omitted or empty, then Puppet connects to the local PostgreSQL instance.

You can provide a `connect_settings` hash for each of the Puppet resources, or you can set a default `connect_settings` hash in `postgresql::globals`. Configuring `connect_settings` per resource allows SQL objects to be created on multiple databases by multiple users.

```puppet
$connection_settings_super2 = {
  'PGUSER'     => 'super2',
  'PGPASSWORD' => 'foobar2',
  'PGHOST'     => '127.0.0.1',
  'PGPORT'     => '5432',
  'PGDATABASE' => 'postgres',
}

include postgresql::server

# Connect with no special settings, i.e domain sockets, user postgres
postgresql::server::role { 'super2':
  password_hash    => 'foobar2',
  superuser        => true,

  connect_settings => {},
}

# Now using this new user connect via TCP
postgresql::server::database { 'db1':
  connect_settings => $connection_settings_super2,
  require          => Postgresql::Server::Role['super2'],
}
```

### Create an access rule for pg_hba.conf

To create an access rule for `pg_hba.conf`:

```puppet
postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description => 'Open up PostgreSQL for access from 200.1.2.0/24',
  type        => 'host',
  database    => 'app',
  user        => 'app',
  address     => '200.1.2.0/24',
  auth_method => 'md5',
}
```

This would create a ruleset in `pg_hba.conf` similar to:

```
# Rule Name: allow application network to access app database
# Description: Open up PostgreSQL for access from 200.1.2.0/24
# Order: 150
host  app  app  200.1.2.0/24  md5
```

By default, `pg_hba_rule` requires that you include `postgresql::server`. However, you can override that behavior by setting target and postgresql_version when declaring your rule.  That might look like the following:

```puppet
postgresql::server::pg_hba_rule { 'allow application network to access app database':
  description        => 'Open up postgresql for access from 200.1.2.0/24',
  type               => 'host',
  database           => 'app',
  user               => 'app',
  address            => '200.1.2.0/24',
  auth_method        => 'md5',
  target             => '/path/to/pg_hba.conf',
  postgresql_version => '9.4',
}
```

### Create user name maps for pg_ident.conf

To create a user name map for the pg_ident.conf:

```puppet
postgresql::server::pg_ident_rule { 'Map the SSL certificate of the backup server as a replication user':
  map_name          => 'sslrepli',
  system_username   => 'repli1.example.com',
  database_username => 'replication',
}
```

This would create a user name map in `pg_ident.conf` similar to:

```
#Rule Name: Map the SSL certificate of the backup server as a replication user
#Description: none
#Order: 150
sslrepli  repli1.example.com  replication
```

### Create recovery configuration

To create the recovery configuration file (`recovery.conf`):

```puppet
postgresql::server::recovery { 'Create a recovery.conf file with the following defined parameters':
  restore_command           => 'cp /mnt/server/archivedir/%f %p',
  archive_cleanup_command   => undef,
  recovery_end_command      => undef,
  recovery_target_name      => 'daily backup 2015-01-26',
  recovery_target_time      => '2015-02-08 22:39:00 EST',
  recovery_target_xid       => undef,
  recovery_target_inclusive => true,
  recovery_target           => 'immediate',
  recovery_target_timeline  => 'latest',
  pause_at_recovery_target  => true,
  standby_mode              => 'on',
  primary_conninfo          => 'host=localhost port=5432',
  primary_slot_name         => undef,
  trigger_file              => undef,
  recovery_min_apply_delay  => 0,
}
```

The above creates this `recovery.conf` config file:

```
restore_command = 'cp /mnt/server/archivedir/%f %p'
recovery_target_name = 'daily backup 2015-01-26'
recovery_target_time = '2015-02-08 22:39:00 EST'
recovery_target_inclusive = true
recovery_target = 'immediate'
recovery_target_timeline = 'latest'
pause_at_recovery_target = true
standby_mode = 'on'
primary_conninfo = 'host=localhost port=5432'
recovery_min_apply_delay = 0
```

Only the specified parameters are recognized in the template. The `recovery.conf` is only created if at least one parameter is set **and** [manage_recovery_conf](#manage_recovery_conf) is set to true.

### Validate connectivity

To validate client connections to a remote PostgreSQL database before starting dependent tasks, use the `postgresql_conn_validator` resource. You can use this on any node where the PostgreSQL client software is installed. It is often chained to other tasks such as starting an application server or performing a database migration.

Example usage:

```puppet
postgresql_conn_validator { 'validate my postgres connection':
  host              => 'my.postgres.host',
  db_username       => 'mydbuser',
  db_password       => 'mydbpassword',
  db_name           => 'mydbname',
}->
exec { 'rake db:migrate':
  cwd => '/opt/myrubyapp',
}
```

## Reference

For information on the classes and types, see the [REFERENCE.md](https://github.com/puppetlabs/puppetlabs-postgresql/blob/main/REFERENCE.md)

## Limitations

Works with versions of PostgreSQL on supported OSes.  

For an extensive list of supported operating systems, see [metadata.json](https://github.com/puppetlabs/puppetlabs-postgresql/blob/main/metadata.json)

### Apt module support

While this module supports both 1.x and 2.x versions of the 'puppetlabs-apt' module, it does not support 'puppetlabs-apt' 2.0.0 or 2.0.1.


### PostGIS support

PostGIS is currently considered an unsupported feature, as it doesn't work on all platforms correctly.

### All versions of RHEL/CentOS with manage_selinux => false

If you have SELinux enabled and you are *not* using the selinux module to manage SELinux (this is the default configuration) you will need to label any custom ports you use with the `postgresql_port_t` context.  The postgresql service will not start until this is done.  To label a port use the semanage command as follows:

```shell
semanage port -a -t postgresql_port_t -p tcp $customport
```

## Development

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide](https://puppet.com/docs/puppet/latest/contributing.html).

### Tests

There are two types of tests distributed with this module. Unit tests with `rspec-puppet` and system tests using `rspec-system`.

For unit testing, make sure you have:

* rake
* bundler

Install the necessary gems:

```shell
bundle install --path=vendor
```

And then run the unit tests:

```shell
bundle exec rake spec
```

The unit tests are run in Travis-CI as well. If you want to see the results of your own tests, register the service hook through Travis-CI via the accounts section for your GitHub clone of this project.

To run the system tests, make sure you also have:

* Vagrant > 1.2.x
* VirtualBox > 4.2.10

Then run the tests using:

```shell
bundle exec rspec spec/acceptance
```

To run the tests on different operating systems, see the sets available in `.nodeset.yml` and run the specific set with the following syntax:

```shell
RSPEC_SET=debian-607-x64 bundle exec rspec spec/acceptance
```

### Contributors

View the full list of contributors on [Github](https://github.com/puppetlabs/puppetlabs-postgresql/graphs/contributors).
