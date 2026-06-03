# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

For generic Puppet module workflow (validate, lint, unit/acceptance tests, Litmus, branch/commit conventions, CI matrix mechanics), see the PDK docs and the README's Tests section. The notes below cover only what is specific to `puppetlabs-postgresql` and not derivable from reading individual files.

## Architecture

The module has a three-layer composition that must be understood before changing anything in `manifests/`:

1. **`manifests/globals.pp`** — sole source of truth for version + OS detection. Resolves `$default_version` from `$facts['os']['family']`, `$facts['os']['name']`, and `$facts['os']['release']['major']` (a nested selector hash). Also resolves `$default_postgis_version`. Optionally configures the PGDG yum/apt repo via `postgresql::repo`, or enables `postgresql::dnfmodule` on EL8+/Fedora. **Must be included before `postgresql::server`** — `postgresql::server` reads `$postgresql::globals::default_version` to decide package names. Adding a new OS or version means editing the selector here.

2. **`manifests/params.pp`** — translates the resolved version into package/service/path names per OS. Has a critical branch: if `$version == $default_version` (and not Amazon Linux), it uses unversioned package names (`postgresql`, `postgresql-server`) from the OS base repo; otherwise it constructs versioned names (`postgresql16-server`) for the PGDG repo. Changing default version mappings without understanding this branch will break either base-repo or PGDG installs.

3. **`manifests/server.pp` + `manifests/server/`** — the user-facing API. `server.pp` orchestrates `install` → `initdb` → `config` → `service` → `reload`. The defined types under `manifests/server/` are the public interface — each one ultimately fires a `postgresql_psql` custom resource. The manifests are mostly orchestration; the actual work happens in `lib/puppet/`.

**Multi-instance support** (`manifests/server_instance.pp` + `manifests/server/instance/`) is opt-in and currently tested only on RHEL 8 / CentOS Stream 8 — see the warning at `manifests/server_instance.pp:39`. Treat changes there as RHEL-8-specific unless explicitly broadening scope.

**Hiera-driven OS defaults**: `hiera.yaml` is keyed by `os.name`/`os.family` + `os.release.major`. Per-OS YAML lives in `data/os/<Family>/<major>.yaml` and `data/os/<Name>.yaml`. Prefer adding new-OS defaults here over hard-coding them in `params.pp`.
