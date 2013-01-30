2.0.1
=======

Minor bugfix release.

2013-01-16 - Chris Price <chris@puppetlabs.com>
 * Fix revoke command in database.pp to support postgres 8.1 (43ded42)

2013-01-15 - Jordi Boggiano <j.boggiano@seld.be>
 * Add support for ubuntu 12.10 status (3504405)

2.0.0
=======

Many thanks to the following people who contributed patches to this
release:

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

Notable features:

   * Add support for versions of postgres other than the system default version
     (which varies depending on OS distro).  This includes optional support for
     automatically managing the package repo for the "official" postgres yum/apt
     repos.  (Major thanks to Etienne Pelletier <epelletier@maestrodev.com> and
     Ken Barber <ken@bob.sh> for their tireless efforts and patience on this
     feature set!)  For example usage see `tests/official-postgresql-repos.pp`.

   * Add some support for Debian Wheezy and Ubuntu Quantal

   * Add new `postgres_psql` type with a Ruby provider, to replace the old
     exec-based `psql` type.  This gives us much more flexibility around
     executing SQL statements and controlling their logging / reports output.

   * Major refactor of the "spec" tests--which are actually more like
     acceptance tests.  We now support testing against multiple OS distros
     via vagrant, and the framework is in place to allow us to very easily add
     more distros.  Currently testing against Cent6 and Ubuntu 10.04.

   * Fixed a bug that was preventing multiple databases from being owned by the
     same user
     (9adcd182f820101f5e4891b9f2ff6278dfad495c - Etienne Pelletier <epelletier@maestrodev.com>)

   * Add support for ACLs for finer-grained control of user/interface access
     (b8389d19ad78b4fb66024897097b4ed7db241930 - dharwood <harwoodd@cat.pdx.edu>)

   * Many other bug fixes and improvements!


1.0.0
=======
2012-09-17 - Version 0.3.0 released

2012-09-14 - Chris Price <chris@puppetlabs.com>
 * Add a type for validating a postgres connection (ce4a049)

2012-08-25 - Jari Bakken <jari.bakken@gmail.com>
 * Remove trailing commas. (e6af5e5)

2012-08-16 - Version 0.2.0 released
