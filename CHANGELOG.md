<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [v10.0.3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v10.0.3) - 2024-01-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v10.0.2...v10.0.3)

### Fixed

- support for a custom apt source release [#1561](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1561) ([h0tw1r3](https://github.com/h0tw1r3))
- (#1556) Fix Python package name for Ubuntu >= 22.04 [#1557](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1557) ([antaflos](https://github.com/antaflos))
- Unconfine postgresql_conf [#1551](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1551) ([smortex](https://github.com/smortex))

## [v10.0.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v10.0.2) - 2023-11-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v10.0.1...v10.0.2)

### Fixed

- postgresql_conf: Fix regex for value param and add tests [#1544](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1544) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

## [v10.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v10.0.1) - 2023-10-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v10.0.0...v10.0.1)

### Fixed

- Fix `postgresql::default()` return value for unknown parameters [#1530](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1530) ([smortex](https://github.com/smortex))
- Fix the `postgresql::postgresql_password()` function [#1529](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1529) ([smortex](https://github.com/smortex))

## [v10.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v10.0.0) - 2023-10-11

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v9.2.0...v10.0.0)

### Changed
- postgis: Drop EL5 leftovers and fix package name for Fedora [#1521](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1521) ([bastelfreak](https://github.com/bastelfreak))
- Drop EoL SLES 11.4 code [#1520](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1520) ([bastelfreak](https://github.com/bastelfreak))
- Drop code for Debian without systemd [#1514](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1514) ([bastelfreak](https://github.com/bastelfreak))
- puppet/systemd: Allow 6.x [#1505](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1505) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- set datatype for directories to Stdlib::Absolutepath [#1499](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1499) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Drop postgresql 8.4/RHEL6 specific code [#1489](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1489) ([bastelfreak](https://github.com/bastelfreak))
- Drop postgresql 8.1/RHEL5 specific code [#1486](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1486) ([bastelfreak](https://github.com/bastelfreak))
- Delete deprecated validate_db_connection() defined resource [#1484](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1484) ([bastelfreak](https://github.com/bastelfreak))
- postgresql::server: Remove deprecated createdb_path parameter [#1483](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1483) ([bastelfreak](https://github.com/bastelfreak))
- postgresql::server: Remove deprecated version parameter [#1482](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1482) ([bastelfreak](https://github.com/bastelfreak))
- puppetlabs/stdlib: Require 9.x [#1481](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1481) ([bastelfreak](https://github.com/bastelfreak))
- port: Enforce Stdlib::Port datatype [#1473](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1473) ([bastelfreak](https://github.com/bastelfreak))
- Add Server Instance Feature [#1450](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1450) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

### Added

- Drop EoL FreeBSD 9.4/9.5 specific code [#1519](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1519) ([bastelfreak](https://github.com/bastelfreak))
- Drop code compatibility for non-systemd Red Hat [#1518](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1518) ([ekohl](https://github.com/ekohl))
- add $manage_selinux as a parameter, keep default, simpler condition [#1516](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1516) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- add port and psql_path parameter to initdb define [#1510](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1510) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- PDK update 2.7.0->3.0.0 [#1508](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1508) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- variables to parameters for tablespace/schema/reassign_owned_by [#1507](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1507) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- server::schema: Drop unused $version variable [#1506](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1506) ([bastelfreak](https://github.com/bastelfreak))
- Prefer $connect_settings over explicit parameters [#1498](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1498) ([bastelfreak](https://github.com/bastelfreak))
- server::extension: make user/group/psql_path configureable [#1497](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1497) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- server::db: Make port/user/group configureable [#1494](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1494) ([bastelfreak](https://github.com/bastelfreak))
- server::database_grant: Always set default user/group and expose port as parameter [#1493](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1493) ([bastelfreak](https://github.com/bastelfreak))
- server::database: make user/group/psql_path/default_db configureable [#1492](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1492) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Provide a default for config_entry's path and enforce absolute path [#1490](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1490) ([SimonHoenscheid](https://github.com/SimonHoenscheid))

### Fixed

- Fix password_encryption for DBVERSION in server::role [#1515](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1515) ([cruelsmith](https://github.com/cruelsmith))
- Flexible password encryption in pg hba conf [#1512](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1512) ([cruelsmith](https://github.com/cruelsmith))
- service name should be unique to allow instances [#1504](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1504) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- server::grant: make port optional/restore connect_settings feature [#1496](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1496) ([bastelfreak](https://github.com/bastelfreak))

## [v9.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v9.2.0) - 2023-08-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v9.1.0...v9.2.0)

### Added

- port parameter: Cleanup datatype [#1471](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1471) ([bastelfreak](https://github.com/bastelfreak))
- puppet/systemd: Allow 5.x & puppetlabs/concat: Allow 9.x [#1448](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1448) ([bastelfreak](https://github.com/bastelfreak))
- Add default version for Fedora 37, 38 [#1421](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1421) ([lweller](https://github.com/lweller))
- Defaulting password encryption for version above 14 [#1406](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1406) ([cruelsmith](https://github.com/cruelsmith))

### Fixed

- port parameter: log warning when its a string [#1474](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1474) ([bastelfreak](https://github.com/bastelfreak))
- pg_hba.conf: Introduce a newline after each rule [#1472](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1472) ([bastelfreak](https://github.com/bastelfreak))
- (CAT-1262)-updated legacy repo for SUSE [#1462](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1462) ([praj1001](https://github.com/praj1001))
- Fix log directory config entry name [#1457](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1457) ([chillinger](https://github.com/chillinger))
- Make anchors in defined resources unique [#1455](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1455) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- implement key parameter for config_entry defined resource [#1454](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1454) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- add missing parameters to initdb [#1451](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1451) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Fix default value for $service_status on ArchLinux [#1410](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1410) ([smortex](https://github.com/smortex))
- Fix wrong Sensitive handling for updating role passwords [#1404](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1404) ([cruelsmith](https://github.com/cruelsmith))

## [v9.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v9.1.0) - 2023-06-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v9.0.3...v9.1.0)

### Added

- pdksync - (MAINT) - Allow Stdlib 9.x [#1440](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1440) ([LukasAud](https://github.com/LukasAud))

## [v9.0.3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v9.0.3) - 2023-05-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v9.0.2...v9.0.3)

### Fixed

- (GH-1426) - Update value to accept array [#1434](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1434) ([jordanbreen28](https://github.com/jordanbreen28))
- (#1432) - Fix `Unable to mark 'unless' as sensitive` [#1433](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1433) ([kBite](https://github.com/kBite))

## [v9.0.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v9.0.2) - 2023-05-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v9.0.1...v9.0.2)

### Fixed

- (CONT-950) - Fix mismatched data types [#1430](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1430) ([jordanbreen28](https://github.com/jordanbreen28))
- (CONT-904) - Removal of tech debt [#1429](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1429) ([jordanbreen28](https://github.com/jordanbreen28))
- (CONT-949) - Bump stdlib dependency [#1428](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1428) ([jordanbreen28](https://github.com/jordanbreen28))

## [v9.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v9.0.1) - 2023-04-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v9.0.0...v9.0.1)

### Fixed

- Fix wrong data type for `data_checksums` parameter [#1420](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1420) ([smortex](https://github.com/smortex))

## [v9.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v9.0.0) - 2023-04-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v8.3.0...v9.0.0)

### Changed
- (CONT-792) - Add Puppet 8/Drop Puppet 6 [#1414](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1414) ([jordanbreen28](https://github.com/jordanbreen28))

## [v8.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v8.3.0) - 2023-04-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v8.2.1...v8.3.0)

### Added

- convert ERB templates to EPP [#1399](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1399) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- (CONT-361) Syntax update [#1397](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1397) ([LukasAud](https://github.com/LukasAud))
- Add multi instance support, refactoring reload.pp (6/x) [#1392](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1392) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Add multi instance support, refactoring password.pp (5/x) [#1391](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1391) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Add multi instance support, refactoring late_initdb.pp (3/x) [#1384](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1384) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Add multi instance support, refactoring initdb.pp (2/x) [#1383](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1383) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Add multi instance support, refactoring config.pp (1/x) [#1382](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1382) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- pg_hba_rule: Validate userinput in postgresql::server [#1376](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1376) ([bastelfreak](https://github.com/bastelfreak))
- pg_hba_rule: Move `type` datatype to own type [#1375](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1375) ([bastelfreak](https://github.com/bastelfreak))
- pg_hba_rule does not properly verify address parameter [#1372](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1372) ([tuxmea](https://github.com/tuxmea))

### Fixed

- Ubuntu 14/16/17: Drop code leftovers [#1388](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1388) ([bastelfreak](https://github.com/bastelfreak))
- remove debian 8 and 9 corpses [#1387](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1387) ([SimonHoenscheid](https://github.com/SimonHoenscheid))
- Archlinux client and server package names were swapped around [#1381](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1381) ([tobixen](https://github.com/tobixen))
- apt::source: configure repo only for current architecture [#1380](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1380) ([bastelfreak](https://github.com/bastelfreak))
- pdksync - (CONT-189) Remove support for RedHat6 / OracleLinux6 / Scientific6 [#1371](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1371) ([david22swan](https://github.com/david22swan))
- pdksync - (CONT-130) - Dropping Support for Debian 9 [#1368](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1368) ([jordanbreen28](https://github.com/jordanbreen28))
- (maint) Codebase Hardening [#1366](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1366) ([david22swan](https://github.com/david22swan))
- Fix table grant with schema [#1315](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1315) ([vaol](https://github.com/vaol))

## [v8.2.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v8.2.1) - 2022-08-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v8.2.0...v8.2.1)

### Fixed

- Fix puppet-strings documentation [#1363](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1363) ([ekohl](https://github.com/ekohl))
- (GH-1360) Reverting REFERENCE.md changes [#1361](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1361) ([pmcmaw](https://github.com/pmcmaw))
- Only require password when used [#1356](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1356) ([arjenz](https://github.com/arjenz))

## [v8.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v8.2.0) - 2022-08-23

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v8.1.0...v8.2.0)

### Added

- pdksync - (GH-cat-11) Certify Support for Ubuntu 22.04 [#1355](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1355) ([david22swan](https://github.com/david22swan))
- (MODULES-11251) Add support for backup provider "pg_dump" [#1319](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1319) ([fraenki](https://github.com/fraenki))

### Fixed

- Ensure multiple postgresql::server::recovery resources can be defined [#1348](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1348) ([Deroin](https://github.com/Deroin))

## [v8.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v8.1.0) - 2022-07-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v8.0.0...v8.1.0)

### Added

- Fix service status detection on Debian-based OSes [#1349](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1349) ([arjenz](https://github.com/arjenz))
- (FM-8971) allow deferred function for role pwd [#1347](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1347) ([tvpartytonight](https://github.com/tvpartytonight))
- Set version for Fedora 36 [#1345](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1345) ([lweller](https://github.com/lweller))
- Add Red Hat Enterprise Linux 9 support [#1303](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1303) ([ekohl](https://github.com/ekohl))

### Fixed

- (GH-1352) - Updating postgresql service version on SLES  [#1353](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1353) ([pmcmaw](https://github.com/pmcmaw))
- Respect $service_status on Red Hat-based distros [#1351](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1351) ([ekohl](https://github.com/ekohl))
- Add version for Ubuntu 22.04 [#1350](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1350) ([arjenz](https://github.com/arjenz))
- README.md: correct postgresql_conn_validator example [#1332](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1332) ([bastelfreak](https://github.com/bastelfreak))
- pdksync - (GH-iac-334) Remove Support for Ubuntu 14.04/16.04 [#1331](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1331) ([david22swan](https://github.com/david22swan))
- Remove unused variable in reload.pp [#1327](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1327) ([ekohl](https://github.com/ekohl))
- Use systemctl reload on EL 7 and higher [#1326](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1326) ([ekohl](https://github.com/ekohl))

## [v8.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v8.0.0) - 2022-03-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.5.0...v8.0.0)

### Changed
- Support setting default_privileges on all schemas [#1298](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1298) ([fish-face](https://github.com/fish-face))

### Added

- add default version for Fedora 35 [#1317](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1317) ([jflorian](https://github.com/jflorian))
- add scram-sha-256 support [#1313](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1313) ([fe80](https://github.com/fe80))
- add support for Ubuntu Hirsute and Impish [#1312](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1312) ([nicholascioli](https://github.com/nicholascioli))
- Allow systemd to mask postgresql service file [#1310](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1310) ([kim-sondrup](https://github.com/kim-sondrup))
- Make ::contrib a noop on OSes without a contrib package [#1309](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1309) ([carlosduelo](https://github.com/carlosduelo))
- pdksync - (IAC-1753) - Add Support for AlmaLinux 8 [#1308](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1308) ([david22swan](https://github.com/david22swan))
- MODULES-11201: add service_name for Ubuntu 18.04 and later [#1306](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1306) ([moritz-makandra](https://github.com/moritz-makandra))
- pdksync - (IAC-1751) - Add Support for Rocky 8 [#1305](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1305) ([david22swan](https://github.com/david22swan))
- Default privileges support schemas [#1300](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1300) ([fish-face](https://github.com/fish-face))
- Support target_role in default_privileges [#1297](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1297) ([fish-face](https://github.com/fish-face))

### Fixed

- pdksync - (IAC-1787) Remove Support for CentOS 6 [#1324](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1324) ([david22swan](https://github.com/david22swan))
- Fix python package name in RHEL/CentOS 8 [#1316](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1316) ([kajinamit](https://github.com/kajinamit))
- Drop further code for Debian 6 and Ubuntu 10 [#1307](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1307) ([ekohl](https://github.com/ekohl))

## [v7.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.5.0) - 2021-09-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.4.1...v7.5.0)

### Added

- Use Puppet-Datatype Sensitive for Passwords [#1279](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1279) ([cocker-cc](https://github.com/cocker-cc))

### Fixed

- (IAC-1598) - Remove Support for Debian 8 [#1302](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1302) ([david22swan](https://github.com/david22swan))
- Inline file contents in the catalog [#1299](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1299) ([ekohl](https://github.com/ekohl))
- Fix changing default encoding [#1296](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1296) ([smortex](https://github.com/smortex))

## [v7.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.4.1) - 2021-08-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.4.0...v7.4.1)

### Fixed

- (maint) Allow stdlib 8.0.0 [#1293](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1293) ([smortex](https://github.com/smortex))

## [v7.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.4.0) - 2021-08-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.3.0...v7.4.0)

### Added

- pdksync - (IAC-1709) - Add Support for Debian 11 [#1288](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1288) ([david22swan](https://github.com/david22swan))

### Fixed

- drop code for Debian 6/7 and Ubuntu 10.04/12.04 [#1290](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1290) ([evgeni](https://github.com/evgeni))

## [v7.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.3.0) - 2021-08-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.2.0...v7.3.0)

### Added

- MODULES-11049 - Implement default privileges changes [#1267](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1267) ([mtancoigne](https://github.com/mtancoigne))

### Fixed

- Do not add version component to repo definition [#1282](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1282) ([weastur](https://github.com/weastur))
- (MODULES-8700) Autorequire the service in postgresql_psql [#1276](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1276) ([ekohl](https://github.com/ekohl))

## [v7.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.2.0) - 2021-05-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.1.0...v7.2.0)

### Added

- (MODULES-11069) add default version for fedora 34 [#1272](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1272) ([lweller](https://github.com/lweller))
- MODULES-11047 - Allow managing rights for PUBLIC role [#1266](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1266) ([mtancoigne](https://github.com/mtancoigne))

## [v7.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.1.0) - 2021-04-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.0.3...v7.1.0)

### Added

- Add new common repo which contains add-ons [#1190](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1190) ([jorhett](https://github.com/jorhett))

## [v7.0.3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.0.3) - 2021-04-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.0.2...v7.0.3)

## [v7.0.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.0.2) - 2021-03-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.0.1...v7.0.2)

### Fixed

- (MODULES-10957) Override the set_sensitive_parameters method [#1258](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1258) ([sheenaajay](https://github.com/sheenaajay))

## [v7.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.0.1) - 2021-03-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v7.0.0...v7.0.1)

### Fixed

- Ensure port is a string in psql command [#1253](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1253) ([ekohl](https://github.com/ekohl))

## [v7.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v7.0.0) - 2021-03-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.10.2...v7.0.0)

### Changed
- pdksync - (MAINT) Remove SLES 11 support [#1247](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1247) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - (MAINT) Remove RHEL 5 family support [#1246](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1246) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#1238](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1238) ([carabasdaniel](https://github.com/carabasdaniel))

### Added

- Add DNF module management [#1239](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1239) ([ekohl](https://github.com/ekohl))

## [v6.10.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.10.2) - 2021-02-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.10.1...v6.10.2)

### Fixed

- Fix command shell escaping [#1240](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1240) ([DavidS](https://github.com/DavidS))

## [v6.10.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.10.1) - 2021-02-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.10.0...v6.10.1)

## [v6.10.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.10.0) - 2021-02-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.9.0...v6.10.0)

### Added

- Set default PostgreSQL version for FreeBSD [#1227](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1227) ([olevole](https://github.com/olevole))
- Clean up globals logic to support CentOS 8 stream [#1225](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1225) ([ekohl](https://github.com/ekohl))

### Fixed

- Also perform systemd daemon-reload on Puppet 6.1+ [#1233](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1233) ([ekohl](https://github.com/ekohl))
- (bug) fix systemd daemon-reload order when updating service files [#1230](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1230) ([sheenaajay](https://github.com/sheenaajay))
- Fix postgresql::sql task when password is not set [#1226](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1226) ([smortex](https://github.com/smortex))

## [v6.9.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.9.0) - 2021-01-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.8.0...v6.9.0)

### Added

- pdksync - (feat) -  Add support for puppet 7 [#1215](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1215) ([daianamezdrea](https://github.com/daianamezdrea))
- Manage postgresql_conf_path file permissions [#1199](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1199) ([ekohl](https://github.com/ekohl))

### Fixed

- (maint) updated defaults for rhel7 policycoreutils [#1212](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1212) ([sheenaajay](https://github.com/sheenaajay))
- (IAC-1189) - Fix for SLES 15 SP 1 and later [#1209](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1209) ([david22swan](https://github.com/david22swan))
- Change - Use systemd drop-in directory for unit overrides [#1201](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1201) ([blackknight36](https://github.com/blackknight36))

## [v6.8.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.8.0) - 2020-09-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.7.0...v6.8.0)

### Added

- add hostgssenc type to pg_hba rules [#1195](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1195) ([osijan](https://github.com/osijan))
- Allow removal of config_entries via main class [#1187](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1187) ([ekohl](https://github.com/ekohl))

### Fixed

- Fix contrib package name under debian 10 [#1188](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1188) ([neomilium](https://github.com/neomilium))

## [v6.7.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.7.0) - 2020-08-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.6.0...v6.7.0)

### Added

- pdksync - (IAC-973) - Update travis/appveyor to run on new default branch `main` [#1182](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1182) ([david22swan](https://github.com/david22swan))

## [v6.6.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.6.0) - 2020-06-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.5.0...v6.6.0)

### Added

- (IAC-746) - Add ubuntu 20.04 support [#1172](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1172) ([david22swan](https://github.com/david22swan))

### Fixed

- Invert psql/package dependency logic [#1179](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1179) ([raphink](https://github.com/raphink))
- Fix custom port in extension [#1165](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1165) ([Vampouille](https://github.com/Vampouille))

## [v6.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.5.0) - 2020-05-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.4.0...v6.5.0)

### Added

- service_ensure => true is now an allowed value (aliased to running)  [#1167](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1167) ([binford2k](https://github.com/binford2k))
- Finish conversion of `postgresql_acls_to_resources_hash` function [#1163](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1163) ([alexjfisher](https://github.com/alexjfisher))
- Finish conversion of `postgresql_escape` function [#1162](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1162) ([alexjfisher](https://github.com/alexjfisher))
- Finish conversion of `postgresql_password` function [#1161](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1161) ([alexjfisher](https://github.com/alexjfisher))
- Allow usage of grant and role when not managing postgresql::server [#1159](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1159) ([tuxmea](https://github.com/tuxmea))
- Add version configs for SLES 12 SP 3 to 5 [#1158](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1158) ([XnS](https://github.com/XnS))
- Add extra parameter "extra_systemd_config"  [#1156](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1156) ([veninga](https://github.com/veninga))

### Fixed

- (MODULES-10610) Use correct lower bound for concat version [#1160](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1160) ([ghoneycutt](https://github.com/ghoneycutt))

## [v6.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.4.0) - 2020-03-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.3.0...v6.4.0)

### Added

- Add Fedora 31 compatibility [#1141](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1141) ([blackknight36](https://github.com/blackknight36))
- feat: enable different database resource name in extension [#1136](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1136) ([jfroche](https://github.com/jfroche))
- pdksync - (FM-8581) - Debian 10 added to travis and provision file refactored [#1130](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1130) ([david22swan](https://github.com/david22swan))
- Puppet 4 functions [#1129](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1129) ([binford2k](https://github.com/binford2k))

### Fixed

- Fix incorrectly quoted GRANT cmd on functions [#1150](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1150) ([olifre](https://github.com/olifre))
- Correct versioncmp logic in config.pp [#1137](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1137) ([boydtom](https://github.com/boydtom))
- Treat $version as an integer for comparison, defaults to string [#1135](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1135) ([boydtom](https://github.com/boydtom))
- Allow usage of PUBLIC role [#1134](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1134) ([Vampouille](https://github.com/Vampouille))
- fix missing systemd override config for EL8 (CentOS and RHEL) [#1131](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1131) ([david-barbion](https://github.com/david-barbion))

## [v6.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.3.0) - 2019-12-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.2.0...v6.3.0)

### Added

- Add support for granting privileges on functions [#1118](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1118) ([crispygoth](https://github.com/crispygoth))
- (FM-8679) - Support added for CentOS 8 [#1117](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1117) ([david22swan](https://github.com/david22swan))
- MODULES-10041 - allow define password_encryption for version above 10 [#1111](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1111) ([k2patel](https://github.com/k2patel))

### Fixed

- Remove duplicate REFERENCE.md file with strange unicode character at end of filename [#1108](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1108) ([nudgegoonies](https://github.com/nudgegoonies))

## [v6.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.2.0) - 2019-09-13

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.1.0...v6.2.0)

### Added

- FM-8408 - add support on Debian10 [#1103](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1103) ([lionce](https://github.com/lionce))
- Fix/directory defined twice [#1089](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1089) ([arcenik](https://github.com/arcenik))
- Adding SLES 15 [#1087](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1087) ([msurato](https://github.com/msurato))
- (FM-7500) conversion to use litmus [#1081](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1081) ([tphoney](https://github.com/tphoney))

### Fixed

- (MODULES-9658) - custom ports are not labeled correctly [#1099](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1099) ([blackknight36](https://github.com/blackknight36))
- Fix: When assigning a tablespace to a database, no equal sign is needed in the query [#1098](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1098) ([biertie](https://github.com/biertie))
- Grant all tables in schema fixup [#1096](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1096) ([georgehansper](https://github.com/georgehansper))
- (MODULES-9219) - puppetlabs-postgresql : catalog compilation fails when the service command is not installed [#1093](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1093) ([blackknight36](https://github.com/blackknight36))

## [v6.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.1.0) - 2019-06-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/v6.0.0...v6.1.0)

### Added

- (FM-8031) Add RedHat 8 support [#1083](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1083) ([eimlav](https://github.com/eimlav))

## [v6.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/v6.0.0) - 2019-05-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.12.1...v6.0.0)

### Changed
- pdksync - (MODULES-8444) - Raise lower Puppet bound [#1070](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1070) ([david22swan](https://github.com/david22swan))
- (maint) remove inconsistent extra variable [#1044](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1044) ([binford2k](https://github.com/binford2k))

### Added

- Add Fedora 30 compatibility [#1067](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1067) ([blackknight36](https://github.com/blackknight36))
- Include EL8 version for config checks [#1060](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1060) ([ehelms](https://github.com/ehelms))

### Fixed

- Support current version of puppetlabs/apt. [#1073](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1073) ([pillarsdotnet](https://github.com/pillarsdotnet))
- change username/group/datadir defaults for FreeBSD [#1063](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1063) ([olevole](https://github.com/olevole))

## [5.12.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.12.1) - 2019-02-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.12.0...5.12.1)

### Fixed

- (FM-7811) - Use postgresql 9.4 for SLES 11 sp4 [#1057](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1057) ([david22swan](https://github.com/david22swan))
- (MODULES-8553) Further cleanup for package tag issues [#1055](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1055) ([HelenCampbell](https://github.com/HelenCampbell))

## [5.12.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.12.0) - 2019-02-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.11.0...5.12.0)

### Added

- (MODULES-3804) Fix sort order of pg_hba_rule entries [#1040](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1040) ([olavmrk](https://github.com/olavmrk))

### Fixed

- (MODULES-8553) Fix dependency on apt by explicitly using 'puppetlabs-postgresql' as tag [#1052](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1052) ([HelenCampbell](https://github.com/HelenCampbell))
- (MODULES-8352) Don't use empty encoding string on initdb [#1043](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1043) ([binford2k](https://github.com/binford2k))
- pdksync - (FM-7655) Fix rubygems-update for ruby < 2.3 [#1042](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1042) ([tphoney](https://github.com/tphoney))

## [5.11.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.11.0) - 2018-11-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.10.0...5.11.0)

### Added

- Add postgis support for postgres 10 [#1032](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1032) ([smussie](https://github.com/smussie))

### Fixed

- Strip quotes from role names [#1034](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1034) ([jstuart](https://github.com/jstuart))
- Ignore .psqlrc so output is clean and doesn't break Puppet [#1021](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1021) ([flaviogurgel](https://github.com/flaviogurgel))
- Change initdb option '--xlogdir' to '-X' for PG10 compatibility [#976](https://github.com/puppetlabs/puppetlabs-postgresql/pull/976) ([fcanovai](https://github.com/fcanovai))

## [5.10.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.10.0) - 2018-09-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.9.0...5.10.0)

### Added

- pdksync - (MODULES-6805) metadata.json shows support for puppet 6 [#1026](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1026) ([tphoney](https://github.com/tphoney))

## [5.9.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.9.0) - 2018-09-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.8.0...5.9.0)

### Added

- pdksync - (MODULES-7705) - Bumping stdlib dependency from < 5.0.0 to < 6.0.0 [#1018](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1018) ([pmcmaw](https://github.com/pmcmaw))

## [5.8.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.8.0) - 2018-08-07

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.7.0...5.8.0)

### Added

- metadata.json: bump allowed version of puppetlabs-apt to 6.0.0 [#1012](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1012) ([mateusz-gozdek-sociomantic](https://github.com/mateusz-gozdek-sociomantic))

## [5.7.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.7.0) - 2018-07-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.6.0...5.7.0)

### Added

- (MODULES-7479) Update postgresql to support Ubuntu 18.04 [#1005](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1005) ([david22swan](https://github.com/david22swan))
- (MODULES-6542) - Adding SLES 11 & 12 to metadata [#1001](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1001) ([pmcmaw](https://github.com/pmcmaw))

### Fixed

- (MODULES-7479) Ensure net-tools is installed when testing on Ubuntu 18.04 [#1006](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1006) ([david22swan](https://github.com/david22swan))
- (MODULES-7460) - Updating grant table to include INSERT privileges [#1004](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1004) ([pmcmaw](https://github.com/pmcmaw))
- Fix packages choice for ubuntu 17.10 [#1000](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1000) ([fflorens](https://github.com/fflorens))

## [5.6.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.6.0) - 2018-06-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.5.0...5.6.0)

## [5.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.5.0) - 2018-06-19

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.4.0...5.5.0)

### Changed
- Fix creation of recovery.conf file when recovery configuration is not specified [#995](https://github.com/puppetlabs/puppetlabs-postgresql/pull/995) ([cdloh](https://github.com/cdloh))

### Added

- Add compatibility for Fedora 28 [#994](https://github.com/puppetlabs/puppetlabs-postgresql/pull/994) ([jflorian](https://github.com/jflorian))
- (MODULES-5994) Add debian 9 [#992](https://github.com/puppetlabs/puppetlabs-postgresql/pull/992) ([hunner](https://github.com/hunner))
- Adding default Postgresql version for Ubuntu 18.04 [#981](https://github.com/puppetlabs/puppetlabs-postgresql/pull/981) ([lutaylor](https://github.com/lutaylor))

### Fixed

- Fix quoting on schema owners [#979](https://github.com/puppetlabs/puppetlabs-postgresql/pull/979) ([hasegeli](https://github.com/hasegeli))

## [5.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.4.0) - 2018-03-27

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.3.0...5.4.0)

### Added

- (MODULES-6330) PDK convert 1.4.1 [#961](https://github.com/puppetlabs/puppetlabs-postgresql/pull/961) ([pmcmaw](https://github.com/pmcmaw))
- Parameter `ensure` on `postgresql::server::grant` and `postgresql::server::database_grant` [#891](https://github.com/puppetlabs/puppetlabs-postgresql/pull/891) ([georgehansper](https://github.com/georgehansper))

### Fixed

- Documentation error, `reassign_owned_by` uses `*_role` not `*_owner`. [#958](https://github.com/puppetlabs/puppetlabs-postgresql/pull/958) ([computermouth](https://github.com/computermouth))

## [5.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.3.0) - 2018-02-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.2.1...5.3.0)

### Added

-  Support extension schemas [#948](https://github.com/puppetlabs/puppetlabs-postgresql/pull/948) ([hasegeli](https://github.com/hasegeli))
- Inherit 9.6 settings for later PgSQL version on FreeBSD [#945](https://github.com/puppetlabs/puppetlabs-postgresql/pull/945) ([olevole](https://github.com/olevole))
- MODULES-6194 - Add scram-sha-256 as a valid pg_hba_rule auth method [#941](https://github.com/puppetlabs/puppetlabs-postgresql/pull/941) ([f3nry](https://github.com/f3nry))
- FM-6445 add a task [#930](https://github.com/puppetlabs/puppetlabs-postgresql/pull/930) ([tphoney](https://github.com/tphoney))
- add ensure=>absent to postgresql::server::role [#897](https://github.com/puppetlabs/puppetlabs-postgresql/pull/897) ([georgehansper](https://github.com/georgehansper))

### Fixed

- (maint) - Skip run_puppet_access_login on LTS [#956](https://github.com/puppetlabs/puppetlabs-postgresql/pull/956) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-6608) - Adding puppet requirement for tasks versioncmp in beaker-task_helper [#952](https://github.com/puppetlabs/puppetlabs-postgresql/pull/952) ([pmcmaw](https://github.com/pmcmaw))
- defaulted psql_path to postgresql::server::psql_path [#947](https://github.com/puppetlabs/puppetlabs-postgresql/pull/947) ([crayfishx](https://github.com/crayfishx))
- According to the puppet doc, Pattern should be a list of regex. [#942](https://github.com/puppetlabs/puppetlabs-postgresql/pull/942) ([PierreR](https://github.com/PierreR))
- This pull request fixes an augeas warning  [#935](https://github.com/puppetlabs/puppetlabs-postgresql/pull/935) ([iakovgan](https://github.com/iakovgan))

## [5.2.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.2.1) - 2017-11-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.2.0...5.2.1)

### Fixed

- (MODULES-5956) fixes for postgresql release [#934](https://github.com/puppetlabs/puppetlabs-postgresql/pull/934) ([jbondpdx](https://github.com/jbondpdx))
- add parameter "version" to postgresql::server::extension - fix dependency on database [#932](https://github.com/puppetlabs/puppetlabs-postgresql/pull/932) ([georgehansper](https://github.com/georgehansper))

## [5.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.2.0) - 2017-10-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.1.0...5.2.0)

### Added

- add parameter "version" to postgresql::server::extension to update the extension version [#896](https://github.com/puppetlabs/puppetlabs-postgresql/pull/896) ([georgehansper](https://github.com/georgehansper))

### Fixed

- (PUP-8008) monkey patch spec_helper_acceptance [#925](https://github.com/puppetlabs/puppetlabs-postgresql/pull/925) ([eputnam](https://github.com/eputnam))
- (PUP-8008) monkey patch spec_helper_acceptance [#924](https://github.com/puppetlabs/puppetlabs-postgresql/pull/924) ([eputnam](https://github.com/eputnam))
-  enhance --data-checksums on initdb [#915](https://github.com/puppetlabs/puppetlabs-postgresql/pull/915) ([mmoll](https://github.com/mmoll))
- MODULES-5378 fix the change in error message [#909](https://github.com/puppetlabs/puppetlabs-postgresql/pull/909) ([tphoney](https://github.com/tphoney))
- MODULES-5378 fix error message checking in test [#908](https://github.com/puppetlabs/puppetlabs-postgresql/pull/908) ([tphoney](https://github.com/tphoney))
- Default contcat order [#900](https://github.com/puppetlabs/puppetlabs-postgresql/pull/900) ([matonb](https://github.com/matonb))

## [5.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.1.0) - 2017-07-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.0.0...5.1.0)

### Added

- add defined type postgresql::server::reassign_owned_by [#894](https://github.com/puppetlabs/puppetlabs-postgresql/pull/894) ([georgehansper](https://github.com/georgehansper))
- add data_checksums option to initdb [#878](https://github.com/puppetlabs/puppetlabs-postgresql/pull/878) ([tjikkun](https://github.com/tjikkun))

## [5.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.0.0) - 2017-06-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.9.0...5.0.0)

### Changed
- Unset default log_line_prefix [#870](https://github.com/puppetlabs/puppetlabs-postgresql/pull/870) ([hasegeli](https://github.com/hasegeli))
- Let listen_addresses be defined independently [#865](https://github.com/puppetlabs/puppetlabs-postgresql/pull/865) ([hasegeli](https://github.com/hasegeli))

### Added

- (MODULES-1394) replace validate_db_connection type with custom type [#879](https://github.com/puppetlabs/puppetlabs-postgresql/pull/879) ([eputnam](https://github.com/eputnam))
- [msync] 786266 Implement puppet-module-gems, a45803 Remove metadata.json from locales config [#860](https://github.com/puppetlabs/puppetlabs-postgresql/pull/860) ([wilson208](https://github.com/wilson208))
- (FM-6116) - Adding POT file for metadata.json [#857](https://github.com/puppetlabs/puppetlabs-postgresql/pull/857) ([pmcmaw](https://github.com/pmcmaw))
- Allowo to disable managing passwords for users [#846](https://github.com/puppetlabs/puppetlabs-postgresql/pull/846) ([bjoernhaeuser](https://github.com/bjoernhaeuser))

### Fixed

- (maint) fix for connection validator [#882](https://github.com/puppetlabs/puppetlabs-postgresql/pull/882) ([eputnam](https://github.com/eputnam))
- (MODULES-5050) Fix for grant_schema_spec [#881](https://github.com/puppetlabs/puppetlabs-postgresql/pull/881) ([eputnam](https://github.com/eputnam))
- [MODULES-4598] Revert "Revert "fix default params for SUSE family OSes"" [#863](https://github.com/puppetlabs/puppetlabs-postgresql/pull/863) ([mmoll](https://github.com/mmoll))
- [MODULES-4598] Revert "fix default params for SUSE family OSes" [#858](https://github.com/puppetlabs/puppetlabs-postgresql/pull/858) ([wilson208](https://github.com/wilson208))

## [4.9.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.9.0) - 2017-03-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.8.0...4.9.0)

### Added

- (MODULES-1508) add support for unix_socket_directories [#845](https://github.com/puppetlabs/puppetlabs-postgresql/pull/845) ([eputnam](https://github.com/eputnam))
- (MODULES-1127) allow LANGUAGE as valid object_type [#838](https://github.com/puppetlabs/puppetlabs-postgresql/pull/838) ([eputnam](https://github.com/eputnam))
- Support granting SELECT and UPDATE permission on sequences (MODULES-4158) [#823](https://github.com/puppetlabs/puppetlabs-postgresql/pull/823) ([chris-reeves](https://github.com/chris-reeves))

### Fixed

- (MODULES-1707) add logic to params.pp for jdbc driver package on Debian [#847](https://github.com/puppetlabs/puppetlabs-postgresql/pull/847) ([eputnam](https://github.com/eputnam))
- (maint) Schemas for a db should come after db [#840](https://github.com/puppetlabs/puppetlabs-postgresql/pull/840) ([hunner](https://github.com/hunner))
- Fix typo: hostnosssl [#837](https://github.com/puppetlabs/puppetlabs-postgresql/pull/837) ([df7cb](https://github.com/df7cb))
- Fix SQL style on role.pp [#794](https://github.com/puppetlabs/puppetlabs-postgresql/pull/794) ([hasegeli](https://github.com/hasegeli))
- (#3858) Fix unless check in grant_role to work with roles as well as users [#788](https://github.com/puppetlabs/puppetlabs-postgresql/pull/788) ([thunderkeys](https://github.com/thunderkeys))

## [4.8.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.8.0) - 2016-07-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.7.1...4.8.0)

## [4.7.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.7.1) - 2016-02-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.7.0...4.7.1)

### Fixed

- Add missing onlyif_function to sequence grant code [#738](https://github.com/puppetlabs/puppetlabs-postgresql/pull/738) ([cfrantsen](https://github.com/cfrantsen))
- Correctly set $service_provider [#735](https://github.com/puppetlabs/puppetlabs-postgresql/pull/735) ([antaflos](https://github.com/antaflos))

## [4.7.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.7.0) - 2016-02-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.6.1...4.7.0)

### Added

- (MODULES-2960) Allow float postgresql_conf values [#721](https://github.com/puppetlabs/puppetlabs-postgresql/pull/721) ([hunner](https://github.com/hunner))

## [4.6.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.6.1) - 2015-12-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.6.0...4.6.1)

## [4.6.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.6.0) - 2015-09-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.5.0...4.6.0)

### Fixed

- Fix postgis default package name on RedHat [#674](https://github.com/puppetlabs/puppetlabs-postgresql/pull/674) ([ckaenzig](https://github.com/ckaenzig))

## [4.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.5.0) - 2015-07-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.4.2...4.5.0)

## [4.4.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.4.2) - 2015-07-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.4.1...4.4.2)

### Added

- (#2056) Added 9.4, corrected past versions based on docs [#625](https://github.com/puppetlabs/puppetlabs-postgresql/pull/625) ([cjestel](https://github.com/cjestel))

### Fixed

- (MODULES-2185) Fix `withenv` execution under Puppet 2.7 [#664](https://github.com/puppetlabs/puppetlabs-postgresql/pull/664) ([domcleal](https://github.com/domcleal))

## [4.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.4.1) - 2015-07-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.4.0...4.4.1)

### Fixed

- (MODULES-2181) Fix variable scope for systemd-override [#659](https://github.com/puppetlabs/puppetlabs-postgresql/pull/659) ([kbarber](https://github.com/kbarber))

## [4.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.4.0) - 2015-06-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.3.0...4.4.0)

### Added

- (MODULES-1761) Provide defined resource for managing recovery.conf [#603](https://github.com/puppetlabs/puppetlabs-postgresql/pull/603) ([dacrome](https://github.com/dacrome))

### Fixed

- (FM-2931) fixes logic problem with onlyif type param validation. [#654](https://github.com/puppetlabs/puppetlabs-postgresql/pull/654) ([bmjen](https://github.com/bmjen))
- Fixed systemd override for manage_repo package versions [#639](https://github.com/puppetlabs/puppetlabs-postgresql/pull/639) ([cdenneen](https://github.com/cdenneen))
- Apt fix [#618](https://github.com/puppetlabs/puppetlabs-postgresql/pull/618) ([tphoney](https://github.com/tphoney))
- Fix URLs in metadata.json [#599](https://github.com/puppetlabs/puppetlabs-postgresql/pull/599) ([raphink](https://github.com/raphink))

## [4.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.3.0) - 2015-03-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.2.0...4.3.0)

## [4.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.2.0) - 2015-03-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.1.0...4.2.0)

### Fixed

- Fix comment detection [#559](https://github.com/puppetlabs/puppetlabs-postgresql/pull/559) ([hunner](https://github.com/hunner))
- Fix comment detection [#558](https://github.com/puppetlabs/puppetlabs-postgresql/pull/558) ([hunner](https://github.com/hunner))

## [4.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.1.0) - 2014-11-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.0.0...4.1.0)

### Fixed

- fix future parser error [#504](https://github.com/puppetlabs/puppetlabs-postgresql/pull/504) ([steeef](https://github.com/steeef))

## [4.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.0.0) - 2014-09-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.4.2...4.0.0)

### Fixed

- Fixes the accidental erasing of pg_ident.conf [#464](https://github.com/puppetlabs/puppetlabs-postgresql/pull/464) ([txaj](https://github.com/txaj))

## [3.4.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.4.2) - 2014-08-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.4.1...3.4.2)

## [3.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.4.1) - 2014-07-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.4.0...3.4.1)

## [3.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.4.0) - 2014-07-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.3...3.4.0)

### Added

- postgis support [#280](https://github.com/puppetlabs/puppetlabs-postgresql/pull/280) ([kitchen](https://github.com/kitchen))

### Fixed

- This corrects the location of the pg_hba config file on debian oses in tests [#440](https://github.com/puppetlabs/puppetlabs-postgresql/pull/440) ([justinstoller](https://github.com/justinstoller))
- Fix trailing }. [#436](https://github.com/puppetlabs/puppetlabs-postgresql/pull/436) ([apenney](https://github.com/apenney))
- Fix postgresql_conf quote logic [#297](https://github.com/puppetlabs/puppetlabs-postgresql/pull/297) ([reidmv](https://github.com/reidmv))

## [3.3.3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.3) - 2014-03-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.2...3.3.3)

## [3.3.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.2) - 2014-03-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.1...3.3.2)

## [3.3.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.1) - 2014-02-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.0...3.3.1)

## [3.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.0) - 2014-01-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.2.0...3.3.0)

### Added

- Add support to custom xlogdir parameter [#256](https://github.com/puppetlabs/puppetlabs-postgresql/pull/256) ([mnencia](https://github.com/mnencia))

### Fixed

- Fix typo, clearly from a copy/paste mistake [#347](https://github.com/puppetlabs/puppetlabs-postgresql/pull/347) ([mhagander](https://github.com/mhagander))
- fix for concat error [#343](https://github.com/puppetlabs/puppetlabs-postgresql/pull/343) ([flypenguin](https://github.com/flypenguin))
- Fix NOREPLICATION option for Postgres 9.1 [#333](https://github.com/puppetlabs/puppetlabs-postgresql/pull/333) ([brandonwamboldt](https://github.com/brandonwamboldt))
- Wrong parameter name: manage_pg_conf -> manage_pg_hba_conf [#324](https://github.com/puppetlabs/puppetlabs-postgresql/pull/324) ([aadamovich](https://github.com/aadamovich))
- Fix table_grant_spec to show a bug [#310](https://github.com/puppetlabs/puppetlabs-postgresql/pull/310) ([mcanevet](https://github.com/mcanevet))

## [3.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.2.0) - 2013-11-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.1.0...3.2.0)

## [3.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.1.0) - 2013-10-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0...3.1.0)

### Fixed

- (GH-198) Fix race condition on startup [#292](https://github.com/puppetlabs/puppetlabs-postgresql/pull/292) ([kbarber](https://github.com/kbarber))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0) - 2013-10-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0-rc3...3.0.0)

## [3.0.0-rc3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0-rc3) - 2013-10-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0-rc2...3.0.0-rc3)

## [3.0.0-rc2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0-rc2) - 2013-10-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0-rc1...3.0.0-rc2)

## [3.0.0-rc1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0-rc1) - 2013-10-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.5.0...3.0.0-rc1)

### Fixed

- Fixing small typos [#248](https://github.com/puppetlabs/puppetlabs-postgresql/pull/248) ([ggeldenhuis](https://github.com/ggeldenhuis))

## [2.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.5.0) - 2013-09-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.4.1...2.5.0)

## [2.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.4.1) - 2013-08-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.4.0...2.4.1)

### Fixed

- (GH-216) Alter role call not idempotent with cleartext passwords [#225](https://github.com/puppetlabs/puppetlabs-postgresql/pull/225) ([kbarber](https://github.com/kbarber))

## [2.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.4.0) - 2013-08-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.3.0...2.4.0)

## [2.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.3.0) - 2013-06-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.2.1...2.3.0)

## [2.2.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.2.1) - 2013-04-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.2.0...2.2.1)

## [2.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.2.0) - 2013-04-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.1.1...2.2.0)

## [2.1.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.1.1) - 2013-02-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.1.0...2.1.1)

## [2.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.1.0) - 2013-02-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.0.1...2.1.0)

## [2.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.0.1) - 2013-01-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.0.0...2.0.1)

## [2.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.0.0) - 2013-01-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/1.0.0...2.0.0)

### Added

- Defining ACLs in pg_hba.conf [#20](https://github.com/puppetlabs/puppetlabs-postgresql/pull/20) ([dharwood](https://github.com/dharwood))

### Fixed

- Syntax Error [#55](https://github.com/puppetlabs/puppetlabs-postgresql/pull/55) ([Spenser309](https://github.com/Spenser309))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/1.0.0) - 2012-10-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/release-0.3.0...1.0.0)

## [release-0.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/release-0.3.0) - 2012-09-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/release-0.2.0...release-0.3.0)

## [release-0.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/release-0.2.0) - 2012-08-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/release-0.0.1...release-0.2.0)

## [release-0.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/release-0.0.1) - 2012-05-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/01c9cbeb7c3bd5c7bd067c5d7438df7d34027fbc...release-0.0.1)
