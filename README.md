# postgresql


#### Table of Contents

1. [Overview - What is the posgresql module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with posgresql module](#setup)
    * [PE Supported module](#supported-module)
    * [Configuring the server](#configuring-the-server)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined Types](#defined-types)
    * [Types](#types)
    * [Functions](#functions)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
    * [Transfer Notice - Notice of authorship change](#transfer-notice)
    * [Contributors - List of module contributors](#contributors)
8. [Tests](#tests)
9. [Transfer Notice - Notice of authorship change](#transfer-notice)
10. [Contributors - List of module contributors](#contributors)

## Overview

The posgresql module allows you to easily manage PostgreSQL databases with Puppet.

## Module description

PostgreSQL is a high-performance, free, open-source relational database server. The posgresql module allows you to manage PostgreSQL packages and services on several operating systems, while also supporting basic management of PostgreSQL databases and users. The module offers support for basic management of common security settings.

## Setup

**What puppetlabs-PostgreSQL affects:**

* package/service/configuration files for PostgreSQL
* listened-to ports
* IP and mask (optional)

**Introductory Questions**

The posgresql module offers many security configuration settings. Before getting started, you will want to consider:

* Do you want or need to allow remote connections?
    * If yes, what about TCP connections?
* How restrictive do you want the database superuser's permissions to be?

Your answers to these questions will determine which of the module's parameters you'll want to specify values for.

### Supported module

Puppet Enterprise 3.2 introduced Puppet Labs supported modules. The version of the posgresql module that ships with PE is supported via normal [Puppet Enterprise support](http://puppetlabs.com/services/customer-support) channels. If you would like to access the [supported module](http://forge.puppetlabs.com/supported) version, you will need to uninstall the shipped module and install the supported version from the Puppet Forge. You can do this by first running

     puppet module uninstall puppetlabs-postgresql

and then running

     puppet module install puppetlabs/postgresql

## Usage

### Configuring the server

The main configuration you'll need to do will be around the `postgresql::server` class. The default parameters are reasonable, but fairly restrictive regarding permissions for who can connect and from where. To manage a PostgreSQL server with defaults:

    class { 'postgresql::server': }

For a more customized configuration:

    class { 'postgresql::server':
      ip_mask_deny_postgres_user => '0.0.0.0/32',
      ip_mask_allow_all_users    => '0.0.0.0/0',
      listen_addresses           => '*',
      ipv4acls                   => ['hostssl all johndoe 192.168.0.0/24 cert'],
      postgres_password          => 'TPSrep0rt!',
    }

Once you've completed your configuration of `postgresql::server`, you can test your settings from the command line:

     psql -h localhost -U postgres
     psql -h my.postgres.server -U

If you get an error message from these commands, it means that your permissions are set in a way that restricts access from where you're trying to connect. That could be a good or bad thing, depending on your goals.

For more details about server configuration parameters consult the [PostgreSQL Runtime Configuration docs](http://www.postgresql.org/docs/current/static/runtime-config.html).

### Creating a database

There are many ways to set up a postgres database using the `postgresql::server::db` defined type. For instance, to set up a database for PuppetDB:

    class { 'postgresql::server': }

    postgresql::server::db { 'mydatabasename':
      user     => 'mydatabaseuser',
      password => postgresql_password('mydatabaseuser', 'mypassword'),
    }

### Managing users, roles and permissions

To manage users, roles and permissions:

    class { 'postgresql::server': }

    postgresql::server::role { 'marmot':
      password_hash => postgresql_password('marmot', 'mypasswd'),
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

In this example, you would grant ALL privileges on the test1 database and on the `my_table` table of the test2 database to the user or group specified by dan.

At this point, you would just need to plunk these database name/username/password values into your PuppetDB config files, and you are good to go.

### Overriding defaults

The `postgresql::globals` class allows you to configure the main settings for this module in a global way, to be used by the other classes and defined resources. On its own it does nothing.

For example, if you wanted to overwrite the default `locale` and `encoding` for all classes you could use the following combination:

    class { 'postgresql::globals':
      encoding => 'UTF-8',
      locale   => 'en_US.UTF-8',
    }->
    class { 'postgresql::server':
    }

If you want to use the upstream PostgreSQL packaging, and be specific about the version you wish to download, you could use something like this:

    class { 'postgresql::globals':
      manage_package_repo => true,
      version             => '9.2',
    }->
    class { 'postgresql::server': }

### Managing remote users, roles and permissions

 Remote SQL objects are managed using the same Puppet resources as local SQL objects with the additional of a connect_settings hash. This provides control over how Puppet should connect to the remote Postgres instances and the version that should be used when generating SQL commands.

 When provided the connect_settings hash can contain environment variables to control Postgres client connections, such as: PGHOST, PGPORT, PGPASSWORD PGSSLKEY (see http://www.postgresql.org/docs/9.4/static/libpq-envars.html) Additionally the special value of DBVERSION can be provided to specify the target database's version. If the connect_settings hash is omitted or empty then Puppet will connect to the local Postgres instance.

 A connect_settings hash can be provided with each of the Puppet resources or a default connect_settings hash can be set in postgresql::globals. Per resource configuration of connect_settings allows for SQL object to be creating on multiple database by multiple users.

     $connection_settings_super2 = {
                                      'PGUSER'     => "super2",
                                      'PGPASSWORD' => "foobar2",
                                      'PGHOST'     => "127.0.0.1",
                                      'PGPORT'     => "5432",
                                      'PGDATABASE' => "postgres",
                                   }

     include postgresql::server

     # Connect with no special settings, i.e domain sockets, user postges
     postgresql::server::role{'super2':
       password_hash => "foobar2",
       superuser => true,

       connect_settings => {},
       require => [
                    Class['postgresql::globals'],
                    Class['postgresql::server::service'],
                  ],
     }

     # Now using this new user connect via TCP
     postgresql::server::database { 'db1':
       connect_settings => $connection_settings_super2,

       require => Postgresql::Server::Role['super2'],
     }

## Reference

The posgresql module comes with many options for configuring the server. While you are unlikely to use all of the settings below, they provide a decent amount of control over your security settings.

Classes:

* [postgresql::client](#postgresqlclient)
* [postgresql::globals](#postgresqlglobals)
* [postgresql::lib::devel](#postgresqllibdevel)
* [postgresql::lib::java](#postgresqllibjava)
* [postgresql::lib::perl](#postgresqllibperl)
* [postgresql::lib::python](#postgresqllibpython)
* [postgresql::server](#postgresqlserver)
* [postgresql::server::plperl](#postgresqlserverplperl)
* [postgresql::server::contrib](#postgresqlservercontrib)
* [postgresql::server::postgis](#postgresqlserverpostgis)

Defined Types:

* [postgresql::server::config_entry](#postgresqlserverconfig_entry)
* [postgresql::server::database](#postgresqlserverdatabase)
* [postgresql::server::database_grant](#postgresqlserverdatabase_grant)
* [postgresql::server::db](#postgresqlserverdb)
* [postgresql::server::extension](#postgresqlserverextension)
* [postgresql::server::pg_hba_rule](#postgresqlserverpg_hba_rule)
* [postgresql::server::pg_ident_rule](#postgresqlserverpg_ident_rule)
* [postgresql::server::recovery](#postgresqlserverrecovery)
* [postgresql::server::role](#postgresqlserverrole)
* [postgresql::server::schema](#postgresqlserverschema)
* [postgresql::server::table_grant](#postgresqlservertable_grant)
* [postgresql::server::tablespace](#postgresqlservertablespace)
* [postgresql::validate_db_connection](#postgresqlvalidate_db_connection)

Types:

* [postgresql_psql](#custom-resource-postgresql_psql)
* [postgresql_replication_slot](#custom-resource-postgresql_replication_slot)
* [postgresql_conf](#custom-resource-postgresql_conf)

Functions:

* [postgresql_password](#function-postgresql_password)
* [postgresql_acls_to_resources_hash](#function-postgresql_acls_to_resources_hashacl_array-id-order_offset)

### Classes

#### postgresql::client
Installs PostgreSQL client software. Alter the following parameters if you have a custom version you would like to install.

>**Note:** Make sure to add any necessary yum or apt repositories if specifying a custom version.

##### `package_ensure`
Sets the ensure parameter passed on to PostgreSQL client package resource. Default: 'present'.

##### `package_name`
Sets the name of the PostgreSQL client package. Default: 'file'.

##### `validcon_script_path`
Specifies the path to validate the connection script. Default: '/usr/local/bin/validate_postgresql_connection.sh'.

#### postgresql::lib::docs
Installs PostgreSQL bindings for Postgres-Docs. Alter the following parameters if you have a custom version you would like to install

>**Note:** Make sure to add any necessary yum or apt repositories if specifying a custom version.

##### `package_name`
Specifies the name of the PostgreSQL docs package.

##### `package_ensure`
The ensure parameter passed on to postgresql docs package resource.


#### postgresql::globals
>**Note:** Most server specific defaults should be overriden in the `postgresql::server` class. This class should only be used if you are using a non-standard OS or if you are changing elements such as `version` or `manage_package_repo` that can only be changed here.

##### `bindir`
Overrides the default PostgreSQL binaries directory for the target platform. Default: OS dependent.

##### `client_package_name`
Overrides the default PostgreSQL client package name. Default: OS dependent.

##### `confdir`
Overrides the default PostgreSQL configuration directory for the target platform. Default: OS dependent.

##### `contrib_package_name`
Overrides the default PostgreSQL contrib package name. Default: OS dependent.

##### `createdb_path`
**Deprecated.**
Path to the `createdb` command. Default: "${bindir}/createdb".

##### `datadir`
Overrides the default PostgreSQL data directory for the target platform. Default: OS dependent.

>**Note:** Changing the datadir after installation will cause the server to come to a full stop before being able to make the change. For RedHat systems, the data directory must be labeled appropriately for SELinux. On Ubuntu, you need to explicitly set `needs_initdb = true` in order to allow Puppet to initialize the database in the new datadir (`needs_initdb` defaults to true on other systems).

**Warning:** If datadir is changed from the default, Puppet will not manage purging of the original data directory, which will cause it to fail if the data directory is changed back to the original.

##### `default_database`
Specifies the name of the default database to connect with. On most systems, this will be "postgres".

##### `devel_package_name`
Overrides the default PostgreSQL devel package name. Default: OS dependent.

##### `docs_package_name`
Overrides the default PostgreSQL docs package name. If not specified, the module will use the default for your OS distro.

##### `encoding`
Sets the default encoding for all databases created with this module. On certain operating systems, this will also be used during the `template1` initialization, so it becomes a default outside of the module as well. Defaults to the operating system's default encoding.

##### `group`
Overrides the default PostgreSQL user group to be used for related files in the file system. Default: 'postgres'.

##### `initdb_path`
Path to the `initdb` command.

##### `java_package_name`
Overrides the default PostgreSQL java package name. Default: OS dependent.

##### `locale`
Sets the default database locale for all databases created with this module. On certain operating systems, this will also be used during the `template1` initialization, so it becomes a default outside of the module as well. Default: undef, which is effectively `C`. **On Debian, you'll need to ensure that the 'locales-all' package is installed for full functionality of PostgreSQL.**

##### `logdir`
Overrides the default PostgreSQL log directory. Default: initdb's default path.

##### `manage_package_repo`
Sets up official PostgreSQL repositories on your host if set to 'true'. Default: 'false'.

##### `needs_initdb`
This setting can be used to explicitly call the initdb operation after server package is installed and before the PostgreSQL service is started. Default: OS dependent.

##### `perl_package_name`
Overrides the default PostgreSQL Perl package name. Default: OS dependent.

##### `pg_hba_conf_defaults`
Disables the defaults supplied with the module for `pg_hba.conf` if set to 'false'. This is useful if you disagree with the defaults and wish to override them yourself. Be sure that your changes of course align with the rest of the module, as some access is required to perform basic `psql` operations for example. Default: 'true'.

##### `pg_hba_conf_path`
Specifies the path to your `pg_hba.conf` file. Default: "${confdir}/pg_hba.conf".

##### `pg_ident_conf_path`
Specifies the path to your `pg_ident.conf` file. Default: "${confdir}/pg_ident.conf".

##### `plperl_package_name`
Overrides the default PostgreSQL PL/perl package name. Default: OS dependent.

##### `plpython_package_name`
Overrides the default PostgreSQL PL/python package name. Default: OS dependent.

##### `postgis_version`
Defines the version of PostGIS to install, if you install PostGIS. Defaults to the lowest available with the version of PostgreSQL to be installed.

##### `postgresql_conf_path`
Sets the path to your `postgresql.conf` file. Default: "${confdir}/postgresql.conf".

##### `psql_path`
Sets the path to the `psql` command.

##### `python_package_name`
Overrides the default PostgreSQL Python package name. Default: OS dependent.

##### `recovery_conf_path`
Path to your `recovery.conf` file.

##### `repo_proxy`
Sets the proxy option for the official PostgreSQL yum-repositories only, Debian is currently not supported. This is useful if your server is behind a corporate firewall and needs to use proxyservers for outside connectivity.

##### `server_package_name`
Overrides the default PostgreSQL server package name. Default: OS dependent.

##### `service_name`
Overrides the default PostgreSQL service name. Default: OS dependent.

##### `service_provider`
Overrides the default PostgreSQL service provider. Default: OS dependent.

##### `service_status`
Overrides the default status check command for your PostgreSQL service. Default: OS dependent.

##### `user`
Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system. Default: 'postgres'.

##### `version`
The version of PostgreSQL to install/manage. This is a simple way of providing a specific version such as '9.2' or '8.4' for example. Default: OS system default.

##### `xlogdir`
Overrides the default PostgreSQL xlog directory. Default: initdb's default path.


####postgresql::lib::devel
Installs the packages containing the development libraries for PostgreSQL and symlinks pg_config into `/usr/bin` (if not in `/usr/bin` or `/usr/local/bin`).

##### `link_pg_config`
By default on all but Debian systems, if the bin directory used by the PostgreSQL package is not `/usr/bin` or `/usr/local/bin`,
this class will symlink `pg_config` from the package's bin dir into `/usr/bin`. Set `link_pg_config` to
false to disable this behavior.

##### `package_ensure`
Overrides the `ensure` parameter during package installation. Defaults to `present`.

##### `package_name`
Overrides the default package name for the distribution you are installing to. Defaults to `postgresql-devel` or `postgresql<version>-devel` depending on your distro.


####postgresql::lib::java
Installs PostgreSQL bindings for Java (JDBC). Alter the following parameters if you have a custom version you would like to install

>**Note:** Make sure to add any necessary yum or apt repositories if specifying a custom version.

##### `package_ensure`
Sets the ensure parameter passed on to PostgreSQL java package resource.

##### `package_name`
Specifies the name of the PostgreSQL java package.


#### postgresql::lib::perl
Installs the PostgreSQL Perl libraries. For customer requirements you can customize the following parameters:

##### `package_ensure`
Sets the ensure parameter passed on to PostgreSQL perl package resource.

##### `package_name`
Specifies the name of the PostgreSQL perl package to install.


#### postgresql::server::plpython
Installs the PL/Python procedural language for PostgreSQL.

##### `package_name`
Specifies the name of the postgresql PL/Python package.

##### `package_ensure`
Specifies the ensure parameter passed on to PostgreSQL PL/Python package resource.


####postgresql::lib::python
Installs PostgreSQL Python libraries. For customer requirements you can customize the following parameters:

##### `package_ensure`
The ensure parameter passed on to PostgreSQL python package resource.

##### `package_name`
The name of the PostgreSQL python package.


####postgresql::server

##### `createdb_path`
**Deprecated.**
Specifies the path to the `createdb` command. Default: "${bindir}/createdb".

##### `default_database`
Specifies the name of the default database to connect with. On most systems this will be "postgres".

##### `encoding`
Sets the default encoding for all databases created with this module. On certain operating systems this will also be used during the `template1` initialization, so it becomes a default outside of the module as well. Default: undef.

##### `group`
Overrides the default PostgreSQL user group to be used for related files in the file system. Default: OS dependent default.

##### `initdb_path`
Specifies the path to the `initdb` command. Default: "${bindir}/initdb".

##### `ipv4acls`
Lists strings for access control for connection method, users, databases, IPv4 addresses; see [postgresql documentation](http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html) about `pg_hba.conf` for information (**Note:** The link will take you to documentation for the most recent version of PostgreSQL, however links for earlier versions can be found there too).

##### `ipv6acls`
Lists strings for access control for connection method, users, databases, IPv6 addresses; see [postgresql documentation](http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html) about `pg_hba.conf` for information (**Note:** The link will take you to documentation for the most recent version of PostgreSQL, however links for earlier versions can be found there too).

##### `ip_mask_allow_all_users`
Overrides PostgreSQL defaults for remote connections. By default, PostgreSQL does not allow database user accounts to connect via TCP from remote machines. If you'd like to allow them to, you can override this setting. You can set it to `0.0.0.0/0` to allow database users to connect from any remote machine, or `192.168.0.0/16` to allow connections from any machine on your local 192.168 subnet. Default: `127.0.0.1/32`.

##### `ip_mask_deny_postgres_user`
Specifies an IP and mask to deny connections from specific users while also allowing remote users. Sometimes it can be useful to block the superuser account from remote connections if you are allowing other database users to connect remotely. For example, the default value `0.0.0.0/0` will match any remote IP and deny access, so the postgres user won't be able to connect remotely at all. Conversely, a value of `0.0.0.0/32` would not match any remote IP, and thus the deny rule will not be applied and the postgres user will be allowed to connect. Default: `0.0.0.0/0`.

##### `listen_addresses`
This value defaults to `localhost`, meaning the postgres server will only accept connections from localhost. If you'd like to be able to connect to postgres from remote machines, you can override this setting. A value of `*` will tell postgres to accept connections from any remote machine. Alternately, you can specify a comma-separated list of hostnames or IP addresses. (For more info, have a look at the `postgresql.conf` file from your system's postgres package).

##### `locale`
Sets the default database locale for all databases created with this module. On certain operating systems this will be used during the `template1` initialization as well so it becomes a default outside of the module as well. Default: undef, which is effectively `C`. **On Debian, you'll need to ensure that the 'locales-all' package is installed for full functionality of PostgreSQL.**

##### `manage_pg_hba_conf`
This value defaults to `true`. Whether or not manage the pg_hba.conf. If set to `true`, puppet will overwrite this file. If set to `false`, puppet will not modify the file.

##### `manage_pg_ident_conf`
Overwrites the pg_ident.conf file. If set to `true`, Puppet will overwrite the file. If set to `false`, Puppet will not modify the file. Default: `true`.

##### `manage_recovery_conf`
Specifies whether or not manage the recovery.conf. If set to `true`, Puppet will overwrite this file. If set to `false`, Puppet will not create the file. Default: `false`.

##### `needs_initdb`
Explicitly calls the `initdb` operation after server package is installed, and before the PostgreSQL service is started. Default: OS dependent.

##### `package_ensure`
Passes a value through to the `package` resource when creating the server instance. Default: undef.

##### `package_name`
Specifies the name of the package to use for installing the server software. Default: OS dependent.

##### `pg_hba_conf_defaults`
If false, disables the defaults supplied with the module for `pg_hba.conf`. This is useful if you disagree with the defaults and wish to override them yourself. Be sure that your changes of course align with the rest of the module, as some access is required to perform basic `psql` operations for example.

##### `pg_hba_conf_path`
Specifies the path to your `pg_hba.conf` file.

##### `pg_ident_conf_path`
Specifies the path to your `pg_ident.conf` file. Default: "${confdir}/pg_ident.conf".

##### `plperl_package_name`
Sets the default package name for the PL/Perl extension. Default: OS dependent.

##### `plpython_package_name`
Sets the default package name for the PL/Python extension. Default: OS dependent.

##### `port`
Specifies the port for the PostgreSQL server to listen on. **Note:** The same port number is used for all IP addresses the server listens on. Also, for RedHat systems and early Debian systems, changing the port will cause the server to come to a full stop before being able to make the change. Default: `5432`, meaning the postgres server will listen on TCP port 5432.

##### `postgres_password`
Sets the password for the `postgres` user to your specified value. Default: undef, meaning the superuser account in the postgres database is a user called `postgres` and this account does not have a password.

##### `postgresql_conf_path`
Specifies the path to your `postgresql.conf` file. Default: "${confdir}/postgresql.conf".

##### `psql_path`
Specifies the path to the `psql` command. Default: OS dependent.

##### `service_manage`
Defines whether or not Puppet should manage the service. Default: `true`.

##### `service_name`
Overrides the default PostgreSQL service name. Default: OS dependent.

##### `service_provider`
Overrides the default PostgreSQL service provider. Default: undef.

##### `service_reload`
Overrides the default reload command for your PostgreSQL service. Default: OS dependent.

##### `service_restart_on_change`
Overrides the default behavior to restart your PostgreSQL service when a config entry has been changed that requires a service restart to become active. Default: `true`.

##### `service_status`
Overrides the default status check command for your PostgreSQL service. Default: OS dependent.

##### `user`
Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system. Default: 'postgres'.


#### postgresql::server::contrib
Installs the PostgreSQL contrib package.

##### `package_ensure`
Sets the ensure parameter passed on to PostgreSQL contrib package resource.

##### `package_name`
The name of the PostgreSQL contrib package.


#### postgresql::server::plperl
Installs the PL/Perl procedural language for postgresql.

##### `package_ensure`
The ensure parameter passed on to PostgreSQL PL/Perl package resource.

##### `package_name`
The name of the PostgreSQL PL/Perl package.


#### postgresql::server::postgis
Installs the PostgreSQL postgis packages.


### Defined Types

#### postgresql::server::config_entry
Modifies your `postgresql.conf` configuration file.

Each resource maps to a line inside the file, for example:

    postgresql::server::config_entry { 'check_function_bodies':
      value => 'off',
    }

##### `ensure`
Removes an entry if set to `absent`.

##### `namevar`
Specifies the name of the setting to change.

##### `value`
Defines the value for the setting.


#### postgresql::server::db
Creates a local database, user, and assigns necessary permissions, in one go.

For example, to create a database called `test1` with a corresponding user of the same name, you can use:

    postgresql::server::db { 'test1':
      user     => 'test1',
      password => 'test1',
    }

##### `comment`
Defines a comment to be stored about the database using the PostgreSQL COMMENT command.

##### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. Default: Connects to the local Postgres instance.

##### `dbname`
Sets the name of the database to be created. Default: `namevar`.

##### `encoding`
Overrides the character set during creation of the database. Defaults to the default defined during installation.

##### `grant`
Specifies the permissions to grant during creation. Default: `ALL`.

##### `istemplate`
Specifies that the database is a template, if set to `true`. Default: `false`.

##### `locale`
Overrides the locale during creation of the database. Defaults to the default defined during installation.

##### `namevar`
Designates the name of the database.

##### `owner`
Sets a user as the owner of the database. Default: $user variable set in `postgresql::server` or `postgresql::globals`.

##### `password`
Sets the password for the created user. Mandatory.

##### `tablespace`
Defines the name of the tablespace to allocate the created database to. Default: PostgreSQL default.

##### `template`
Specifies the name of the template database from which to build this database. Defaults to `template0`.

##### `user`
User to create and assign access to the database upon creation. Mandatory.


#### postgresql::server::database
Used to create a database with no users and no permissions, which is a rare use case.

##### `dbname`
Sets the name of the database, defaults to the `namevar`.

##### `encoding`
Overrides the character set during creation of the database. Default: The default defined during installation.

##### `istemplate`
Defines the database as a template if set to true. Default: `false`.

##### `locale`
Overrides the locale during creation of the database. DefaultThe default defined during installation.

##### `namevar`
Specifies the name of the database to create.

##### `owner`
Sets name of the database user who will be set as the owner of the database. Default: The $user variable set in `postgresql::server` or `postgresql::globals`.

##### `tablespace`
Sets tablespace for where to create this database. Default: The defaults defined during PostgreSQL installation.

##### `template`
Specifies the name of the template database from which to build this database. Default: `template0`.


#### postgresql::server::database_grant
This defined type manages grant based access privileges for users, wrapping the `postgresql::server::database_grant` for database specific permissions. Consult the PostgreSQL documentation for `grant` for more information.

#### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. Default: Connects to the local Postgres instance.

##### `db`
Specifies the database to grant access to.

##### `namevar`
Specifies a way to uniquely identify this resource, but functionality not used during grant.

##### `privilege`
Specifies which privileges to grant. Valid options: `SELECT`, `TEMPORARY`, `TEMP`, `CONNECT`. `ALL` is used as a synonym for `CREATE`, so if you need to add multiple privileges, a space delimited string can be used.

##### `psql_db`
Defines the database to execute the grant against. _This should not ordinarily be changed from the default_, which is `postgres`.

##### `psql_user`
Specifies the OS user for running `psql`. Default: The default user for the module, usually `postgres`.

##### `role`
Specifies the role or user whom you are granting access to.


#### postgresql::server::extension
Manages a PostgreSQL extension.

##### `database`
Specifies the database on which to activate the extension.

##### `ensure`
Specifies whether to activate (`present`) or deactivate (`absent`) the extension.

#### `extension`
Specifies the extension to activate. If left blank, it will use the name of the resource.

##### `package_name`
Specifies a package to install prior to activating the extension.

##### `package_ensure`
Overrides default package deletion behavior. By default, the package specified with `package_name` will be installed when the extension is activated, and removed when the extension is deactivated. You can override this behavior by setting the `ensure` value for the package.


#### postgresql::server::grant
This defined type manages grant based access privileges for roles. Consult the PostgreSQL documentation for `grant` for more information.

##### `db`
Specifies the database which you are granting access on.

##### `namevar`
Sets a unique identifier for this resource, but functionality not used during grant.

##### `object_type`
Specifies the type of object you are granting privileges on. Valid options: `DATABASE`, `SCHEMA`, `SEQUENCE`, `ALL SEQUENCES IN SCHEMA`, `TABLE` or `ALL TABLES IN SCHEMA`.

##### `object_name`
Specifies name of `object_type` on which to grant access.

##### `port`
Port to use when connecting. Default: undef, which generally defaults to port 5432 depending on your PostgreSQL packaging.

##### `privilege`
Specifies the privilege you are granting. Valid options: `ALL`, `ALL PRIVILEGES` or `object_type` dependent string.

##### `psql_db`
Specifies the database to execute the grant against. _This should not ordinarily be changed from the default_, which is `postgres`.

##### `psql_user`
Sets the OS user to run `psql`. Default: the default user for the module, usually `postgres`.

##### `role`
Specifies the role or user whom you are granting access to.


#### postgresql::server::pg_hba_rule
Allows you to create an access rule for `pg_hba.conf`. For more details see the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html).

For example:

    postgresql::server::pg_hba_rule { 'allow application network to access app database':
      description => "Open up PostgreSQL for access from 200.1.2.0/24",
      type => 'host',
      database => 'app',
      user => 'app',
      address => '200.1.2.0/24',
      auth_method => 'md5',
    }

This would create a ruleset in `pg_hba.conf` similar to:

    # Rule Name: allow application network to access app database
    # Description: Open up PostgreSQL for access from 200.1.2.0/24
    # Order: 150
    host  app  app  200.1.2.0/24  md5

By default, `pg_hba_rule` requires that you include `postgresql::server`, however, you can override that behavior by setting target and postgresql_version when declaring your rule.  That might look like the following.

    postgresql::server::pg_hba_rule { 'allow application network to access app database':
      description        => "Open up postgresql for access from 200.1.2.0/24",
      type               => 'host',
      database           => 'app',
      user               => 'app',
      address            => '200.1.2.0/24',
      auth_method        => 'md5',
      target             => '/path/to/pg_hba.conf',
      postgresql_version => '9.4',
    }

##### `address`
Sets a CIDR based address for this rule matching when the type is not 'local'.

##### `auth_method`
Provides the method that is used for authentication for the connection that this rule matches. Described further in the `pg_hba.conf` documentation.

##### `auth_option`
For certain `auth_method` settings there are extra options that can be passed. Consult the PostgreSQL `pg_hba.conf` documentation for further details.

##### `database`
Sets a comma separated list of databases that this rule matches.

##### `description`
Defines a longer description for this rule if required. This description is placed in the comments above the rule in `pg_hba.conf`. Defaults: `none`.

##### `namevar`
Defines a unique identifier or short description for this rule. The namevar doesn't provide any functional usage, but it is stored in the comments of the produced `pg_hba.conf`, so the originating resource can be identified.

##### `order`
Sets an order for placing the rule in `pg_hba.conf`. Default: `150`.

#### `postgresql_version`
Manages `pg_hba.conf` without managing the entire PostgreSQL instance. Default: The version set in `postgresql::server`.

##### `target`
Provides the target for the rule, and is generally an internal only property. **Use with caution.**

##### `type`
Sets the type of rule. Valid options: `local`, `host`, `hostssl` or `hostnossl`.

##### `user`
Sets a comma separated list of users that this rule matches.


#### postgresql::server::pg_ident_rule
Allows you to create user name maps for `pg_ident.conf`. For more details see the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/auth-username-maps.html).

For example:

    postgresql::server::pg_ident_rule{ 'Map the SSL certificate of the backup server as a replication user':
      map_name          => 'sslrepli',
      system_username   => 'repli1.example.com',
      database_username => 'replication',
    }

This would create a user name map in `pg_ident.conf` similar to:

    # Rule Name: Map the SSL certificate of the backup server as a replication user
    # Description: none
    # Order: 150
    sslrepli  repli1.example.com  replication

##### `database_username`
Specifies the user name of the the database user. The `system_username` will be mapped to this user name.

##### `description`
Sets a longer description for this rule if required. This description is placed in the comments above the rule in `pg_ident.conf`. Default: `none`.

##### `map_name`
Sets the name of the user map that is used to refer to this mapping in `pg_hba.conf`.

##### `namevar`
Sets a unique identifier or short description for this rule. The namevar doesn't provide any functional usage, but it is stored in the comments of the produced `pg_ident.conf`, so the originating resource can be identified.

##### `order`
Defines an order for placing the mapping in `pg_ident.conf`. Default: 150.

##### `system_username`
Specifies the operating system user name, the user name used to connect to the database.

##### `target`
Provides the target for the rule, and is generally an internal only property. **Use with caution.**

#### postgresql::server::recovery
Allows you to create the content for `recovery.conf`. For more details see the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/recovery-config.html).

For example:

    postgresql::server::recovery{ 'Create a recovery.conf file with the following defined parameters':
      restore_command                => 'cp /mnt/server/archivedir/%f %p',
      archive_cleanup_command        => undef,
      recovery_end_command           => undef,
      recovery_target_name           => 'daily backup 2015-01-26',
      recovery_target_time           => '2015-02-08 22:39:00 EST',
      recovery_target_xid            => undef,
      recovery_target_inclusive      => true,
      recovery_target                => 'immediate',
      recovery_target_timeline       => 'latest',
      pause_at_recovery_target       => true,
      standby_mode                   => 'on',
      primary_conninfo               => 'host=localhost port=5432',
      primary_slot_name              => undef,
      trigger_file                   => undef,
      recovery_min_apply_delay       => 0,
    }

This would create a `recovery.conf` config file, similar to this:

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


Only the specified parameters will be recognized in the template! The `recovery.conf` will only be created if at least one parameter is set and [manage_recovery_conf](#manage_recovery_conf) is set to `true`.

Every param value is a string set in the template except `recovery_target_inclusive`, `pause_at_recovery_target`, `standby_mode` and `recovery_min_apply_delay`.

`standby_mode` can be specified with the string ('on'/'off'), or by using a boolean value (true/false).

A detailed description of all above listed parameters can be found in the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/recovery-config.html).

The parameters are grouped into these three sections:

##### [`Archive Recovery Parameters`](http://www.postgresql.org/docs/current/static/archive-recovery-settings.html)
In this section the `restore_command`, `archive_cleanup_command` and `recovery_end_command` parameters are listed.

##### [`Recovery Target Settings`](http://www.postgresql.org/docs/current/static/recovery-target-settings.html)
In this section the `recovery_target_name`, `recovery_target_time`, `recovery_target_xid`, `recovery_target_inclusive`, `recovery_target`, `recovery_target_timeline` and `pause_at_recovery_target` parameters are listed.

##### [`Standby Server Settings`](http://www.postgresql.org/docs/current/static/standby-settings.html)
In this section the `standby_mode`, `primary_conninfo`, `primary_slot_name`, `trigger_file` and `recovery_min_apply_delay` parameters are listed.

##### `target`
Provides the target for the rule, and is generally an internal only property. **Use with caution.**


#### postgresql::server::role
Creates a role or user in PostgreSQL.

##### `connection_limit`
Specifies how many concurrent connections the role can make. Default: `-1`, meaning no limit.

##### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. Default: Connects to the local Postgres instance.

##### `createdb`
Specifies whether to grant the ability to create new databases with this role. Default: `false`.

##### `createrole`
Specifies whether to grant the ability to create new roles with this role. Default: `false`.

##### `inherit`
Specifies whether to grant inherit capability for the new role. Default: `true`.

##### `login`
Specifies whether to grant login capability for the new role. Default: `true`.

##### `namevar`
Specifies the role name to create.

##### `password_hash`
Sets the hash to use during password creation. If the password is not already pre-encrypted in a format that PostgreSQL supports, use the `postgresql_password` function to provide an MD5 hash here, for example:

    postgresql::server::role { "myusername":
      password_hash => postgresql_password('myusername', 'mypassword'),
    }

##### `replication`
Provides provides replication capabilities for this role if set to `true`. Default: `false`.

##### `superuser`
Specifies whether to grant super user capability for the new role. Default: `false`.

##### `username`
Defines the username of the role to create, Default: `namevar`.


#### postgresql::server::schema
Used to create a schema. For example:

    postgresql::server::schema { 'isolated':
      owner => 'jane',
      db    => 'janedb',
    }

It will create the schema `isolated` in the database `janedb` if neccessary,
assigning the user `jane` ownership permissions.

##### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. Default: Connects to the local Postgres instance.

##### `db`
**Mandatory**. Sets the name of the database in which to create this schema. This must be passed.

##### `namevar`
Specifies the name of the schema being created.

##### `owner`
Sets the default owner of the schema.

##### `schema`
Sets the name of the schema. Default: `namevar`.


#### postgresql::server::table_grant
Manages grant based access privileges for users. Consult the PostgreSQL documentation for `grant` for more information.

##### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. Default: Connects to the local Postgres instance.

##### `db`
Specifies which database the table is in.

##### `namevar`
Used to uniquely identify this resource, but functionality not used during grant.

##### `privilege`
Valid options: `SELECT`, `INSERT`, `UPDATE`, `REFERENCES`. `ALL` is used as a synonym for `CREATE`, so if you need to add multiple privileges, use a space delimited string.

##### `psql_db`
Database to execute the grant against. This should not ordinarily be changed from the default, which is `postgres`.

##### `psql_user`
Specifies the OS user for running `psql`. Defaults to the default user for the module, usually `postgres`.

##### `role`
Specifies the role or user whom you are granting access for.

##### `table`
Specifies the table to grant access on.


#### postgresql::server::tablespace
Creates a tablespace. For example:

    postgresql::server::tablespace { 'tablespace1':
      location => '/srv/space1',
    }

It will create the location if necessary, assigning it the same permissions as your
PostgreSQL server.

##### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. Default: Connects to the local Postgres instance.

##### `location`
Specifies the path to locate this tablespace.

##### `namevar`
Specifies the tablespace name to create.

##### `owner`
Specifies the default owner of the tablespace.

##### `spcname`
Specifies the name of the tablespace. Default: `namevar`.


#### postgresql::validate_db_connection
This resource can be utilized inside composite manifests to validate a client has a valid connection with a remote PostgreSQL database. It can be run from any node where the PostgreSQL client software is installed to validate connectivity before commencing other dependent tasks in your Puppet manifests. It is often used when chained to other tasks such as starting an application server, or performing a database migration.

Example usage:

    postgresql::validate_db_connection { 'validate my postgres connection':
      database_host           => 'my.postgres.host',
      database_username       => 'mydbuser',
      database_password       => 'mydbpassword',
      database_name           => 'mydbname',
    }->
    exec { 'rake db:migrate':
      cwd => '/opt/myrubyapp',
    }

##### `connect_settings`
Specifies a hash of environment variables used when connecting to a remote server. This is an alternative to providing individual parameters (database_host, etc.). If provided, the individual parameters take precedence.

##### `create_db_first`
This will ensure the database is created before running the test. This only really works if your test is local. Default: `true`.

##### `database_host`
Sets the hostname of the database you wish to test. Default: undef, which generally uses the designated local unix socket.

##### `database_name`
Specifies the name of the database you wish to test. Default: 'postgres'.

##### `database_port`
Defines the port to use when connecting. Default: undef, which generally defaults to port 5432 depending on your PostgreSQL packaging.

##### `database_password`
Specifies the password to connect with. Can be left blank, not recommended.

##### `database_username`
Specifies the username to connect with. Default: 'undef', which when using a unix socket and ident auth will be the user you are running as. **If the host is remote you must provide a username.**

##### `namevar`
Specifies a way to uniquely identify this resource, but functionally does nothing.

##### `run_as`
Specifies the user to run the `psql` command with for authenticiation as. This is important when trying to connect to a database locally using Unix sockets and `ident` authentication. Not needed for remote testing.

##### `sleep`
Sets the number of seconds to sleep for before trying again upon failure.

##### `tries`
Sets the number of attempts before giving up and failing the resource upon failure.

### Types

#### postgresql_psql
Enables Puppet to run psql statements.

##### `command`
**Required.** Specifies the SQL command to execute via psql.

##### `cwd`
Specifies the working directory under which the psql command should be executed. Default: '/tmp'.

##### `db`
Specifies the name of the database to execute the SQL command against.

##### `environment`
Specifies any additional environment variables you want to set for a SQL command. Multiple environment variables should be specified as an array.

##### `name`
Sets an arbitrary tag for your own reference; the name of the message. This is the
namevar.

##### `port`
Specifies the port of the database server to execute the SQL command against.

##### `psql_group`
Specifies the system user group account under which the psql command should be executed. Default: 'postgres'.

##### `psql_path`
Specifies the path to psql executable. Default: 'psql'.

##### `psql_user`
Specifies the system user account under which the psql command should be executed. Default: "postgres".

##### `refreshonly`
Specifies that the SQL will only be executed via a notify/subscribe event if `true`. Default: `false`.

##### `search_path`
Defines the schema search path to use when executing the SQL command.

##### `unless`
Sets an optional SQL command to execute prior to the main command. This is generally intended to be used for idempotency, to check for the existence of an object in the database to determine whether or not the main SQL command needs to be executed at all.


#### postgresql_conf
Allows Puppet to manage `postgresql.conf` parameters.

##### `name`
Specifies the PostgreSQL parameter name to manage. This is the `namevar`.

##### `target`
Specifies the path to `postgresql.conf`. Default: '/etc/postgresql.conf'.

##### `value`
Specifies the value to set for this parameter.


#### postgresql_replication_slot
Allows you to create and destroy replication slots to register warm standby replication on a PostgreSQL master server.

##### `name`
Specifies the name of the slot to create. Must be a valid replication slot name. This is the namevar.

### Functions

#### postgresql_password
If you need to generate a postgres encrypted password, use `postgresql_password`. You can call it from your production manifests if you don't mind them containing the clear text versions of your passwords, or you can call it from the command line and then copy and paste the encrypted password into your manifest:

     puppet apply --execute 'notify { "test": message => postgresql_password("username", "password") }'


#### postgresql_acls_to_resources_hash(acl_array, id, order_offset)
This internal function converts a list of `pg_hba.conf` based ACLs (passed in as an array of strings) to a format compatible with the `postgresql::pg_hba_rule` resource.

**This function should only be used internally by the module**.


## Limitations

Works with versions of PostgreSQL from 8.1 through 9.4.

Currently it is only actively tested with the following operating systems:

* Debian 6.x and 7.x.
* Centos 5.x, 6.x, and 7.x.
* Ubuntu 10.04 and 12.04, 14.04.

Several other distros are compatible, but are not being actively tested.


### Apt module support

While this module supports both 1.x and 2.x versions of the puppetlabs-apt module, it does not support puppetlabs-apt 2.0.0 or 2.0.1.

### Postgis support

Postgis is currently considered an unsupported feature, as it doesn't work on all platforms correctly.

### All versions of RHEL/Centos

If you have SELinux enabled you must add any custom ports you use to the `postgresql_port_t` context.  You can do this as follows:


    semanage port -a -t postgresql_port_t -p tcp $customport

## Development

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad hardware, software, and deployment configurations that Puppet is intended to serve. We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things. For more information, see our [module contribution guide](https://docs.puppetlabs.com/forge/contributing.html).

### Tests

There are two types of tests distributed with this module. Unit tests with `rspec-puppet` and system tests using `rspec-system`.

For unit testing, make sure you have:

* rake
* bundler

Install the necessary gems:

    bundle install --path=vendor

And then run the unit tests:

    bundle exec rake spec

The unit tests are run in Travis-CI as well, if you want to see the results of your own tests, register the service hook through Travis-CI via the accounts section for your Github clone of this project.

If you want to run the system tests, make sure you also have:

* vagrant > 1.2.x
* Virtualbox > 4.2.10

Then run the tests using:

    bundle exec rspec spec/acceptance

To run the tests on different operating systems, see the sets available in `.nodeset.yml` and run the specific set with the following syntax:

    RSPEC_SET=debian-607-x64 bundle exec rspec spec/acceptance

### Transfer Notice

This Puppet module was originally authored by Inkling Systems. The maintainer preferred that Puppet Labs take ownership of the module for future improvement and maintenance as Puppet Labs is using it in the PuppetDB module. Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Inkling.

Previously: [https://github.com/inkling/puppet-postgresql](https://github.com/inkling/puppet-postgresql)

### Contributors

View the full list of contributors on [https://github.com/puppetlabs/puppetlabs-postgresql/graphs/contributors](GitHub).
