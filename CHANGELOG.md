<!-- markdownlint-disable MD024 -->
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

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

### Changed
- Support setting default_privileges on all schemas [#1298](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1298) ([fish-face](https://github.com/fish-face))

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

### Added

- Add DNF module management [#1239](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1239) ([ekohl](https://github.com/ekohl))

### Changed
- pdksync - (MAINT) Remove SLES 11 support [#1247](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1247) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - (MAINT) Remove RHEL 5 family support [#1246](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1246) ([sanfrancrisko](https://github.com/sanfrancrisko))
- pdksync - Remove Puppet 5 from testing and bump minimal version to 6.0.0 [#1238](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1238) ([carabasdaniel](https://github.com/carabasdaniel))

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

### Added

- Add Fedora 30 compatibility [#1067](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1067) ([blackknight36](https://github.com/blackknight36))
- Include EL8 version for config checks [#1060](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1060) ([ehelms](https://github.com/ehelms))

### Changed
- pdksync - (MODULES-8444) - Raise lower Puppet bound [#1070](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1070) ([david22swan](https://github.com/david22swan))
- (maint) remove inconsistent extra variable [#1044](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1044) ([binford2k](https://github.com/binford2k))

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

### Added

- Add compatibility for Fedora 28 [#994](https://github.com/puppetlabs/puppetlabs-postgresql/pull/994) ([jflorian](https://github.com/jflorian))
- (MODULES-5994) Add debian 9 [#992](https://github.com/puppetlabs/puppetlabs-postgresql/pull/992) ([hunner](https://github.com/hunner))
- Adding default Postgresql version for Ubuntu 18.04 [#981](https://github.com/puppetlabs/puppetlabs-postgresql/pull/981) ([lutaylor](https://github.com/lutaylor))
- Parameters `roles`, `config_entires`, and `pg_hba_rules` to `postgresql::server` for hiera [#950](https://github.com/puppetlabs/puppetlabs-postgresql/pull/950) ([ekohl](https://github.com/ekohl))

### Changed
- Fix creation of recovery.conf file when recovery configuration is not specified [#995](https://github.com/puppetlabs/puppetlabs-postgresql/pull/995) ([cdloh](https://github.com/cdloh))

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

### Fixed

- defaulted psql_path to postgresql::server::psql_path [#947](https://github.com/puppetlabs/puppetlabs-postgresql/pull/947) ([crayfishx](https://github.com/crayfishx))

### Other

- (maint) - Skip run_puppet_access_login on LTS [#956](https://github.com/puppetlabs/puppetlabs-postgresql/pull/956) ([pmcmaw](https://github.com/pmcmaw))
- add task listing to README, edit [#955](https://github.com/puppetlabs/puppetlabs-postgresql/pull/955) ([jbondpdx](https://github.com/jbondpdx))
- 5.3.0 Pre Release [#954](https://github.com/puppetlabs/puppetlabs-postgresql/pull/954) ([david22swan](https://github.com/david22swan))
- Rubocop Process Complete [#953](https://github.com/puppetlabs/puppetlabs-postgresql/pull/953) ([david22swan](https://github.com/david22swan))
- (MODULES-6608) - Adding puppet requirement for tasks versioncmp in beaker-task_helper [#952](https://github.com/puppetlabs/puppetlabs-postgresql/pull/952) ([pmcmaw](https://github.com/pmcmaw))
-  Support extension schemas [#948](https://github.com/puppetlabs/puppetlabs-postgresql/pull/948) ([hasegeli](https://github.com/hasegeli))
- (maint) modulesync 65530a4 Update Travis [#946](https://github.com/puppetlabs/puppetlabs-postgresql/pull/946) ([michaeltlombardi](https://github.com/michaeltlombardi))
- Inherit 9.6 settings for later PgSQL version on FreeBSD [#945](https://github.com/puppetlabs/puppetlabs-postgresql/pull/945) ([olevole](https://github.com/olevole))
- (maint) - modulesync 384f4c1 [#944](https://github.com/puppetlabs/puppetlabs-postgresql/pull/944) ([tphoney](https://github.com/tphoney))
- According to the puppet doc, Pattern should be a list of regex. [#942](https://github.com/puppetlabs/puppetlabs-postgresql/pull/942) ([PierreR](https://github.com/PierreR))
- MODULES-6194 - Add scram-sha-256 as a valid pg_hba_rule auth method [#941](https://github.com/puppetlabs/puppetlabs-postgresql/pull/941) ([f3nry](https://github.com/f3nry))
- (maint) - modulesync 1d81b6a [#939](https://github.com/puppetlabs/puppetlabs-postgresql/pull/939) ([pmcmaw](https://github.com/pmcmaw))
- Merge back release (5.2.1) into master [#938](https://github.com/puppetlabs/puppetlabs-postgresql/pull/938) ([glennsarti](https://github.com/glennsarti))
- (MODULES-6014) Add support for Fedora 27 to puppetlabs-postgresql [#937](https://github.com/puppetlabs/puppetlabs-postgresql/pull/937) ([blackknight36](https://github.com/blackknight36))
- This pull request fixes an augeas warning  [#935](https://github.com/puppetlabs/puppetlabs-postgresql/pull/935) ([iakovgan](https://github.com/iakovgan))
- FM-6445 add a task [#930](https://github.com/puppetlabs/puppetlabs-postgresql/pull/930) ([tphoney](https://github.com/tphoney))
- add ensure=>absent to postgresql::server::role [#897](https://github.com/puppetlabs/puppetlabs-postgresql/pull/897) ([georgehansper](https://github.com/georgehansper))

## [5.2.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.2.1) - 2017-11-14

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.2.0...5.2.1)

### Fixed

- add parameter "version" to postgresql::server::extension - fix dependency on database [#932](https://github.com/puppetlabs/puppetlabs-postgresql/pull/932) ([georgehansper](https://github.com/georgehansper))

### Other

- (maint) - Removing Debian 9 [#936](https://github.com/puppetlabs/puppetlabs-postgresql/pull/936) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-5956) fixes for postgresql release [#934](https://github.com/puppetlabs/puppetlabs-postgresql/pull/934) ([jbondpdx](https://github.com/jbondpdx))
- (MODULES-5955) release prep for 5.2.1 [#933](https://github.com/puppetlabs/puppetlabs-postgresql/pull/933) ([eputnam](https://github.com/eputnam))
- 5.2.0 Release Mergeback [#928](https://github.com/puppetlabs/puppetlabs-postgresql/pull/928) ([HelenCampbell](https://github.com/HelenCampbell))

## [5.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.2.0) - 2017-10-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.1.0...5.2.0)

### Other

- Updates to Changelog for release prep [#927](https://github.com/puppetlabs/puppetlabs-postgresql/pull/927) ([pmcmaw](https://github.com/pmcmaw))
- Merge master into release [#926](https://github.com/puppetlabs/puppetlabs-postgresql/pull/926) ([HelenCampbell](https://github.com/HelenCampbell))
- (PUP-8008) monkey patch spec_helper_acceptance [#925](https://github.com/puppetlabs/puppetlabs-postgresql/pull/925) ([eputnam](https://github.com/eputnam))
- (PUP-8008) monkey patch spec_helper_acceptance [#924](https://github.com/puppetlabs/puppetlabs-postgresql/pull/924) ([eputnam](https://github.com/eputnam))
- (FM-6386) Minor docs fixup for 5.2.0 release [#923](https://github.com/puppetlabs/puppetlabs-postgresql/pull/923) ([HAIL9000](https://github.com/HAIL9000))
- Removing Debian 6 and adding Debian 9 [#921](https://github.com/puppetlabs/puppetlabs-postgresql/pull/921) ([pmcmaw](https://github.com/pmcmaw))
- 5.2.0 Release Prep [#920](https://github.com/puppetlabs/puppetlabs-postgresql/pull/920) ([HelenCampbell](https://github.com/HelenCampbell))
- Updates test to reflect new error message [#919](https://github.com/puppetlabs/puppetlabs-postgresql/pull/919) ([HelenCampbell](https://github.com/HelenCampbell))
- (maint) modulesync 892c4cf [#918](https://github.com/puppetlabs/puppetlabs-postgresql/pull/918) ([HAIL9000](https://github.com/HAIL9000))
-  enhance --data-checksums on initdb [#915](https://github.com/puppetlabs/puppetlabs-postgresql/pull/915) ([mmoll](https://github.com/mmoll))
- use postgresql 9.6 for the newest SLES and openSUSE releases [#914](https://github.com/puppetlabs/puppetlabs-postgresql/pull/914) ([tampakrap](https://github.com/tampakrap))
- Change - Add support for Fedora 26 [#913](https://github.com/puppetlabs/puppetlabs-postgresql/pull/913) ([blackknight36](https://github.com/blackknight36))
- (MODULES-5501) - Remove unsupported Ubuntu [#912](https://github.com/puppetlabs/puppetlabs-postgresql/pull/912) ([pmcmaw](https://github.com/pmcmaw))
- Added default  posgresql version of Ubuntu 17.4 version to the global… [#911](https://github.com/puppetlabs/puppetlabs-postgresql/pull/911) ([hozmaster](https://github.com/hozmaster))
- (MODULES-4854) remove allow_deprecations [#910](https://github.com/puppetlabs/puppetlabs-postgresql/pull/910) ([eputnam](https://github.com/eputnam))
- MODULES-5378 fix the change in error message [#909](https://github.com/puppetlabs/puppetlabs-postgresql/pull/909) ([tphoney](https://github.com/tphoney))
- MODULES-5378 fix error message checking in test [#908](https://github.com/puppetlabs/puppetlabs-postgresql/pull/908) ([tphoney](https://github.com/tphoney))
- (maint) modulesync 915cde70e20 [#907](https://github.com/puppetlabs/puppetlabs-postgresql/pull/907) ([glennsarti](https://github.com/glennsarti))
- (MODULES-5232) - Updating docs formatting. [#905](https://github.com/puppetlabs/puppetlabs-postgresql/pull/905) ([pmcmaw](https://github.com/pmcmaw))
- 5.1.0 Release Mergeback [#904](https://github.com/puppetlabs/puppetlabs-postgresql/pull/904) ([HelenCampbell](https://github.com/HelenCampbell))
- Replace deprecated function calls [#901](https://github.com/puppetlabs/puppetlabs-postgresql/pull/901) ([matonb](https://github.com/matonb))
- Default contcat order [#900](https://github.com/puppetlabs/puppetlabs-postgresql/pull/900) ([matonb](https://github.com/matonb))
- Deprecated tests [#899](https://github.com/puppetlabs/puppetlabs-postgresql/pull/899) ([matonb](https://github.com/matonb))
- add parameter "version" to postgresql::server::extension to update the extension version [#896](https://github.com/puppetlabs/puppetlabs-postgresql/pull/896) ([georgehansper](https://github.com/georgehansper))
- (MODULES-4682) Pass default_connect_settings to validate service [#862](https://github.com/puppetlabs/puppetlabs-postgresql/pull/862) ([vinzent](https://github.com/vinzent))

## [5.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.1.0) - 2017-07-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/5.0.0...5.1.0)

### Other

- (MODULES-4711) - 5.1.0 Release Prep [#903](https://github.com/puppetlabs/puppetlabs-postgresql/pull/903) ([pmcmaw](https://github.com/pmcmaw))
- Adding a space for header formatting [#902](https://github.com/puppetlabs/puppetlabs-postgresql/pull/902) ([pmcmaw](https://github.com/pmcmaw))
- (FM-6240) only run test on postgresql >= 9.0 [#898](https://github.com/puppetlabs/puppetlabs-postgresql/pull/898) ([tphoney](https://github.com/tphoney))
- (MODULES-5187) mysnc puppet 5 and ruby 2.4 [#895](https://github.com/puppetlabs/puppetlabs-postgresql/pull/895) ([eputnam](https://github.com/eputnam))
- add defined type postgresql::server::reassign_owned_by [#894](https://github.com/puppetlabs/puppetlabs-postgresql/pull/894) ([georgehansper](https://github.com/georgehansper))
- Allow order parameter to be string value [#893](https://github.com/puppetlabs/puppetlabs-postgresql/pull/893) ([matonb](https://github.com/matonb))
- Fix Ruby 2.4 deprecation in postgresql_acls_to_resources_hash [#892](https://github.com/puppetlabs/puppetlabs-postgresql/pull/892) ([mmoll](https://github.com/mmoll))
- (MODULES-5144) Prep for puppet 5 [#889](https://github.com/puppetlabs/puppetlabs-postgresql/pull/889) ([hunner](https://github.com/hunner))
- use https for apt.postgresql.org repo [#888](https://github.com/puppetlabs/puppetlabs-postgresql/pull/888) ([hex2a](https://github.com/hex2a))
- 5.0.0 mergeback [#887](https://github.com/puppetlabs/puppetlabs-postgresql/pull/887) ([hunner](https://github.com/hunner))
- MODULES-2989 parameter ensure of custom resource postgresql_replication_slot is not documented [#884](https://github.com/puppetlabs/puppetlabs-postgresql/pull/884) ([MartyEwings](https://github.com/MartyEwings))
- add data_checksums option to initdb [#878](https://github.com/puppetlabs/puppetlabs-postgresql/pull/878) ([tjikkun](https://github.com/tjikkun))

## [5.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/5.0.0) - 2017-06-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.9.0...5.0.0)

### Changed
- Unset default log_line_prefix [#870](https://github.com/puppetlabs/puppetlabs-postgresql/pull/870) ([hasegeli](https://github.com/hasegeli))
- Let listen_addresses be defined independently [#865](https://github.com/puppetlabs/puppetlabs-postgresql/pull/865) ([hasegeli](https://github.com/hasegeli))

### Other

- (maint) address more changelog cleanup [#886](https://github.com/puppetlabs/puppetlabs-postgresql/pull/886) ([eputnam](https://github.com/eputnam))
- (maint) changelog cleanup for 5.0.0 [#885](https://github.com/puppetlabs/puppetlabs-postgresql/pull/885) ([eputnam](https://github.com/eputnam))
- (MODULES-5062) release prep 5.0.0 [#883](https://github.com/puppetlabs/puppetlabs-postgresql/pull/883) ([eputnam](https://github.com/eputnam))
- (maint) fix for connection validator [#882](https://github.com/puppetlabs/puppetlabs-postgresql/pull/882) ([eputnam](https://github.com/eputnam))
- (MODULES-5050) Fix for grant_schema_spec [#881](https://github.com/puppetlabs/puppetlabs-postgresql/pull/881) ([eputnam](https://github.com/eputnam))
- (MODULES-5050) pass auth_option in grant_role_spec [#880](https://github.com/puppetlabs/puppetlabs-postgresql/pull/880) ([eputnam](https://github.com/eputnam))
- (MODULES-1394) replace validate_db_connection type with custom type [#879](https://github.com/puppetlabs/puppetlabs-postgresql/pull/879) ([eputnam](https://github.com/eputnam))
- Cleanup README [#877](https://github.com/puppetlabs/puppetlabs-postgresql/pull/877) ([hasegeli](https://github.com/hasegeli))
- (maint) mock structured facts [#875](https://github.com/puppetlabs/puppetlabs-postgresql/pull/875) ([eputnam](https://github.com/eputnam))
- (maint) Fix docs for #870 [#873](https://github.com/puppetlabs/puppetlabs-postgresql/pull/873) ([hunner](https://github.com/hunner))
- MODULES-4826 puppetlabs-postgresql: Update the version compatibility to >= 4.7.0 < 5.0.0 [#871](https://github.com/puppetlabs/puppetlabs-postgresql/pull/871) ([marsmensch](https://github.com/marsmensch))
- (MODULES-4947) bump apt dependency in metadata + fixtures [#869](https://github.com/puppetlabs/puppetlabs-postgresql/pull/869) ([bastelfreak](https://github.com/bastelfreak))
- Maintain config entries for PostgreSQL 10 [#868](https://github.com/puppetlabs/puppetlabs-postgresql/pull/868) ([hasegeli](https://github.com/hasegeli))
- (MODULES-4906) Add support for concat 3.0.0 and 4.0.0 [#867](https://github.com/puppetlabs/puppetlabs-postgresql/pull/867) ([dhollinger](https://github.com/dhollinger))
- Release mergeback [#866](https://github.com/puppetlabs/puppetlabs-postgresql/pull/866) ([hunner](https://github.com/hunner))
- MODULES-4324 - README Updates for Translation. [#864](https://github.com/puppetlabs/puppetlabs-postgresql/pull/864) ([pmcmaw](https://github.com/pmcmaw))
- [MODULES-4598] Revert "Revert "fix default params for SUSE family OSes"" [#863](https://github.com/puppetlabs/puppetlabs-postgresql/pull/863) ([mmoll](https://github.com/mmoll))
- [msync] 786266 Implement puppet-module-gems, a45803 Remove metadata.json from locales config [#860](https://github.com/puppetlabs/puppetlabs-postgresql/pull/860) ([wilson208](https://github.com/wilson208))
- [MODULES-4598] Revert "fix default params for SUSE family OSes" [#858](https://github.com/puppetlabs/puppetlabs-postgresql/pull/858) ([wilson208](https://github.com/wilson208))
- (FM-6116) - Adding POT file for metadata.json [#857](https://github.com/puppetlabs/puppetlabs-postgresql/pull/857) ([pmcmaw](https://github.com/pmcmaw))
- [MODULES-4528] Replace Puppet.version.to_f version comparison from spec_helper.rb [#856](https://github.com/puppetlabs/puppetlabs-postgresql/pull/856) ([wilson208](https://github.com/wilson208))
- Align postgis default version with postgres version [#854](https://github.com/puppetlabs/puppetlabs-postgresql/pull/854) ([georgehansper](https://github.com/georgehansper))
- (maint) Fix CI issue where acceptance tests fail on SLES [#853](https://github.com/puppetlabs/puppetlabs-postgresql/pull/853) ([wilson208](https://github.com/wilson208))
- Migrate to puppet4 datatypes [#852](https://github.com/puppetlabs/puppetlabs-postgresql/pull/852) ([bastelfreak](https://github.com/bastelfreak))
- fix default params for SUSE family OSes [#851](https://github.com/puppetlabs/puppetlabs-postgresql/pull/851) ([tampakrap](https://github.com/tampakrap))
- Allowo to disable managing passwords for users [#846](https://github.com/puppetlabs/puppetlabs-postgresql/pull/846) ([bjoernhaeuser](https://github.com/bjoernhaeuser))
- Change - Remove deprecated force parameter on concat resources [#843](https://github.com/puppetlabs/puppetlabs-postgresql/pull/843) ([blackknight36](https://github.com/blackknight36))
- Remove deprecated force parameter from concat [#831](https://github.com/puppetlabs/puppetlabs-postgresql/pull/831) ([ekohl](https://github.com/ekohl))

## [4.9.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.9.0) - 2017-03-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.8.0...4.9.0)

### Changed
- Fix deprecated apt::source parameters [#805](https://github.com/puppetlabs/puppetlabs-postgresql/pull/805) ([adepretis](https://github.com/adepretis))

### Other

- release prep for 4.9.0 [#849](https://github.com/puppetlabs/puppetlabs-postgresql/pull/849) ([eputnam](https://github.com/eputnam))
- Update $allowed_auth_methods for newer PostgreSQL versions 9.5 and 9.6 [#848](https://github.com/puppetlabs/puppetlabs-postgresql/pull/848) ([ardrigh](https://github.com/ardrigh))
- (MODULES-1707) add logic to params.pp for jdbc driver package on Debian [#847](https://github.com/puppetlabs/puppetlabs-postgresql/pull/847) ([eputnam](https://github.com/eputnam))
- (MODULES-1508) add support for unix_socket_directories [#845](https://github.com/puppetlabs/puppetlabs-postgresql/pull/845) ([eputnam](https://github.com/eputnam))
- (maint) accomodate old pgsql version [#844](https://github.com/puppetlabs/puppetlabs-postgresql/pull/844) ([eputnam](https://github.com/eputnam))
- support Debian/stretch and Ubuntu/yakkety [#842](https://github.com/puppetlabs/puppetlabs-postgresql/pull/842) ([mmoll](https://github.com/mmoll))
- (maint) fix grant_spec test [#841](https://github.com/puppetlabs/puppetlabs-postgresql/pull/841) ([eputnam](https://github.com/eputnam))
- (maint) Schemas for a db should come after db [#840](https://github.com/puppetlabs/puppetlabs-postgresql/pull/840) ([hunner](https://github.com/hunner))
- (MODULES-1127) allow LANGUAGE as valid object_type [#838](https://github.com/puppetlabs/puppetlabs-postgresql/pull/838) ([eputnam](https://github.com/eputnam))
- Fix typo: hostnosssl [#837](https://github.com/puppetlabs/puppetlabs-postgresql/pull/837) ([df7cb](https://github.com/df7cb))
- Implement beaker-module_install_helper and cleanup spec_helper_acceptance.rb [#836](https://github.com/puppetlabs/puppetlabs-postgresql/pull/836) ([wilson208](https://github.com/wilson208))
- (MODULES-4098) Sync the rest of the files [#835](https://github.com/puppetlabs/puppetlabs-postgresql/pull/835) ([hunner](https://github.com/hunner))
- Fix validation script to work with dash [#833](https://github.com/puppetlabs/puppetlabs-postgresql/pull/833) ([sathieu](https://github.com/sathieu))
- (MODULES-4097) Sync travis.yml [#832](https://github.com/puppetlabs/puppetlabs-postgresql/pull/832) ([hunner](https://github.com/hunner))
- Remove unnecessary `client_package_name` parameter from server. [#830](https://github.com/puppetlabs/puppetlabs-postgresql/pull/830) ([tdevelioglu](https://github.com/tdevelioglu))
- F25 update [#829](https://github.com/puppetlabs/puppetlabs-postgresql/pull/829) ([blackknight36](https://github.com/blackknight36))
- (FM-5972) gettext and spec.opts [#828](https://github.com/puppetlabs/puppetlabs-postgresql/pull/828) ([eputnam](https://github.com/eputnam))
- Change - Ensure that the postgres data dir has proper selinux context [#827](https://github.com/puppetlabs/puppetlabs-postgresql/pull/827) ([blackknight36](https://github.com/blackknight36))
- (maint) fixes for grant_spec [#826](https://github.com/puppetlabs/puppetlabs-postgresql/pull/826) ([eputnam](https://github.com/eputnam))
- (FM-5939) removes spec.opts [#825](https://github.com/puppetlabs/puppetlabs-postgresql/pull/825) ([eputnam](https://github.com/eputnam))
- (MODULES-3631) msync Gemfile for 1.9 frozen strings [#824](https://github.com/puppetlabs/puppetlabs-postgresql/pull/824) ([hunner](https://github.com/hunner))
- Support granting SELECT and UPDATE permission on sequences (MODULES-4158) [#823](https://github.com/puppetlabs/puppetlabs-postgresql/pull/823) ([chris-reeves](https://github.com/chris-reeves))
- Pick 808 [#821](https://github.com/puppetlabs/puppetlabs-postgresql/pull/821) ([tphoney](https://github.com/tphoney))
- Override repo urls [#820](https://github.com/puppetlabs/puppetlabs-postgresql/pull/820) ([DavidS](https://github.com/DavidS))
- Set permissions/ownership on rpm gpg key [#819](https://github.com/puppetlabs/puppetlabs-postgresql/pull/819) ([benpillet](https://github.com/benpillet))
- (MODULES-4051) updates yum repo [#818](https://github.com/puppetlabs/puppetlabs-postgresql/pull/818) ([eputnam](https://github.com/eputnam))
- Change default user, group and data directory to proper value on Free… [#816](https://github.com/puppetlabs/puppetlabs-postgresql/pull/816) ([olevole](https://github.com/olevole))
- (MODULES-3704) Update gemfile template to be identical [#815](https://github.com/puppetlabs/puppetlabs-postgresql/pull/815) ([hunner](https://github.com/hunner))
- MODULES-3816 no release 3.4.3 fixing changelog [#814](https://github.com/puppetlabs/puppetlabs-postgresql/pull/814) ([tphoney](https://github.com/tphoney))
- Fix grant documentation [#813](https://github.com/puppetlabs/puppetlabs-postgresql/pull/813) ([hasegeli](https://github.com/hasegeli))
- Change - Add default postgres version for Fedora 24 to globals class [#811](https://github.com/puppetlabs/puppetlabs-postgresql/pull/811) ([blackknight36](https://github.com/blackknight36))
- Add support for Gentoo-based operatingsystems [#810](https://github.com/puppetlabs/puppetlabs-postgresql/pull/810) ([optiz0r](https://github.com/optiz0r))
- Fixed unless check in grant_role so that it can grant roles to superusers  [#809](https://github.com/puppetlabs/puppetlabs-postgresql/pull/809) ([crispygoth](https://github.com/crispygoth))
- (MODULES-3983) Update parallel_tests for ruby 2.0.0 [#807](https://github.com/puppetlabs/puppetlabs-postgresql/pull/807) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-1850) replace validate_string by validate_re for real verification on input [#806](https://github.com/puppetlabs/puppetlabs-postgresql/pull/806) ([jhooyberghs](https://github.com/jhooyberghs))
- globals: add postgis version for 9.6 [#804](https://github.com/puppetlabs/puppetlabs-postgresql/pull/804) ([costela](https://github.com/costela))
- Adding a negative test case for grant role [#802](https://github.com/puppetlabs/puppetlabs-postgresql/pull/802) ([pmcmaw](https://github.com/pmcmaw))
- (MODULES-3844) adds single revoke test [#800](https://github.com/puppetlabs/puppetlabs-postgresql/pull/800) ([eputnam](https://github.com/eputnam))
- Update modulesync_config [51f469d] [#799](https://github.com/puppetlabs/puppetlabs-postgresql/pull/799) ([DavidS](https://github.com/DavidS))
- Remove duplicate RedHat default section [#798](https://github.com/puppetlabs/puppetlabs-postgresql/pull/798) ([jesusaurus](https://github.com/jesusaurus))
- Support changing database tablespaces [#795](https://github.com/puppetlabs/puppetlabs-postgresql/pull/795) ([hasegeli](https://github.com/hasegeli))
- Fix SQL style on role.pp [#794](https://github.com/puppetlabs/puppetlabs-postgresql/pull/794) ([hasegeli](https://github.com/hasegeli))
- Default role of grant_role to namevar [#793](https://github.com/puppetlabs/puppetlabs-postgresql/pull/793) ([hasegeli](https://github.com/hasegeli))
- Improvements around changing owners [#792](https://github.com/puppetlabs/puppetlabs-postgresql/pull/792) ([hasegeli](https://github.com/hasegeli))
- Revert "Update config_entry.pp add ability to set log_min_duration_statement" [#791](https://github.com/puppetlabs/puppetlabs-postgresql/pull/791) ([hasegeli](https://github.com/hasegeli))
- (#3858) Fix unless check in grant_role to work with roles as well as users [#788](https://github.com/puppetlabs/puppetlabs-postgresql/pull/788) ([thunderkeys](https://github.com/thunderkeys))
- Update modulesync_config [a3fe424] [#787](https://github.com/puppetlabs/puppetlabs-postgresql/pull/787) ([DavidS](https://github.com/DavidS))
- Allow working directory to be configurable via globals (instead of always using /tmp) [#786](https://github.com/puppetlabs/puppetlabs-postgresql/pull/786) ([hdeadman](https://github.com/hdeadman))
- handle case where default database name is not the same as user [#785](https://github.com/puppetlabs/puppetlabs-postgresql/pull/785) ([hdeadman](https://github.com/hdeadman))
- Merge back [#783](https://github.com/puppetlabs/puppetlabs-postgresql/pull/783) ([DavidS](https://github.com/DavidS))
- (MAINT) Update for modulesync_config 72d19f184 [#782](https://github.com/puppetlabs/puppetlabs-postgresql/pull/782) ([DavidS](https://github.com/DavidS))
- Add .erb suffix to recovery.conf template [#777](https://github.com/puppetlabs/puppetlabs-postgresql/pull/777) ([tdevelioglu](https://github.com/tdevelioglu))
- Allow username and password as integers [#774](https://github.com/puppetlabs/puppetlabs-postgresql/pull/774) ([sathieu](https://github.com/sathieu))
- Grant role with unit tests [#762](https://github.com/puppetlabs/puppetlabs-postgresql/pull/762) ([janfabry](https://github.com/janfabry))

## [4.8.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.8.0) - 2016-07-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.7.1...4.8.0)

### Other

- Prep for 4.8.0 [#781](https://github.com/puppetlabs/puppetlabs-postgresql/pull/781) ([DavidS](https://github.com/DavidS))
- (MODULES-3247) Enable schema and database ownership change [#779](https://github.com/puppetlabs/puppetlabs-postgresql/pull/779) ([ntpttr](https://github.com/ntpttr))
- (MODULES-3581) modulesync [067d08a] [#778](https://github.com/puppetlabs/puppetlabs-postgresql/pull/778) ([DavidS](https://github.com/DavidS))
- {maint} modulesync 0794b2c [#776](https://github.com/puppetlabs/puppetlabs-postgresql/pull/776) ([tphoney](https://github.com/tphoney))
- Update config_entry.pp add ability to set log_min_duration_statement [#773](https://github.com/puppetlabs/puppetlabs-postgresql/pull/773) ([micah-uber](https://github.com/micah-uber))
- Let the module handle OpenBSD 6.x versions  [#772](https://github.com/puppetlabs/puppetlabs-postgresql/pull/772) ([buzzdeee](https://github.com/buzzdeee))
- (MODULES-3442) Use empty array for missing resource relationships [#771](https://github.com/puppetlabs/puppetlabs-postgresql/pull/771) ([domcleal](https://github.com/domcleal))
- don't create empty lines in recovery template [#769](https://github.com/puppetlabs/puppetlabs-postgresql/pull/769) ([bastelfreak](https://github.com/bastelfreak))
- (maint) fix broken links in readme [#767](https://github.com/puppetlabs/puppetlabs-postgresql/pull/767) ([wkalt](https://github.com/wkalt))
- (MODULES-3416) Add Fedora 24 with PostgreSQL 9.5 [#766](https://github.com/puppetlabs/puppetlabs-postgresql/pull/766) ([domcleal](https://github.com/domcleal))
- Don't overwrite or calculate the environment twice [#761](https://github.com/puppetlabs/puppetlabs-postgresql/pull/761) ([janfabry](https://github.com/janfabry))
- Fix validation script to work with FreeBSD. [#760](https://github.com/puppetlabs/puppetlabs-postgresql/pull/760) ([blackknight36](https://github.com/blackknight36))
- Update to newest modulesync_configs [9ca280f] [#759](https://github.com/puppetlabs/puppetlabs-postgresql/pull/759) ([DavidS](https://github.com/DavidS))
- (MODULES-3241) Add fedora 23 [#758](https://github.com/puppetlabs/puppetlabs-postgresql/pull/758) ([hunner](https://github.com/hunner))
- (maint) fix test to run under strict variables [#755](https://github.com/puppetlabs/puppetlabs-postgresql/pull/755) ([DavidS](https://github.com/DavidS))
- Adds timestamps into logs by default [#754](https://github.com/puppetlabs/puppetlabs-postgresql/pull/754) ([xprazak2](https://github.com/xprazak2))
- Minor Fixes on the Documentation [#752](https://github.com/puppetlabs/puppetlabs-postgresql/pull/752) ([hasegeli](https://github.com/hasegeli))
- prevent information leak of database user password [#749](https://github.com/puppetlabs/puppetlabs-postgresql/pull/749) ([buzzdeee](https://github.com/buzzdeee))
- Remove unused variable and update template comment [#748](https://github.com/puppetlabs/puppetlabs-postgresql/pull/748) ([hunner](https://github.com/hunner))
- Fix issues with missing parameters in `server` class [#747](https://github.com/puppetlabs/puppetlabs-postgresql/pull/747) ([cyberious](https://github.com/cyberious))
- Ubuntu/vidid and newer use systemd [#746](https://github.com/puppetlabs/puppetlabs-postgresql/pull/746) ([mmoll](https://github.com/mmoll))
- Mergeback 4.7.x to master [#745](https://github.com/puppetlabs/puppetlabs-postgresql/pull/745) ([bmjen](https://github.com/bmjen))

## [4.7.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.7.1) - 2016-02-18

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.7.0...4.7.1)

### Other

- Update quoting because addresses are not floats [#744](https://github.com/puppetlabs/puppetlabs-postgresql/pull/744) ([hunner](https://github.com/hunner))
- 4.7.1 Release Prep [#743](https://github.com/puppetlabs/puppetlabs-postgresql/pull/743) ([bmjen](https://github.com/bmjen))
- Revert "Add postgresql_version fact" [#742](https://github.com/puppetlabs/puppetlabs-postgresql/pull/742) ([bmjen](https://github.com/bmjen))
- (FM-4046) Update to current msync configs [006831f] [#741](https://github.com/puppetlabs/puppetlabs-postgresql/pull/741) ([DavidS](https://github.com/DavidS))
- Add missing onlyif_function to sequence grant code [#738](https://github.com/puppetlabs/puppetlabs-postgresql/pull/738) ([cfrantsen](https://github.com/cfrantsen))
- correcting formatting error in README [#737](https://github.com/puppetlabs/puppetlabs-postgresql/pull/737) ([jbondpdx](https://github.com/jbondpdx))
- postgres server init script naming on amazon linux ami [#736](https://github.com/puppetlabs/puppetlabs-postgresql/pull/736) ([Aselinux](https://github.com/Aselinux))
- Correctly set $service_provider [#735](https://github.com/puppetlabs/puppetlabs-postgresql/pull/735) ([antaflos](https://github.com/antaflos))
- Archlinux service reload parameter is incorrect. [#734](https://github.com/puppetlabs/puppetlabs-postgresql/pull/734) ([gfokkema](https://github.com/gfokkema))
- Fix markdown error in README [#732](https://github.com/puppetlabs/puppetlabs-postgresql/pull/732) ([martijn](https://github.com/martijn))
- amazon linux defaults to postgresql92 now [#731](https://github.com/puppetlabs/puppetlabs-postgresql/pull/731) ([shawn-sterling](https://github.com/shawn-sterling))
- 4.7.x mergeback to master [#730](https://github.com/puppetlabs/puppetlabs-postgresql/pull/730) ([bmjen](https://github.com/bmjen))
- Fix quoting [#729](https://github.com/puppetlabs/puppetlabs-postgresql/pull/729) ([hunner](https://github.com/hunner))
- Allow puppetlabs-concat 2.x [#725](https://github.com/puppetlabs/puppetlabs-postgresql/pull/725) ([brandonweeks](https://github.com/brandonweeks))
- Add postgresql_version fact [#720](https://github.com/puppetlabs/puppetlabs-postgresql/pull/720) ([jyaworski](https://github.com/jyaworski))
- Fix password change failing [#719](https://github.com/puppetlabs/puppetlabs-postgresql/pull/719) ([matonb](https://github.com/matonb))

## [4.7.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.7.0) - 2016-02-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.6.1...4.7.0)

### Other

- (MODULES-3024) Quote database objects when creating databases [#727](https://github.com/puppetlabs/puppetlabs-postgresql/pull/727) ([supercow](https://github.com/supercow))
- Escape case where password ends with '$'. [#726](https://github.com/puppetlabs/puppetlabs-postgresql/pull/726) ([Farzy](https://github.com/Farzy))
- Changelog, metadata and nodeset update for 4.7.0 [#724](https://github.com/puppetlabs/puppetlabs-postgresql/pull/724) ([HelenCampbell](https://github.com/HelenCampbell))
- Whoops [#723](https://github.com/puppetlabs/puppetlabs-postgresql/pull/723) ([hunner](https://github.com/hunner))
- MODULES-3019 - Schedule apt update after install of repo [#722](https://github.com/puppetlabs/puppetlabs-postgresql/pull/722) ([erikanderson](https://github.com/erikanderson))
- (MODULES-2960) Allow float postgresql_conf values [#721](https://github.com/puppetlabs/puppetlabs-postgresql/pull/721) ([hunner](https://github.com/hunner))
- FM-4657: postgresql edit pass [#718](https://github.com/puppetlabs/puppetlabs-postgresql/pull/718) ([jbondpdx](https://github.com/jbondpdx))
- Fix postgresql::server acceptance test descriptions [#717](https://github.com/puppetlabs/puppetlabs-postgresql/pull/717) ([gerhardsam](https://github.com/gerhardsam))
- Add default postgis version for 9.5 [#716](https://github.com/puppetlabs/puppetlabs-postgresql/pull/716) ([hunner](https://github.com/hunner))
- (FM-4049) update to modulesync_configs [#715](https://github.com/puppetlabs/puppetlabs-postgresql/pull/715) ([DavidS](https://github.com/DavidS))
- DOC-1496: README re-write. [#714](https://github.com/puppetlabs/puppetlabs-postgresql/pull/714) ([jtappa](https://github.com/jtappa))
- OpenBSD 5.9 will also ship a PostgreSQL 9.4 version [#712](https://github.com/puppetlabs/puppetlabs-postgresql/pull/712) ([buzzdeee](https://github.com/buzzdeee))
- Add support for Ubuntu 15.10 [#711](https://github.com/puppetlabs/puppetlabs-postgresql/pull/711) ([pherjung](https://github.com/pherjung))
- 4.6.x Mergeback [#710](https://github.com/puppetlabs/puppetlabs-postgresql/pull/710) ([HelenCampbell](https://github.com/HelenCampbell))
- readme update: postgresql::server::db is a defined type not a class [#709](https://github.com/puppetlabs/puppetlabs-postgresql/pull/709) ([jessereynolds](https://github.com/jessereynolds))

## [4.6.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.6.1) - 2015-12-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.6.0...4.6.1)

### Added

- Added parameter to disable automatic service restarts on config changes [#699](https://github.com/puppetlabs/puppetlabs-postgresql/pull/699) ([sw0x2A](https://github.com/sw0x2A))

### Other

- fix quote around locale options [#708](https://github.com/puppetlabs/puppetlabs-postgresql/pull/708) ([freegenie](https://github.com/freegenie))
- 4.6.1 release prep [#707](https://github.com/puppetlabs/puppetlabs-postgresql/pull/707) ([tphoney](https://github.com/tphoney))
- (maint) removes ruby 1.8.7 and puppet 2.7 from travis-ci jobs [#706](https://github.com/puppetlabs/puppetlabs-postgresql/pull/706) ([bmjen](https://github.com/bmjen))
- OpenBSD version is now 9.4 [#705](https://github.com/puppetlabs/puppetlabs-postgresql/pull/705) ([oriold](https://github.com/oriold))
- Fix default paths for Amazon Linux [#704](https://github.com/puppetlabs/puppetlabs-postgresql/pull/704) ([downsj2](https://github.com/downsj2))
- Fix line endings [#703](https://github.com/puppetlabs/puppetlabs-postgresql/pull/703) ([karyon](https://github.com/karyon))
- Use double qoutes around database name. [#702](https://github.com/puppetlabs/puppetlabs-postgresql/pull/702) ([stintel](https://github.com/stintel))
- Remove extra blanks and backslashes. [#701](https://github.com/puppetlabs/puppetlabs-postgresql/pull/701) ([smortex](https://github.com/smortex))
- syntax error near UTF8 [#700](https://github.com/puppetlabs/puppetlabs-postgresql/pull/700) ([BobVanB](https://github.com/BobVanB))
- "fedora 22 postgresql version 9.4" [#698](https://github.com/puppetlabs/puppetlabs-postgresql/pull/698) ([nibalizer](https://github.com/nibalizer))
- Change apt::pin to apt_postgresql_org to prevent error message [#695](https://github.com/puppetlabs/puppetlabs-postgresql/pull/695) ([Danie](https://github.com/Danie))
- MODULES-2525 - updated systemd-override to support fedora and CentOS paths for systemd [#694](https://github.com/puppetlabs/puppetlabs-postgresql/pull/694) ([jbehrends](https://github.com/jbehrends))
- Fixes MODULES_2059 - adds extension argument [#693](https://github.com/puppetlabs/puppetlabs-postgresql/pull/693) ([frconil](https://github.com/frconil))
- 4.6.x mergeback to master [#692](https://github.com/puppetlabs/puppetlabs-postgresql/pull/692) ([bmjen](https://github.com/bmjen))
- updates metadata.json to match Puppet 4.x PMT output [#691](https://github.com/puppetlabs/puppetlabs-postgresql/pull/691) ([bmjen](https://github.com/bmjen))
- removed inherits postgresql::params [#679](https://github.com/puppetlabs/puppetlabs-postgresql/pull/679) ([vicinus](https://github.com/vicinus))

## [4.6.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.6.0) - 2015-09-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.5.0...4.6.0)

### Other

- (MAINT) do not run the multi-node tests by default [#689](https://github.com/puppetlabs/puppetlabs-postgresql/pull/689) ([DavidS](https://github.com/DavidS))
- (MODULES-661) Remote DB support [#688](https://github.com/puppetlabs/puppetlabs-postgresql/pull/688) ([DavidS](https://github.com/DavidS))
- 4_6_0 release prep [#682](https://github.com/puppetlabs/puppetlabs-postgresql/pull/682) ([tphoney](https://github.com/tphoney))
- Decouple pg_hba_rule from postgresql::server [#678](https://github.com/puppetlabs/puppetlabs-postgresql/pull/678) ([npwalker](https://github.com/npwalker))
- (MODULES-2211) Fixed systemd-override for RedHat systems with unmanag… [#677](https://github.com/puppetlabs/puppetlabs-postgresql/pull/677) ([cavaliercoder](https://github.com/cavaliercoder))
- Fix postgis default package name on RedHat [#674](https://github.com/puppetlabs/puppetlabs-postgresql/pull/674) ([ckaenzig](https://github.com/ckaenzig))
- Add proxy option for yum repositories [#672](https://github.com/puppetlabs/puppetlabs-postgresql/pull/672) ([GoozeyX](https://github.com/GoozeyX))
- Allow for undefined PostGIS version. [#671](https://github.com/puppetlabs/puppetlabs-postgresql/pull/671) ([SteveMaddison](https://github.com/SteveMaddison))

## [4.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.5.0) - 2015-07-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.4.2...4.5.0)

### Other

- Prep 4.5.0 [#676](https://github.com/puppetlabs/puppetlabs-postgresql/pull/676) ([hunner](https://github.com/hunner))
- Mergeback 4.4.x to master [#670](https://github.com/puppetlabs/puppetlabs-postgresql/pull/670) ([hunner](https://github.com/hunner))
- Update README.md [#666](https://github.com/puppetlabs/puppetlabs-postgresql/pull/666) ([levenaux](https://github.com/levenaux))

## [4.4.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.4.2) - 2015-07-08

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.4.1...4.4.2)

### Added

- (#2056) Added 9.4, corrected past versions based on docs [#625](https://github.com/puppetlabs/puppetlabs-postgresql/pull/625) ([cjestel](https://github.com/cjestel))

### Other

- Fix incorrect metadata [#669](https://github.com/puppetlabs/puppetlabs-postgresql/pull/669) ([hunner](https://github.com/hunner))
- updates metadata.json to include support for pe 2015.2 [#668](https://github.com/puppetlabs/puppetlabs-postgresql/pull/668) ([bmjen](https://github.com/bmjen))
- 4.4.2 prep [#667](https://github.com/puppetlabs/puppetlabs-postgresql/pull/667) ([bmjen](https://github.com/bmjen))
- Support granting permission on sequences. [#665](https://github.com/puppetlabs/puppetlabs-postgresql/pull/665) ([bmjen](https://github.com/bmjen))
- (MODULES-2185) Fix `withenv` execution under Puppet 2.7 [#664](https://github.com/puppetlabs/puppetlabs-postgresql/pull/664) ([domcleal](https://github.com/domcleal))
- 4.4.x mergeback [#662](https://github.com/puppetlabs/puppetlabs-postgresql/pull/662) ([bmjen](https://github.com/bmjen))
- Add default values for more openSUSE and SLES distro versions [#615](https://github.com/puppetlabs/puppetlabs-postgresql/pull/615) ([tampakrap](https://github.com/tampakrap))

## [4.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.4.1) - 2015-07-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.4.0...4.4.1)

### Other

- Increment version number for 4.4.1 [#660](https://github.com/puppetlabs/puppetlabs-postgresql/pull/660) ([DavidS](https://github.com/DavidS))
- (MODULES-2181) Fix variable scope for systemd-override [#659](https://github.com/puppetlabs/puppetlabs-postgresql/pull/659) ([kbarber](https://github.com/kbarber))

## [4.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.4.0) - 2015-06-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.3.0...4.4.0)

### Other

- fixes postgresql::server:recovery acceptance tests [#658](https://github.com/puppetlabs/puppetlabs-postgresql/pull/658) ([bmjen](https://github.com/bmjen))
- adds acceptance tests for postgresql::server::recovery resource [#657](https://github.com/puppetlabs/puppetlabs-postgresql/pull/657) ([bmjen](https://github.com/bmjen))
- updates release date on CHANGELOG [#655](https://github.com/puppetlabs/puppetlabs-postgresql/pull/655) ([bmjen](https://github.com/bmjen))
- (FM-2931) fixes logic problem with onlyif type param validation. [#654](https://github.com/puppetlabs/puppetlabs-postgresql/pull/654) ([bmjen](https://github.com/bmjen))
- (FM-2923) install net-tools for tests [#653](https://github.com/puppetlabs/puppetlabs-postgresql/pull/653) ([bmjen](https://github.com/bmjen))
- (FM-2923) install net-tools for tests [#651](https://github.com/puppetlabs/puppetlabs-postgresql/pull/651) ([DavidS](https://github.com/DavidS))
- (maint) Fix tests from #527 merge - Looks like copy tests mismatched logic of when it should expect changes [#650](https://github.com/puppetlabs/puppetlabs-postgresql/pull/650) ([cyberious](https://github.com/cyberious))
- Sync with master [#648](https://github.com/puppetlabs/puppetlabs-postgresql/pull/648) ([bmjen](https://github.com/bmjen))
- Unpins apt 1.8 dependency in fixtures.yml and spec_helper_acceptance. [#647](https://github.com/puppetlabs/puppetlabs-postgresql/pull/647) ([bmjen](https://github.com/bmjen))
- Release 4.4.0 prep [#646](https://github.com/puppetlabs/puppetlabs-postgresql/pull/646) ([bmjen](https://github.com/bmjen))
- (maint) Add beaker-puppet_install_helper and fix fact bug   [#645](https://github.com/puppetlabs/puppetlabs-postgresql/pull/645) ([cyberious](https://github.com/cyberious))
- Update dependencies [#644](https://github.com/puppetlabs/puppetlabs-postgresql/pull/644) ([underscorgan](https://github.com/underscorgan))
- Show support for Puppet v4 in the metadata [#643](https://github.com/puppetlabs/puppetlabs-postgresql/pull/643) ([ghoneycutt](https://github.com/ghoneycutt))
- tightens concat dependency to < 2.0.0 [#641](https://github.com/puppetlabs/puppetlabs-postgresql/pull/641) ([bmjen](https://github.com/bmjen))
- Fixed systemd override for manage_repo package versions [#639](https://github.com/puppetlabs/puppetlabs-postgresql/pull/639) ([cdenneen](https://github.com/cdenneen))
- Updated travisci file to remove allow_failures on Puppet 4 [#635](https://github.com/puppetlabs/puppetlabs-postgresql/pull/635) ([jonnytdevops](https://github.com/jonnytdevops))
- Add plpython and postgresql-docs classes [#634](https://github.com/puppetlabs/puppetlabs-postgresql/pull/634) ([DavidS](https://github.com/DavidS))
- disabling pg_hba_conf_defaults should not disable ipv4acls and ipv6ac… [#633](https://github.com/puppetlabs/puppetlabs-postgresql/pull/633) ([b0e](https://github.com/b0e))
- Copy snakeoil certificate and key instead of symlinking [#629](https://github.com/puppetlabs/puppetlabs-postgresql/pull/629) ([mcanevet](https://github.com/mcanevet))
- Support puppetlabs-concat 2.x [#626](https://github.com/puppetlabs/puppetlabs-postgresql/pull/626) ([domcleal](https://github.com/domcleal))
- add ubuntu/vivid support [#624](https://github.com/puppetlabs/puppetlabs-postgresql/pull/624) ([saimonn](https://github.com/saimonn))
- (#2049) Make title of psql resource for schema creation unique [#623](https://github.com/puppetlabs/puppetlabs-postgresql/pull/623) ([dirkweinhardt](https://github.com/dirkweinhardt))
- Modulesync updates [#619](https://github.com/puppetlabs/puppetlabs-postgresql/pull/619) ([underscorgan](https://github.com/underscorgan))
- Apt fix [#618](https://github.com/puppetlabs/puppetlabs-postgresql/pull/618) ([tphoney](https://github.com/tphoney))
- (MODULES-2007) Fix Puppet.newtype deprecation warning [#616](https://github.com/puppetlabs/puppetlabs-postgresql/pull/616) ([roman-mueller](https://github.com/roman-mueller))
- update fixtures file with new concat dependencies [#612](https://github.com/puppetlabs/puppetlabs-postgresql/pull/612) ([bmjen](https://github.com/bmjen))
- Antaflos patch 2 [#609](https://github.com/puppetlabs/puppetlabs-postgresql/pull/609) ([hunner](https://github.com/hunner))
- MODULES-1923 - Use the correct command with Puppet < 3.4 [#608](https://github.com/puppetlabs/puppetlabs-postgresql/pull/608) ([underscorgan](https://github.com/underscorgan))
- Merge 4.3.x back to master [#605](https://github.com/puppetlabs/puppetlabs-postgresql/pull/605) ([hunner](https://github.com/hunner))
- (MODULES-1761) Provide defined resource for managing recovery.conf [#603](https://github.com/puppetlabs/puppetlabs-postgresql/pull/603) ([dacrome](https://github.com/dacrome))
- Reorder environment and require parameter, to unbreak [#602](https://github.com/puppetlabs/puppetlabs-postgresql/pull/602) ([buzzdeee](https://github.com/buzzdeee))
- Fix URLs in metadata.json [#599](https://github.com/puppetlabs/puppetlabs-postgresql/pull/599) ([raphink](https://github.com/raphink))
- (BKR-147) add Gemfile setting for BEAKER_VERSION for puppet... [#596](https://github.com/puppetlabs/puppetlabs-postgresql/pull/596) ([anodelman](https://github.com/anodelman))
- Update apt key to full 40characters [#591](https://github.com/puppetlabs/puppetlabs-postgresql/pull/591) ([exptom](https://github.com/exptom))
- Add param for specifying validate connection script in postgresql::client. [#410](https://github.com/puppetlabs/puppetlabs-postgresql/pull/410) ([riton](https://github.com/riton))

## [4.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.3.0) - 2015-03-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.2.0...4.3.0)

### Other

- Update readme with types docs [#598](https://github.com/puppetlabs/puppetlabs-postgresql/pull/598) ([hunner](https://github.com/hunner))
- Update changelog for merge of #591 [#597](https://github.com/puppetlabs/puppetlabs-postgresql/pull/597) ([hunner](https://github.com/hunner))
- Supported Release 4.3.0 [#595](https://github.com/puppetlabs/puppetlabs-postgresql/pull/595) ([hunner](https://github.com/hunner))
- Testing updates [#593](https://github.com/puppetlabs/puppetlabs-postgresql/pull/593) ([cmurphy](https://github.com/cmurphy))
- (MODULES-1878) properly quote create and drop extension statements [#592](https://github.com/puppetlabs/puppetlabs-postgresql/pull/592) ([exi](https://github.com/exi))
- Since this was in an osfamily block it was getting picked up on ubuntu [#588](https://github.com/puppetlabs/puppetlabs-postgresql/pull/588) ([underscorgan](https://github.com/underscorgan))
- Fix acceptance tests for EL [#587](https://github.com/puppetlabs/puppetlabs-postgresql/pull/587) ([underscorgan](https://github.com/underscorgan))
- Adjust $service_status for Debian Jessie [#586](https://github.com/puppetlabs/puppetlabs-postgresql/pull/586) ([raphink](https://github.com/raphink))
- Use space.  Join seems to be defaulting to comma. [#585](https://github.com/puppetlabs/puppetlabs-postgresql/pull/585) ([kwolf-zz](https://github.com/kwolf-zz))
- Fix specs for #567 [#584](https://github.com/puppetlabs/puppetlabs-postgresql/pull/584) ([hunner](https://github.com/hunner))
- Fix the handling of run_unless_sql_command in puppet 4 [#583](https://github.com/puppetlabs/puppetlabs-postgresql/pull/583) ([hunner](https://github.com/hunner))
- postgresql::server::extension needs to have defaults for postgresql_psql [#582](https://github.com/puppetlabs/puppetlabs-postgresql/pull/582) ([rvstaveren](https://github.com/rvstaveren))
- Merge 4.2.x to master [#581](https://github.com/puppetlabs/puppetlabs-postgresql/pull/581) ([underscorgan](https://github.com/underscorgan))
- Replication type [#580](https://github.com/puppetlabs/puppetlabs-postgresql/pull/580) ([raphink](https://github.com/raphink))
- (MODULES-1834) Be less strict when changing template1 encoding [#579](https://github.com/puppetlabs/puppetlabs-postgresql/pull/579) ([sathieu](https://github.com/sathieu))
- Make granting on ALL TABLES IN SCHEMA idempotent [#564](https://github.com/puppetlabs/puppetlabs-postgresql/pull/564) ([antaflos](https://github.com/antaflos))
- Allowing validation of db connection for more than one user and port [#560](https://github.com/puppetlabs/puppetlabs-postgresql/pull/560) ([uuid0](https://github.com/uuid0))

## [4.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.2.0) - 2015-03-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.1.0...4.2.0)

### Other

- Remove references to host parameter since the vote was to revert that [#578](https://github.com/puppetlabs/puppetlabs-postgresql/pull/578) ([underscorgan](https://github.com/underscorgan))
- Revert "(MODULES-661) Add host parameter to psql commands" [#577](https://github.com/puppetlabs/puppetlabs-postgresql/pull/577) ([underscorgan](https://github.com/underscorgan))
- 4.2.0 prep [#576](https://github.com/puppetlabs/puppetlabs-postgresql/pull/576) ([underscorgan](https://github.com/underscorgan))
- Rework defaults for `$object_name` in `postgresql::server::grant` [#574](https://github.com/puppetlabs/puppetlabs-postgresql/pull/574) ([underscorgan](https://github.com/underscorgan))
- Openbsd support [#573](https://github.com/puppetlabs/puppetlabs-postgresql/pull/573) ([underscorgan](https://github.com/underscorgan))
- README had outdated upgrade info [#572](https://github.com/puppetlabs/puppetlabs-postgresql/pull/572) ([underscorgan](https://github.com/underscorgan))
- (MAINT) Fixes incorrect rspec it description [#570](https://github.com/puppetlabs/puppetlabs-postgresql/pull/570) ([petems](https://github.com/petems))
- (MODULES-661) Add host parameter to psql commands [#568](https://github.com/puppetlabs/puppetlabs-postgresql/pull/568) ([petems](https://github.com/petems))
- Use correct TCP port when checking password [#567](https://github.com/puppetlabs/puppetlabs-postgresql/pull/567) ([antaflos](https://github.com/antaflos))
- Fix for future parser [#566](https://github.com/puppetlabs/puppetlabs-postgresql/pull/566) ([mcanevet](https://github.com/mcanevet))
- create role before database [#565](https://github.com/puppetlabs/puppetlabs-postgresql/pull/565) ([gerhardsam](https://github.com/gerhardsam))
- This wasn't matching anything other than psql 8 [#562](https://github.com/puppetlabs/puppetlabs-postgresql/pull/562) ([hunner](https://github.com/hunner))
- doc links should point to /current/ rather than a specific version [#561](https://github.com/puppetlabs/puppetlabs-postgresql/pull/561) ([igalic](https://github.com/igalic))
- Fix comment detection [#559](https://github.com/puppetlabs/puppetlabs-postgresql/pull/559) ([hunner](https://github.com/hunner))
- Fix comment detection [#558](https://github.com/puppetlabs/puppetlabs-postgresql/pull/558) ([hunner](https://github.com/hunner))
- Require server package before user permissions [#557](https://github.com/puppetlabs/puppetlabs-postgresql/pull/557) ([hunner](https://github.com/hunner))
- Pin rspec gems [#556](https://github.com/puppetlabs/puppetlabs-postgresql/pull/556) ([cmurphy](https://github.com/cmurphy))
- change example of postgresql::server::role definition to version 3 [#555](https://github.com/puppetlabs/puppetlabs-postgresql/pull/555) ([phaf](https://github.com/phaf))
- FreeBSD PostgreSQL wouldn't start first time [#554](https://github.com/puppetlabs/puppetlabs-postgresql/pull/554) ([leepa](https://github.com/leepa))
- Replace require by include [#553](https://github.com/puppetlabs/puppetlabs-postgresql/pull/553) ([PierreR](https://github.com/PierreR))
- Fix lint warnings [#552](https://github.com/puppetlabs/puppetlabs-postgresql/pull/552) ([juniorsysadmin](https://github.com/juniorsysadmin))
- (MODULES-1153) Add database comment parameter [#551](https://github.com/puppetlabs/puppetlabs-postgresql/pull/551) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Fix invalid byte sequence in US-ASCII error [#549](https://github.com/puppetlabs/puppetlabs-postgresql/pull/549) ([arioch](https://github.com/arioch))
- Add IntelliJ files to the ignore list [#548](https://github.com/puppetlabs/puppetlabs-postgresql/pull/548) ([cmurphy](https://github.com/cmurphy))
- Update .travis.yml, Gemfile, Rakefile, and CONTRIBUTING.md [#544](https://github.com/puppetlabs/puppetlabs-postgresql/pull/544) ([cmurphy](https://github.com/cmurphy))
- Update README.md [#542](https://github.com/puppetlabs/puppetlabs-postgresql/pull/542) ([dhoppe](https://github.com/dhoppe))
- Minor README internal resource linking fixes. [#541](https://github.com/puppetlabs/puppetlabs-postgresql/pull/541) ([bemosior](https://github.com/bemosior))
- Fix/encoding [#540](https://github.com/puppetlabs/puppetlabs-postgresql/pull/540) ([mcanevet](https://github.com/mcanevet))
- MODULES-1522 Add service_manage parameter [#539](https://github.com/puppetlabs/puppetlabs-postgresql/pull/539) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Allow per-schema grants and support for 'ALL TABLES IN SCHEMA' [#538](https://github.com/puppetlabs/puppetlabs-postgresql/pull/538) ([mattbostock](https://github.com/mattbostock))
- Update for using Geppetto plugin in CI [#537](https://github.com/puppetlabs/puppetlabs-postgresql/pull/537) ([justinstoller](https://github.com/justinstoller))
- Fixing autodetected version for Debian Jessie, which should use postgresql 9.4 [#535](https://github.com/puppetlabs/puppetlabs-postgresql/pull/535) ([Zouuup](https://github.com/Zouuup))
- MODULES-1485 Reverted to default behavior for Debian systems as pg_config should not be overridden [#534](https://github.com/puppetlabs/puppetlabs-postgresql/pull/534) ([cyberious](https://github.com/cyberious))
- FM-1523: Added module summary to metadata.json [#532](https://github.com/puppetlabs/puppetlabs-postgresql/pull/532) ([jbondpdx](https://github.com/jbondpdx))
- add utopic support [#529](https://github.com/puppetlabs/puppetlabs-postgresql/pull/529) ([pherjung](https://github.com/pherjung))
- merge 4.1.x into master [#526](https://github.com/puppetlabs/puppetlabs-postgresql/pull/526) ([underscorgan](https://github.com/underscorgan))
- Add postgresql::server::extension definition [#521](https://github.com/puppetlabs/puppetlabs-postgresql/pull/521) ([raphink](https://github.com/raphink))

## [4.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.1.0) - 2014-11-04

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/4.0.0...4.1.0)

### Other

- Let's actually have the version number [#525](https://github.com/puppetlabs/puppetlabs-postgresql/pull/525) ([underscorgan](https://github.com/underscorgan))
- Fix errors with future parser [#520](https://github.com/puppetlabs/puppetlabs-postgresql/pull/520) ([underscorgan](https://github.com/underscorgan))
- 4.1.0 prep [#519](https://github.com/puppetlabs/puppetlabs-postgresql/pull/519) ([underscorgan](https://github.com/underscorgan))
- Fix data directory handling [#517](https://github.com/puppetlabs/puppetlabs-postgresql/pull/517) ([cmurphy](https://github.com/cmurphy))
- Added fc21 default version [#516](https://github.com/puppetlabs/puppetlabs-postgresql/pull/516) ([david-caro](https://github.com/david-caro))
- Link to the sysconfig file for the init script of the PGDG postgresql se... [#515](https://github.com/puppetlabs/puppetlabs-postgresql/pull/515) ([lofic](https://github.com/lofic))
- Adds support for PGDATA changing [#514](https://github.com/puppetlabs/puppetlabs-postgresql/pull/514) ([mixacha](https://github.com/mixacha))
- Update PE compatibility info in metadata [#512](https://github.com/puppetlabs/puppetlabs-postgresql/pull/512) ([cmurphy](https://github.com/cmurphy))
- Add some missing params documentation [#508](https://github.com/puppetlabs/puppetlabs-postgresql/pull/508) ([ckaenzig](https://github.com/ckaenzig))
- $login parameter in server/role.pp defaults to true. doc says false. [#506](https://github.com/puppetlabs/puppetlabs-postgresql/pull/506) ([tobyw4n](https://github.com/tobyw4n))
- fix future parser error [#504](https://github.com/puppetlabs/puppetlabs-postgresql/pull/504) ([steeef](https://github.com/steeef))
- Fixed description for schema example [#503](https://github.com/puppetlabs/puppetlabs-postgresql/pull/503) ([petehayes](https://github.com/petehayes))
- Fix some typo's in Readme and specfile. [#502](https://github.com/puppetlabs/puppetlabs-postgresql/pull/502) ([aswen](https://github.com/aswen))
- postgresql.org now has a RHEL7 repo available [#501](https://github.com/puppetlabs/puppetlabs-postgresql/pull/501) ([cfeskens](https://github.com/cfeskens))
- ticket/MODULES-1298 [#484](https://github.com/puppetlabs/puppetlabs-postgresql/pull/484) ([tbartelmess](https://github.com/tbartelmess))

## [4.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/4.0.0) - 2014-09-10

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.4.2...4.0.0)

### Other

- We don't test on Scientific 7 [#499](https://github.com/puppetlabs/puppetlabs-postgresql/pull/499) ([underscorgan](https://github.com/underscorgan))
- Include postgresql::server class for specs [#497](https://github.com/puppetlabs/puppetlabs-postgresql/pull/497) ([hunner](https://github.com/hunner))
- Update metadata for 4.0 [#496](https://github.com/puppetlabs/puppetlabs-postgresql/pull/496) ([underscorgan](https://github.com/underscorgan))
- Force concat install [#493](https://github.com/puppetlabs/puppetlabs-postgresql/pull/493) ([underscorgan](https://github.com/underscorgan))
- Force concat install [#492](https://github.com/puppetlabs/puppetlabs-postgresql/pull/492) ([underscorgan](https://github.com/underscorgan))
- Remove trailing whitespace. [#489](https://github.com/puppetlabs/puppetlabs-postgresql/pull/489) ([apenney](https://github.com/apenney))
- Fix port changing. [#488](https://github.com/puppetlabs/puppetlabs-postgresql/pull/488) ([apenney](https://github.com/apenney))
- Allow failures. [#487](https://github.com/puppetlabs/puppetlabs-postgresql/pull/487) ([apenney](https://github.com/apenney))
- Fix the spec helper to apply selinux to agents only. [#486](https://github.com/puppetlabs/puppetlabs-postgresql/pull/486) ([apenney](https://github.com/apenney))
- This can't be refreshonly. [#485](https://github.com/puppetlabs/puppetlabs-postgresql/pull/485) ([apenney](https://github.com/apenney))
- Unfortunately this didn't work on > 9.3 in practice. [#483](https://github.com/puppetlabs/puppetlabs-postgresql/pull/483) ([apenney](https://github.com/apenney))
- Revert "Support changing PGDATA on RedHat" [#481](https://github.com/puppetlabs/puppetlabs-postgresql/pull/481) ([apenney](https://github.com/apenney))
- Update spec_helper for more consistency [#480](https://github.com/puppetlabs/puppetlabs-postgresql/pull/480) ([underscorgan](https://github.com/underscorgan))
- Fix indentation. [#479](https://github.com/puppetlabs/puppetlabs-postgresql/pull/479) ([apenney](https://github.com/apenney))
- Fix lsbmajdistreleasee fact for Ubuntu [#477](https://github.com/puppetlabs/puppetlabs-postgresql/pull/477) ([kbarber](https://github.com/kbarber))
- Remove firewall management [#476](https://github.com/puppetlabs/puppetlabs-postgresql/pull/476) ([hunner](https://github.com/hunner))
- Bump deps for postgresql 4.0 release [#475](https://github.com/puppetlabs/puppetlabs-postgresql/pull/475) ([hunner](https://github.com/hunner))
- Don't test on 3.5.0.rc3 any more [#474](https://github.com/puppetlabs/puppetlabs-postgresql/pull/474) ([hunner](https://github.com/hunner))
- Support changing PGDATA on RedHat [#473](https://github.com/puppetlabs/puppetlabs-postgresql/pull/473) ([mhjacks](https://github.com/mhjacks))
- Fixed deprecation warning for class param  in server.pp. [#471](https://github.com/puppetlabs/puppetlabs-postgresql/pull/471) ([poikilotherm](https://github.com/poikilotherm))
- remove duplicatie "description" line from Metadata.json [#470](https://github.com/puppetlabs/puppetlabs-postgresql/pull/470) ([igalic](https://github.com/igalic))
- Fixes the accidental erasing of pg_ident.conf [#464](https://github.com/puppetlabs/puppetlabs-postgresql/pull/464) ([txaj](https://github.com/txaj))
- doc: Fix anchor links in README TOC [#459](https://github.com/puppetlabs/puppetlabs-postgresql/pull/459) ([juxtin](https://github.com/juxtin))
- Add correct documentation for pg_ident_rule type [#458](https://github.com/puppetlabs/puppetlabs-postgresql/pull/458) ([stdietrich](https://github.com/stdietrich))
- MODULES-1213 link pg_config binary into /usr/bin if not already in /usr/bin or /usr/local/bin [#450](https://github.com/puppetlabs/puppetlabs-postgresql/pull/450) ([jantman](https://github.com/jantman))
- Initdb should create xlogdir if it has been set. [#448](https://github.com/puppetlabs/puppetlabs-postgresql/pull/448) ([aswen](https://github.com/aswen))
- Add support for SLES 11 [#437](https://github.com/puppetlabs/puppetlabs-postgresql/pull/437) ([dinerroger](https://github.com/dinerroger))

## [3.4.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.4.2) - 2014-08-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.4.1...3.4.2)

### Other

- This seems to fix up selinux for tablespace. [#463](https://github.com/puppetlabs/puppetlabs-postgresql/pull/463) ([apenney](https://github.com/apenney))
- Prepare 3.4.2 release. [#462](https://github.com/puppetlabs/puppetlabs-postgresql/pull/462) ([apenney](https://github.com/apenney))
- Make sure this works on Fedora as well as RHEL7. [#461](https://github.com/puppetlabs/puppetlabs-postgresql/pull/461) ([apenney](https://github.com/apenney))
- Manage pg_ident.conf by default [#460](https://github.com/puppetlabs/puppetlabs-postgresql/pull/460) ([hunner](https://github.com/hunner))
- doc: use postgresql::*server*::tablespace in example [#457](https://github.com/puppetlabs/puppetlabs-postgresql/pull/457) ([igalic](https://github.com/igalic))
- defined type for creating database schemas [#456](https://github.com/puppetlabs/puppetlabs-postgresql/pull/456) ([igalic](https://github.com/igalic))
- Merge 3.4.x changes into master. [#454](https://github.com/puppetlabs/puppetlabs-postgresql/pull/454) ([apenney](https://github.com/apenney))
- Fix Fedora support by configuring systemd, not /etc/sysconfig [#453](https://github.com/puppetlabs/puppetlabs-postgresql/pull/453) ([kbarber](https://github.com/kbarber))
- Create the pg_ident_rule defined type [#452](https://github.com/puppetlabs/puppetlabs-postgresql/pull/452) ([txaj](https://github.com/txaj))

## [3.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.4.1) - 2014-07-21

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.4.0...3.4.1)

### Other

- Prepare a 3.4.1 release. [#451](https://github.com/puppetlabs/puppetlabs-postgresql/pull/451) ([apenney](https://github.com/apenney))
- Spec tests rewrite [#449](https://github.com/puppetlabs/puppetlabs-postgresql/pull/449) ([apenney](https://github.com/apenney))
- Remove the ensure => absent uninstall code. [#442](https://github.com/puppetlabs/puppetlabs-postgresql/pull/442) ([apenney](https://github.com/apenney))

## [3.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.4.0) - 2014-07-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.3...3.4.0)

### Added

- postgis support [#280](https://github.com/puppetlabs/puppetlabs-postgresql/pull/280) ([kitchen](https://github.com/kitchen))

### Fixed

- Fix postgresql_conf quote logic [#297](https://github.com/puppetlabs/puppetlabs-postgresql/pull/297) ([reidmv](https://github.com/reidmv))

### Other

- Reword the postgis unsupported information. [#444](https://github.com/puppetlabs/puppetlabs-postgresql/pull/444) ([apenney](https://github.com/apenney))
- Add validate and lint tasks to travis script [#443](https://github.com/puppetlabs/puppetlabs-postgresql/pull/443) ([cmurphy](https://github.com/cmurphy))
- Remove postgis support for now. [#441](https://github.com/puppetlabs/puppetlabs-postgresql/pull/441) ([apenney](https://github.com/apenney))
- This corrects the location of the pg_hba config file on debian oses in tests [#440](https://github.com/puppetlabs/puppetlabs-postgresql/pull/440) ([justinstoller](https://github.com/justinstoller))
- Synchronize .travis.yml [#439](https://github.com/puppetlabs/puppetlabs-postgresql/pull/439) ([cmurphy](https://github.com/cmurphy))
- Fix trailing }. [#436](https://github.com/puppetlabs/puppetlabs-postgresql/pull/436) ([apenney](https://github.com/apenney))
- Start synchronizing module files [#435](https://github.com/puppetlabs/puppetlabs-postgresql/pull/435) ([cmurphy](https://github.com/cmurphy))
- So long, Modulefile! [#434](https://github.com/puppetlabs/puppetlabs-postgresql/pull/434) ([apenney](https://github.com/apenney))
- Add workaround for selinux. [#433](https://github.com/puppetlabs/puppetlabs-postgresql/pull/433) ([apenney](https://github.com/apenney))
- Clean the yum cache before adding repo [#430](https://github.com/puppetlabs/puppetlabs-postgresql/pull/430) ([hunner](https://github.com/hunner))
- Rspec pinning [#429](https://github.com/puppetlabs/puppetlabs-postgresql/pull/429) ([underscorgan](https://github.com/underscorgan))
- Fix Ubuntu 14.04 tests for now. [#427](https://github.com/puppetlabs/puppetlabs-postgresql/pull/427) ([apenney](https://github.com/apenney))
- (MODULES-775) Fix refresh/unless parameter interactions [#426](https://github.com/puppetlabs/puppetlabs-postgresql/pull/426) ([domcleal](https://github.com/domcleal))
- Log output on failures [#425](https://github.com/puppetlabs/puppetlabs-postgresql/pull/425) ([hunner](https://github.com/hunner))
- Remove eq('') tests thanks to the new deprecation warnings. [#424](https://github.com/puppetlabs/puppetlabs-postgresql/pull/424) ([apenney](https://github.com/apenney))
- Ensure db user exists before validating db connection [#422](https://github.com/puppetlabs/puppetlabs-postgresql/pull/422) ([claytono](https://github.com/claytono))
- Change selector statements to have default listed last [#421](https://github.com/puppetlabs/puppetlabs-postgresql/pull/421) ([blkperl](https://github.com/blkperl))
- 3.4.0 prep [#420](https://github.com/puppetlabs/puppetlabs-postgresql/pull/420) ([underscorgan](https://github.com/underscorgan))
- Set fallback postgis_version to undef so that catalog still compiles if d... [#419](https://github.com/puppetlabs/puppetlabs-postgresql/pull/419) ([mcanevet](https://github.com/mcanevet))
- Add RHEL7 and Ubuntu 14.04. [#417](https://github.com/puppetlabs/puppetlabs-postgresql/pull/417) ([apenney](https://github.com/apenney))
- Merge33x [#416](https://github.com/puppetlabs/puppetlabs-postgresql/pull/416) ([apenney](https://github.com/apenney))
- [WIP] Fixes to tests and RHEL7 support. [#415](https://github.com/puppetlabs/puppetlabs-postgresql/pull/415) ([apenney](https://github.com/apenney))
- Support Debian Jessie [#414](https://github.com/puppetlabs/puppetlabs-postgresql/pull/414) ([lucas42](https://github.com/lucas42))
- tag postgresql-jdbc package to fix package repo dependency [#413](https://github.com/puppetlabs/puppetlabs-postgresql/pull/413) ([rdark](https://github.com/rdark))
- Fix tests 1404 [#412](https://github.com/puppetlabs/puppetlabs-postgresql/pull/412) ([apenney](https://github.com/apenney))
- [WIP] (don't merge) Fix for Ubuntu 14.04. [#411](https://github.com/puppetlabs/puppetlabs-postgresql/pull/411) ([apenney](https://github.com/apenney))
- Update apt.postgresql.org key url [#409](https://github.com/puppetlabs/puppetlabs-postgresql/pull/409) ([mnencia](https://github.com/mnencia))
- Fix wrong config option in README [#408](https://github.com/puppetlabs/puppetlabs-postgresql/pull/408) ([fredj](https://github.com/fredj))
- (MODULES-630) Deprecate postgresql::server::version [#407](https://github.com/puppetlabs/puppetlabs-postgresql/pull/407) ([hunner](https://github.com/hunner))
- Fix how to run the acceptance tests [#406](https://github.com/puppetlabs/puppetlabs-postgresql/pull/406) ([bjoernhaeuser](https://github.com/bjoernhaeuser))
- Add support for port parameter to postgresql::server [#404](https://github.com/puppetlabs/puppetlabs-postgresql/pull/404) ([thunderkeys](https://github.com/thunderkeys))
- Add strict_variables support in unit tests [#402](https://github.com/puppetlabs/puppetlabs-postgresql/pull/402) ([mcanevet](https://github.com/mcanevet))
- Add class postgresql::lib::perl for perl support [#401](https://github.com/puppetlabs/puppetlabs-postgresql/pull/401) ([cfeskens](https://github.com/cfeskens))
- Fixed travis by updating Gemfile to pin Rake to 10.1.1 [#398](https://github.com/puppetlabs/puppetlabs-postgresql/pull/398) ([igalic](https://github.com/igalic))
- Allow the ex- and import of postgresql::server::db [#397](https://github.com/puppetlabs/puppetlabs-postgresql/pull/397) ([pieterlexis](https://github.com/pieterlexis))
- Postgresql server role inherit support [#395](https://github.com/puppetlabs/puppetlabs-postgresql/pull/395) ([thunderkeys](https://github.com/thunderkeys))
- Fix unit tests with rspec-puppet 1.0 [#393](https://github.com/puppetlabs/puppetlabs-postgresql/pull/393) ([mcanevet](https://github.com/mcanevet))
- Fix FreeBSD support [#391](https://github.com/puppetlabs/puppetlabs-postgresql/pull/391) ([geoffgarside](https://github.com/geoffgarside))
- change pg_hba.conf to be owned by postgres user account [#372](https://github.com/puppetlabs/puppetlabs-postgresql/pull/372) ([jhoblitt](https://github.com/jhoblitt))

## [3.3.3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.3) - 2014-03-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.2...3.3.3)

### Other

- Remove autorelease [#388](https://github.com/puppetlabs/puppetlabs-postgresql/pull/388) ([hunner](https://github.com/hunner))
- Change error detection for version to after other parameters [#387](https://github.com/puppetlabs/puppetlabs-postgresql/pull/387) ([hunner](https://github.com/hunner))
- Prepare 3.3.3 supported release. [#386](https://github.com/puppetlabs/puppetlabs-postgresql/pull/386) ([apenney](https://github.com/apenney))
- Replace the symlink with the actual file to resolve a PMT issue. [#385](https://github.com/puppetlabs/puppetlabs-postgresql/pull/385) ([apenney](https://github.com/apenney))

## [3.3.2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.2) - 2014-03-03

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.1...3.3.2)

### Other

- Patch metadata [#384](https://github.com/puppetlabs/puppetlabs-postgresql/pull/384) ([hunner](https://github.com/hunner))
- Add install instructions for supported module version [#383](https://github.com/puppetlabs/puppetlabs-postgresql/pull/383) ([lrnrthr](https://github.com/lrnrthr))
- Supported Release 3.3.2 [#382](https://github.com/puppetlabs/puppetlabs-postgresql/pull/382) ([hunner](https://github.com/hunner))
- Prepare metadata for supported modules release. [#381](https://github.com/puppetlabs/puppetlabs-postgresql/pull/381) ([apenney](https://github.com/apenney))
- Adds "Release Notes/Known Bugs" to Changelog, updates file format to markdown, standardizes the format of previous entries [#380](https://github.com/puppetlabs/puppetlabs-postgresql/pull/380) ([lrnrthr](https://github.com/lrnrthr))
- Use the correct encoding. [#379](https://github.com/puppetlabs/puppetlabs-postgresql/pull/379) ([apenney](https://github.com/apenney))
- Fix the locale generation for Debian. [#378](https://github.com/puppetlabs/puppetlabs-postgresql/pull/378) ([apenney](https://github.com/apenney))
- Ensure we call out the locales-all requirement. [#377](https://github.com/puppetlabs/puppetlabs-postgresql/pull/377) ([apenney](https://github.com/apenney))
- Add class apt for manage_package_repo => true [#375](https://github.com/puppetlabs/puppetlabs-postgresql/pull/375) ([hunner](https://github.com/hunner))
- Missed these [#374](https://github.com/puppetlabs/puppetlabs-postgresql/pull/374) ([hunner](https://github.com/hunner))
- Add unsupported platforms [#373](https://github.com/puppetlabs/puppetlabs-postgresql/pull/373) ([hunner](https://github.com/hunner))
- Switch to a regex match to ignore \n's. [#371](https://github.com/puppetlabs/puppetlabs-postgresql/pull/371) ([apenney](https://github.com/apenney))
- Missing lsbdistid stub for apt module [#369](https://github.com/puppetlabs/puppetlabs-postgresql/pull/369) ([hunner](https://github.com/hunner))
- This fixes this test to work in the face of oppressive SELinux! [#368](https://github.com/puppetlabs/puppetlabs-postgresql/pull/368) ([apenney](https://github.com/apenney))
- remove trailing whitespace [#366](https://github.com/puppetlabs/puppetlabs-postgresql/pull/366) ([justinstoller](https://github.com/justinstoller))
- use fully-qualified path to psql to set password [#365](https://github.com/puppetlabs/puppetlabs-postgresql/pull/365) ([igalic](https://github.com/igalic))
- Release 3.3.1 [#364](https://github.com/puppetlabs/puppetlabs-postgresql/pull/364) ([hunner](https://github.com/hunner))

## [3.3.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.1) - 2014-02-12

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.3.0...3.3.1)

### Other

- Allow custom gemsource [#363](https://github.com/puppetlabs/puppetlabs-postgresql/pull/363) ([hunner](https://github.com/hunner))
- Prepare a 3.3.0 release. [#356](https://github.com/puppetlabs/puppetlabs-postgresql/pull/356) ([apenney](https://github.com/apenney))

## [3.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.3.0) - 2014-01-28

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.2.0...3.3.0)

### Added

- Add support to custom xlogdir parameter [#256](https://github.com/puppetlabs/puppetlabs-postgresql/pull/256) ([mnencia](https://github.com/mnencia))

### Other

- Prepare a 3.3.0 release. [#356](https://github.com/puppetlabs/puppetlabs-postgresql/pull/356) ([apenney](https://github.com/apenney))
- Travis [#354](https://github.com/puppetlabs/puppetlabs-postgresql/pull/354) ([ghoneycutt](https://github.com/ghoneycutt))
- Beaker specs [#353](https://github.com/puppetlabs/puppetlabs-postgresql/pull/353) ([apenney](https://github.com/apenney))
- Update README.md [#349](https://github.com/puppetlabs/puppetlabs-postgresql/pull/349) ([riconnon](https://github.com/riconnon))
- Fix typo, clearly from a copy/paste mistake [#347](https://github.com/puppetlabs/puppetlabs-postgresql/pull/347) ([mhagander](https://github.com/mhagander))
- fix for concat error [#343](https://github.com/puppetlabs/puppetlabs-postgresql/pull/343) ([flypenguin](https://github.com/flypenguin))
- use Puppet::Util::Execute.execute with puppet >= 3.4 [#340](https://github.com/puppetlabs/puppetlabs-postgresql/pull/340) ([jhoblitt](https://github.com/jhoblitt))
- Rspec puppet fixes [#339](https://github.com/puppetlabs/puppetlabs-postgresql/pull/339) ([jhoblitt](https://github.com/jhoblitt))
- README.md postgresql::globals class parameter description fix [#335](https://github.com/puppetlabs/puppetlabs-postgresql/pull/335) ([dgolja](https://github.com/dgolja))
- Fix NOREPLICATION option for Postgres 9.1 [#333](https://github.com/puppetlabs/puppetlabs-postgresql/pull/333) ([brandonwamboldt](https://github.com/brandonwamboldt))
- (feat) Add FreeBSD Support [#327](https://github.com/puppetlabs/puppetlabs-postgresql/pull/327) ([zachfi](https://github.com/zachfi))
- $postgresql::server::client_package_name is referred from install.pp, bu... [#325](https://github.com/puppetlabs/puppetlabs-postgresql/pull/325) ([aadamovich](https://github.com/aadamovich))
- Wrong parameter name: manage_pg_conf -> manage_pg_hba_conf [#324](https://github.com/puppetlabs/puppetlabs-postgresql/pull/324) ([aadamovich](https://github.com/aadamovich))
- Unable to run spec tests from behind firewall [#323](https://github.com/puppetlabs/puppetlabs-postgresql/pull/323) ([](https://github.com/))
- Added newline at end of file [#322](https://github.com/puppetlabs/puppetlabs-postgresql/pull/322) ([bcomnes](https://github.com/bcomnes))
- (FM-486) Fix deprecated Puppet::Util::SUIDManager.run_and_capture [#320](https://github.com/puppetlabs/puppetlabs-postgresql/pull/320) ([apenney](https://github.com/apenney))
- Prevent float of defined resource. [#317](https://github.com/puppetlabs/puppetlabs-postgresql/pull/317) ([tmclaugh](https://github.com/tmclaugh))
- Can pass template at database creation [#316](https://github.com/puppetlabs/puppetlabs-postgresql/pull/316) ([mcanevet](https://github.com/mcanevet))
- Exec['postgresql_initdb'] needs to be done after $datadir exists [#313](https://github.com/puppetlabs/puppetlabs-postgresql/pull/313) ([tmclaugh](https://github.com/tmclaugh))
- Remove deprecated and unused parameters to concat::fragment [#311](https://github.com/puppetlabs/puppetlabs-postgresql/pull/311) ([kronn](https://github.com/kronn))
- Fix table_grant_spec to show a bug [#310](https://github.com/puppetlabs/puppetlabs-postgresql/pull/310) ([mcanevet](https://github.com/mcanevet))
- add lc_* config entry settings [#309](https://github.com/puppetlabs/puppetlabs-postgresql/pull/309) ([leehanel](https://github.com/leehanel))
- Prepare a 3.2.0 release. [#306](https://github.com/puppetlabs/puppetlabs-postgresql/pull/306) ([apenney](https://github.com/apenney))

## [3.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.2.0) - 2013-11-05

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.1.0...3.2.0)

### Other

- Missing depedenncy '->' and class misspelled (missing ending s) [#302](https://github.com/puppetlabs/puppetlabs-postgresql/pull/302) ([dgolja](https://github.com/dgolja))
- Spelling and redundancy fix in README [#301](https://github.com/puppetlabs/puppetlabs-postgresql/pull/301) ([dawik](https://github.com/dawik))
- Allow specification of default database name [#298](https://github.com/puppetlabs/puppetlabs-postgresql/pull/298) ([reidmv](https://github.com/reidmv))
- Add default PostgreSQL version for Ubuntu 13.10 [#296](https://github.com/puppetlabs/puppetlabs-postgresql/pull/296) ([kamilszymanski](https://github.com/kamilszymanski))
- Release 3.1.0 [#294](https://github.com/puppetlabs/puppetlabs-postgresql/pull/294) ([kbarber](https://github.com/kbarber))

## [3.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.1.0) - 2013-10-25

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0...3.1.0)

### Fixed

- (GH-198) Fix race condition on startup [#292](https://github.com/puppetlabs/puppetlabs-postgresql/pull/292) ([kbarber](https://github.com/kbarber))

### Other

- Add autopublishing. [#295](https://github.com/puppetlabs/puppetlabs-postgresql/pull/295) ([apenney](https://github.com/apenney))
- Release 3.1.0 [#294](https://github.com/puppetlabs/puppetlabs-postgresql/pull/294) ([kbarber](https://github.com/kbarber))
- Update server.pp [#291](https://github.com/puppetlabs/puppetlabs-postgresql/pull/291) ([cdenneen](https://github.com/cdenneen))
- Add zero length string to join() function [#286](https://github.com/puppetlabs/puppetlabs-postgresql/pull/286) ([antevens](https://github.com/antevens))
- periods are valid in configuration variables also [#284](https://github.com/puppetlabs/puppetlabs-postgresql/pull/284) ([kitchen](https://github.com/kitchen))
- enable setting the postgres user's password without resetting the password on every puppet run [#281](https://github.com/puppetlabs/puppetlabs-postgresql/pull/281) ([jonoterc](https://github.com/jonoterc))
- Prepare 3.0.0 release. [#279](https://github.com/puppetlabs/puppetlabs-postgresql/pull/279) ([apenney](https://github.com/apenney))
- add search_path attribute to postgresql_psql resource [#275](https://github.com/puppetlabs/puppetlabs-postgresql/pull/275) ([kitchen](https://github.com/kitchen))
- Defined $default_version for Fedora 17 [#264](https://github.com/puppetlabs/puppetlabs-postgresql/pull/264) ([bcomnes](https://github.com/bcomnes))

## [3.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0) - 2013-10-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0-rc3...3.0.0)

### Other

- Prepare 3.0.0-rc3 release. [#278](https://github.com/puppetlabs/puppetlabs-postgresql/pull/278) ([apenney](https://github.com/apenney))

## [3.0.0-rc3](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0-rc3) - 2013-10-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0-rc2...3.0.0-rc3)

### Other

- Prepare 3.0.0-rc3 release. [#278](https://github.com/puppetlabs/puppetlabs-postgresql/pull/278) ([apenney](https://github.com/apenney))
- Expose owner in db definition [#273](https://github.com/puppetlabs/puppetlabs-postgresql/pull/273) ([ares](https://github.com/ares))
- Prepare 3.0.0-rc2 release. [#272](https://github.com/puppetlabs/puppetlabs-postgresql/pull/272) ([apenney](https://github.com/apenney))
- Add a parameter to (un)manage pg_hba.conf [#261](https://github.com/puppetlabs/puppetlabs-postgresql/pull/261) ([mcanevet](https://github.com/mcanevet))

## [3.0.0-rc2](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0-rc2) - 2013-10-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/3.0.0-rc1...3.0.0-rc2)

### Other

- Prepare 3.0.0-rc2 release. [#272](https://github.com/puppetlabs/puppetlabs-postgresql/pull/272) ([apenney](https://github.com/apenney))
- FM-103: Add metadata.json to all modules. [#269](https://github.com/puppetlabs/puppetlabs-postgresql/pull/269) ([apenney](https://github.com/apenney))
- Fix documentation about username/password for the postgresql_hash functi... [#268](https://github.com/puppetlabs/puppetlabs-postgresql/pull/268) ([duritong](https://github.com/duritong))
- fixed the rspec test to include 'sha1' in [#267](https://github.com/puppetlabs/puppetlabs-postgresql/pull/267) ([neilnorthrop](https://github.com/neilnorthrop))
- Special case for $datadir on Amazon [#262](https://github.com/puppetlabs/puppetlabs-postgresql/pull/262) ([bcomnes](https://github.com/bcomnes))
- Prepare 3.0.0 release. [#259](https://github.com/puppetlabs/puppetlabs-postgresql/pull/259) ([apenney](https://github.com/apenney))

## [3.0.0-rc1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/3.0.0-rc1) - 2013-10-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.5.0...3.0.0-rc1)

### Other

- Prepare 3.0.0 release. [#259](https://github.com/puppetlabs/puppetlabs-postgresql/pull/259) ([apenney](https://github.com/apenney))
- Fix license file. [#258](https://github.com/puppetlabs/puppetlabs-postgresql/pull/258) ([apenney](https://github.com/apenney))
- Support apt.postgresql.org version specific packages. [#255](https://github.com/puppetlabs/puppetlabs-postgresql/pull/255) ([mnencia](https://github.com/mnencia))
- Validate authentication method against server version [#251](https://github.com/puppetlabs/puppetlabs-postgresql/pull/251) ([kamilszymanski](https://github.com/kamilszymanski))
- lint fixes [#250](https://github.com/puppetlabs/puppetlabs-postgresql/pull/250) ([kamilszymanski](https://github.com/kamilszymanski))
- Added Archlinux Support [#249](https://github.com/puppetlabs/puppetlabs-postgresql/pull/249) ([aboe76](https://github.com/aboe76))
- Fixing small typos [#248](https://github.com/puppetlabs/puppetlabs-postgresql/pull/248) ([ggeldenhuis](https://github.com/ggeldenhuis))
- Pgsql major rewrite with features [#245](https://github.com/puppetlabs/puppetlabs-postgresql/pull/245) ([kbarber](https://github.com/kbarber))
- Remove trailing comma which breaks 2.6 compat [#239](https://github.com/puppetlabs/puppetlabs-postgresql/pull/239) ([GregSutcliffe](https://github.com/GregSutcliffe))
- Remove 3.0, 3.1, and 2.6 to shrink the test matrix. [#237](https://github.com/puppetlabs/puppetlabs-postgresql/pull/237) ([apenney](https://github.com/apenney))

## [2.5.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.5.0) - 2013-09-09

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.4.1...2.5.0)

### Other

- 2.5.0 release. [#243](https://github.com/puppetlabs/puppetlabs-postgresql/pull/243) ([apenney](https://github.com/apenney))
- Remove 3.0, 3.1, and 2.6 to shrink the test matrix. [#237](https://github.com/puppetlabs/puppetlabs-postgresql/pull/237) ([apenney](https://github.com/apenney))
- Style fixes (and a bugfix) [#236](https://github.com/puppetlabs/puppetlabs-postgresql/pull/236) ([apenney](https://github.com/apenney))
- Add missing documentation for istemplate parameter [#235](https://github.com/puppetlabs/puppetlabs-postgresql/pull/235) ([kamilszymanski](https://github.com/kamilszymanski))
- Add README entry for postgresql::plperl [#229](https://github.com/puppetlabs/puppetlabs-postgresql/pull/229) ([mcanevet](https://github.com/mcanevet))
- Alter escaping in postgresql::config::afterservice [#218](https://github.com/puppetlabs/puppetlabs-postgresql/pull/218) ([fiddyspence](https://github.com/fiddyspence))
- Handle refreshonly correctly [#212](https://github.com/puppetlabs/puppetlabs-postgresql/pull/212) ([hunner](https://github.com/hunner))
- Tag the postgresql-contrib package as postgresql [#209](https://github.com/puppetlabs/puppetlabs-postgresql/pull/209) ([mnencia](https://github.com/mnencia))

## [2.4.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.4.1) - 2013-08-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.4.0...2.4.1)

### Fixed

- (GH-216) Alter role call not idempotent with cleartext passwords [#225](https://github.com/puppetlabs/puppetlabs-postgresql/pull/225) ([kbarber](https://github.com/kbarber))

### Other

- Release 2.4.1 [#228](https://github.com/puppetlabs/puppetlabs-postgresql/pull/228) ([kbarber](https://github.com/kbarber))

## [2.4.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.4.0) - 2013-08-01

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.3.0...2.4.0)

### Other

- Release 2.4.0 [#213](https://github.com/puppetlabs/puppetlabs-postgresql/pull/213) ([hunner](https://github.com/hunner))
- Add grant abilities for more that databases [#208](https://github.com/puppetlabs/puppetlabs-postgresql/pull/208) ([hunner](https://github.com/hunner))
- Add support for installing PL/Perl [#205](https://github.com/puppetlabs/puppetlabs-postgresql/pull/205) ([mcanevet](https://github.com/mcanevet))
- Add support for istemplate parameter where creating db [#204](https://github.com/puppetlabs/puppetlabs-postgresql/pull/204) ([mcanevet](https://github.com/mcanevet))
- Fix the non-defaults test failing to use UTF8 [#194](https://github.com/puppetlabs/puppetlabs-postgresql/pull/194) ([kbarber](https://github.com/kbarber))
- Rename wrongly named test-files [#192](https://github.com/puppetlabs/puppetlabs-postgresql/pull/192) ([kronn](https://github.com/kronn))
- Update Modulefile and Changelog for 2.3.0 release [#191](https://github.com/puppetlabs/puppetlabs-postgresql/pull/191) ([cprice404](https://github.com/cprice404))

## [2.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.3.0) - 2013-06-06

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.2.1...2.3.0)

### Other

- Update docs to reflect new `owner` parameter for `::database` type. [#190](https://github.com/puppetlabs/puppetlabs-postgresql/pull/190) ([cprice404](https://github.com/cprice404))
- Add more distributions [#189](https://github.com/puppetlabs/puppetlabs-postgresql/pull/189) ([kbarber](https://github.com/kbarber))
- Don't hard-code postgres user's username for pg_hba [#188](https://github.com/puppetlabs/puppetlabs-postgresql/pull/188) ([cprice404](https://github.com/cprice404))
- Convert system tests to use rspec-system [#186](https://github.com/puppetlabs/puppetlabs-postgresql/pull/186) ([kbarber](https://github.com/kbarber))
- Correct README [#184](https://github.com/puppetlabs/puppetlabs-postgresql/pull/184) ([MaxMartin](https://github.com/MaxMartin))
- Fix example command in README for running system tests on a distro [#179](https://github.com/puppetlabs/puppetlabs-postgresql/pull/179) ([cprice404](https://github.com/cprice404))
- Setting the owner of the database with createdb. [#156](https://github.com/puppetlabs/puppetlabs-postgresql/pull/156) ([harbulot](https://github.com/harbulot))

## [2.2.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.2.1) - 2013-04-29

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.2.0...2.2.1)

### Other

- Release 2.2.1 + Changelog [#176](https://github.com/puppetlabs/puppetlabs-postgresql/pull/176) ([kbarber](https://github.com/kbarber))
- Set /tmp as default CWD for postgresql_psql [#151](https://github.com/puppetlabs/puppetlabs-postgresql/pull/151) ([antaflos](https://github.com/antaflos))

## [2.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.2.0) - 2013-04-26

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.1.1...2.2.0)

### Other

- Release 2.2.0 [#175](https://github.com/puppetlabs/puppetlabs-postgresql/pull/175) ([kbarber](https://github.com/kbarber))
- Increase stdlib dependency to include 5.x [#174](https://github.com/puppetlabs/puppetlabs-postgresql/pull/174) ([kbarber](https://github.com/kbarber))
- Adds new postgresql::python module. [#172](https://github.com/puppetlabs/puppetlabs-postgresql/pull/172) ([dprince](https://github.com/dprince))
- Add default PostgreSQL version for Ubuntu 13.04 [#171](https://github.com/puppetlabs/puppetlabs-postgresql/pull/171) ([kamilszymanski](https://github.com/kamilszymanski))
- Three Puppet 2.6 fixes [#162](https://github.com/puppetlabs/puppetlabs-postgresql/pull/162) ([domcleal](https://github.com/domcleal))
- Add explicit call to concat::setup when creating concat file [#161](https://github.com/puppetlabs/puppetlabs-postgresql/pull/161) ([domcleal](https://github.com/domcleal))
- Adding the ability to create users without a password. [#158](https://github.com/puppetlabs/puppetlabs-postgresql/pull/158) ([harbulot](https://github.com/harbulot))
- Fix readme typo [#145](https://github.com/puppetlabs/puppetlabs-postgresql/pull/145) ([Seldaek](https://github.com/Seldaek))
- Update postgres_default_version for Ubuntu [#143](https://github.com/puppetlabs/puppetlabs-postgresql/pull/143) ([kamilszymanski](https://github.com/kamilszymanski))
- Allow to set connection limit for new role [#142](https://github.com/puppetlabs/puppetlabs-postgresql/pull/142) ([kamilszymanski](https://github.com/kamilszymanski))
- fix pg_hba_rule for postgres local access [#141](https://github.com/puppetlabs/puppetlabs-postgresql/pull/141) ([kamilszymanski](https://github.com/kamilszymanski))
- Fix versions for travis-ci [#140](https://github.com/puppetlabs/puppetlabs-postgresql/pull/140) ([kbarber](https://github.com/kbarber))
- Ticket/master/128 provide more custom parameters for custom packaging [#138](https://github.com/puppetlabs/puppetlabs-postgresql/pull/138) ([kbarber](https://github.com/kbarber))
- Create dependent directory for sudoers so tests work on Centos 5 [#137](https://github.com/puppetlabs/puppetlabs-postgresql/pull/137) ([kbarber](https://github.com/kbarber))
- Add supprot for contrib package [#135](https://github.com/puppetlabs/puppetlabs-postgresql/pull/135) ([kamilszymanski](https://github.com/kamilszymanski))
- Allow SQL commands to be run against a specific DB [#134](https://github.com/puppetlabs/puppetlabs-postgresql/pull/134) ([cv](https://github.com/cv))
- Restore support for Puppet 2.6. [#133](https://github.com/puppetlabs/puppetlabs-postgresql/pull/133) ([razorsedge](https://github.com/razorsedge))
- Add support for the REPLICATION flag when creating roles [#129](https://github.com/puppetlabs/puppetlabs-postgresql/pull/129) ([Seldaek](https://github.com/Seldaek))

## [2.1.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.1.1) - 2013-02-22

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.1.0...2.1.1)

### Other

- Change Modulefile and Changelog for Release 2.1.1 [#132](https://github.com/puppetlabs/puppetlabs-postgresql/pull/132) ([kbarber](https://github.com/kbarber))
- Ticket/master/130 unsupported include directive postgres 81 [#131](https://github.com/puppetlabs/puppetlabs-postgresql/pull/131) ([kbarber](https://github.com/kbarber))

## [2.1.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.1.0) - 2013-02-20

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.0.1...2.1.0)

### Other

- Increment version, cleanup and changelog for release 2.1.0 [#123](https://github.com/puppetlabs/puppetlabs-postgresql/pull/123) ([kbarber](https://github.com/kbarber))
- fix lots of style issues [#121](https://github.com/puppetlabs/puppetlabs-postgresql/pull/121) ([dalen](https://github.com/dalen))
- Provide new defined resources for managing pg_hba.conf [#120](https://github.com/puppetlabs/puppetlabs-postgresql/pull/120) ([kbarber](https://github.com/kbarber))
- Reverted some of the coding style fixes [#118](https://github.com/puppetlabs/puppetlabs-postgresql/pull/118) ([fhrbek](https://github.com/fhrbek))
- Coding style fixes [#117](https://github.com/puppetlabs/puppetlabs-postgresql/pull/117) ([fhrbek](https://github.com/fhrbek))
- Feature/jdbc [#116](https://github.com/puppetlabs/puppetlabs-postgresql/pull/116) ([razorsedge](https://github.com/razorsedge))
- Add unit tests and travis-ci support [#115](https://github.com/puppetlabs/puppetlabs-postgresql/pull/115) ([kbarber](https://github.com/kbarber))
- Add locale parameter support [#108](https://github.com/puppetlabs/puppetlabs-postgresql/pull/108) ([kbarber](https://github.com/kbarber))
- Support for included configuration file [#105](https://github.com/puppetlabs/puppetlabs-postgresql/pull/105) ([kbrezina](https://github.com/kbrezina))
- Minor typo fix in README [#104](https://github.com/puppetlabs/puppetlabs-postgresql/pull/104) ([boinger](https://github.com/boinger))
- Support for tablespaces [#100](https://github.com/puppetlabs/puppetlabs-postgresql/pull/100) ([kbrezina](https://github.com/kbrezina))

## [2.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.0.1) - 2013-01-30

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/2.0.0...2.0.1)

### Other

- Update postgres_default_version to 9.1 for debian 7.0 [#94](https://github.com/puppetlabs/puppetlabs-postgresql/pull/94) ([adrienthebo](https://github.com/adrienthebo))
- Updated content to conform to README best practices template [#89](https://github.com/puppetlabs/puppetlabs-postgresql/pull/89) ([lrnrthr](https://github.com/lrnrthr))
- Removed trailing comma. Makes puppet fail [#88](https://github.com/puppetlabs/puppetlabs-postgresql/pull/88) ([flaper87](https://github.com/flaper87))
- Syntax error in params.pp file [#87](https://github.com/puppetlabs/puppetlabs-postgresql/pull/87) ([sfontes](https://github.com/sfontes))
- Fix revoke command in database.pp to support postgres 8.1 [#83](https://github.com/puppetlabs/puppetlabs-postgresql/pull/83) ([cprice404](https://github.com/cprice404))
- Update CHANGELOG, README, Modulefile for 2.0.0 release [#81](https://github.com/puppetlabs/puppetlabs-postgresql/pull/81) ([cprice404](https://github.com/cprice404))
- Add support for ubuntu 12.10 status [#79](https://github.com/puppetlabs/puppetlabs-postgresql/pull/79) ([Seldaek](https://github.com/Seldaek))

## [2.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/2.0.0) - 2013-01-15

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/1.0.0...2.0.0)

### Other

- Add a "require" to make sure the service is up before trying to create a... [#80](https://github.com/puppetlabs/puppetlabs-postgresql/pull/80) ([cprice404](https://github.com/cprice404))
- Fix error message in default version fact [#78](https://github.com/puppetlabs/puppetlabs-postgresql/pull/78) ([cprice404](https://github.com/cprice404))
- Update stdlib dependency to reflect semantic versioning [#77](https://github.com/puppetlabs/puppetlabs-postgresql/pull/77) ([cprice404](https://github.com/cprice404))
- Kbarber ticket/master/manage postgres apt repo [#75](https://github.com/puppetlabs/puppetlabs-postgresql/pull/75) ([cprice404](https://github.com/cprice404))
- Fix merge issue from AMZ linux patch [#70](https://github.com/puppetlabs/puppetlabs-postgresql/pull/70) ([cprice404](https://github.com/cprice404))
- Provide version for ubuntu 12.10 [#69](https://github.com/puppetlabs/puppetlabs-postgresql/pull/69) ([Seldaek](https://github.com/Seldaek))
- Change API to expose non-default pg version support via main type [#66](https://github.com/puppetlabs/puppetlabs-postgresql/pull/66) ([cprice404](https://github.com/cprice404))
- Fix inherits issue with validate_db_connection [#62](https://github.com/puppetlabs/puppetlabs-postgresql/pull/62) ([kbarber](https://github.com/kbarber))
- Add Debian wheezy support for default version fact [#59](https://github.com/puppetlabs/puppetlabs-postgresql/pull/59) ([adrienthebo](https://github.com/adrienthebo))
- Turn the exec in validate_db_connection.pp around [#58](https://github.com/puppetlabs/puppetlabs-postgresql/pull/58) ([Mosibi](https://github.com/Mosibi))
- Syntax Error [#55](https://github.com/puppetlabs/puppetlabs-postgresql/pull/55) ([Spenser309](https://github.com/Spenser309))
- add optional cwd to the postgres_psql command [#50](https://github.com/puppetlabs/puppetlabs-postgresql/pull/50) ([brettporter](https://github.com/brettporter))
- Moved remote access for other users to end of IPv4 section [#49](https://github.com/puppetlabs/puppetlabs-postgresql/pull/49) ([nzakaria](https://github.com/nzakaria))
- Fix default version for Ubuntu and Debian [#48](https://github.com/puppetlabs/puppetlabs-postgresql/pull/48) ([florinbroasca](https://github.com/florinbroasca))
- Fix GPG key for yum.postgresl.org [#47](https://github.com/puppetlabs/puppetlabs-postgresql/pull/47) ([cprice404](https://github.com/cprice404))
- Rework `postgres_default_version` fact [#46](https://github.com/puppetlabs/puppetlabs-postgresql/pull/46) ([cprice404](https://github.com/cprice404))
- Feature/master/support non default versions [#43](https://github.com/puppetlabs/puppetlabs-postgresql/pull/43) ([cprice404](https://github.com/cprice404))
- Maint/master/support more distros in tests [#42](https://github.com/puppetlabs/puppetlabs-postgresql/pull/42) ([cprice404](https://github.com/cprice404))
- Updated.  This will fix initdb failures. [#40](https://github.com/puppetlabs/puppetlabs-postgresql/pull/40) ([Spenser309](https://github.com/Spenser309))
- Amz linux [#39](https://github.com/puppetlabs/puppetlabs-postgresql/pull/39) ([haf](https://github.com/haf))
- Set sensible path in exec to reload postgres [#35](https://github.com/puppetlabs/puppetlabs-postgresql/pull/35) ([antaflos](https://github.com/antaflos))
- Reload postgresql after changes to pg_hba.conf [#33](https://github.com/puppetlabs/puppetlabs-postgresql/pull/33) ([antaflos](https://github.com/antaflos))
- Properly quote database name when using postgresql::psql [#32](https://github.com/puppetlabs/puppetlabs-postgresql/pull/32) ([antaflos](https://github.com/antaflos))
- Issue #28 [#29](https://github.com/puppetlabs/puppetlabs-postgresql/pull/29) ([etiennep](https://github.com/etiennep))
- Initial working implementation of ruby psql type/provider [#25](https://github.com/puppetlabs/puppetlabs-postgresql/pull/25) ([cprice404](https://github.com/cprice404))
- Puppet lint fixes and test typo [#24](https://github.com/puppetlabs/puppetlabs-postgresql/pull/24) ([blkperl](https://github.com/blkperl))
- Support special characters in database role name [#23](https://github.com/puppetlabs/puppetlabs-postgresql/pull/23) ([albertkoch](https://github.com/albertkoch))
- Update README.md [#22](https://github.com/puppetlabs/puppetlabs-postgresql/pull/22) ([cprice404](https://github.com/cprice404))
- Defining ACLs in pg_hba.conf [#20](https://github.com/puppetlabs/puppetlabs-postgresql/pull/20) ([dharwood](https://github.com/dharwood))
- Fix path for `/bin/cat` [#19](https://github.com/puppetlabs/puppetlabs-postgresql/pull/19) ([jarib](https://github.com/jarib))

## [1.0.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/1.0.0) - 2012-10-24

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/release-0.3.0...1.0.0)

### Other

- Adjust ownership to Puppet Labs [#21](https://github.com/puppetlabs/puppetlabs-postgresql/pull/21) ([ryanycoleman](https://github.com/ryanycoleman))
- Add postgresql::devel for development dependencies [#17](https://github.com/puppetlabs/puppetlabs-postgresql/pull/17) ([adrienthebo](https://github.com/adrienthebo))
- Add sample usage for postgresql::server class. [#16](https://github.com/puppetlabs/puppetlabs-postgresql/pull/16) ([bjoernalbers](https://github.com/bjoernalbers))
- Warnings etc [#13](https://github.com/puppetlabs/puppetlabs-postgresql/pull/13) ([haf](https://github.com/haf))
- Update status for postgres service on Debian [#12](https://github.com/puppetlabs/puppetlabs-postgresql/pull/12) ([haus](https://github.com/haus))
- Give the persist-firewall Exec a more explicit name [#11](https://github.com/puppetlabs/puppetlabs-postgresql/pull/11) ([cprice404](https://github.com/cprice404))

## [release-0.3.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/release-0.3.0) - 2012-09-17

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/release-0.2.0...release-0.3.0)

### Other

- Feature/master/connection validator [#9](https://github.com/puppetlabs/puppetlabs-postgresql/pull/9) ([cprice404](https://github.com/cprice404))
- Remove $service_provider setting for ubuntu [#8](https://github.com/puppetlabs/puppetlabs-postgresql/pull/8) ([haus](https://github.com/haus))
- Remove trailing commas for Puppet 2.7.1 compatibility [#3](https://github.com/puppetlabs/puppetlabs-postgresql/pull/3) ([jarib](https://github.com/jarib))
- Update Modulefile to reflect latest dependencies [#2](https://github.com/puppetlabs/puppetlabs-postgresql/pull/2) ([cprice404](https://github.com/cprice404))

## [release-0.2.0](https://github.com/puppetlabs/puppetlabs-postgresql/tree/release-0.2.0) - 2012-08-16

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/release-0.0.1...release-0.2.0)

### Other

- Feature/master/align with puppetlabs mysql [#1](https://github.com/puppetlabs/puppetlabs-postgresql/pull/1) ([cprice404](https://github.com/cprice404))

## [release-0.0.1](https://github.com/puppetlabs/puppetlabs-postgresql/tree/release-0.0.1) - 2012-05-02

[Full Changelog](https://github.com/puppetlabs/puppetlabs-postgresql/compare/01c9cbeb7c3bd5c7bd067c5d7438df7d34027fbc...release-0.0.1)
