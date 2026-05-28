# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Module overview

`puppetlabs-postgresql` manages PostgreSQL packages, services, databases, roles, grants, and `pg_hba.conf` / `pg_ident.conf` rules. Entry point is `class { 'postgresql::server': }`, but every consumer is expected to declare `postgresql::globals` first (see Architecture). Supported OSes, Puppet version range, and module dependencies are declared in `metadata.json` — treat that as the single source of truth.

## Architecture

The module has a three-layer composition that must be understood before changing anything in `manifests/`:

1. **`manifests/globals.pp`** — sole source of truth for version + OS detection. Resolves `$default_version` from `$facts['os']['family']`, `$facts['os']['name']`, and `$facts['os']['release']['major']` (a nested selector hash, ~70 lines). Also resolves `$default_postgis_version`. Optionally configures the PGDG yum/apt repo via `postgresql::repo`, or enables `postgresql::dnfmodule` on EL8+/Fedora. **Must be included before `postgresql::server`** — `postgresql::server` reads `$postgresql::globals::default_version` to decide package names. Adding a new OS or version means editing the selector here.

2. **`manifests/params.pp`** — translates the resolved version into package/service/path names per OS. Has a critical branch: if `$version == $default_version` (and not Amazon Linux), it uses unversioned package names (`postgresql`, `postgresql-server`) from the OS base repo; otherwise it constructs versioned names (`postgresql16-server`) for the PGDG repo. Changing default version mappings without understanding this branch will break either base-repo or PGDG installs.

3. **`manifests/server.pp` + `manifests/server/`** — the user-facing API. `server.pp` orchestrates `install` → `initdb` → `config` → `service` → `reload`. The defined types under `manifests/server/` are the public interface — each one ultimately fires a `postgresql_psql` custom resource (see `lib/puppet/type/postgresql_psql.rb`).

**Multi-instance support** (`manifests/server_instance.pp` + `manifests/server/instance/`) is opt-in and currently tested only on RHEL 8 / CentOS Stream 8 — see the warning at `manifests/server_instance.pp:39`. Treat changes there as RHEL-8-specific unless explicitly broadening scope.

**Custom types and providers** live in `lib/puppet/{type,provider}/`. The workhorse is `postgresql_psql`, which runs idempotent SQL via the `unless`/`onlyif` query pattern — every `server::*` defined type funnels through it. The manifests are mostly orchestration; the actual work happens in these Ruby files.

**Hiera-driven OS defaults**: `hiera.yaml` is keyed by `os.name`/`os.family` + `os.release.major`. Per-OS YAML lives in `data/os/<Family>/<major>.yaml` and `data/os/<Name>.yaml`. Add new-OS defaults here rather than hard-coding them in `params.pp` when possible.

## Common commands

Assume `bundle install --path=vendor` has been run.

```sh
bundle exec rake validate           # puppet syntax + lint + metadata-json-lint (run before pushing)
bundle exec rake parallel_spec      # full unit suite, parallelized — preferred over `rake spec` for full runs
bundle exec rspec spec/classes/globals_spec.rb                # one file
bundle exec rspec spec/classes/globals_spec.rb -e "RedHat 8"  # one example

bundle exec rake 'litmus:provision[docker,litmusimage/almalinux:9]'
bundle exec rake 'litmus:install_agent'
bundle exec rake 'litmus:install_module'
bundle exec rake 'litmus:acceptance:parallel'
bundle exec rake 'litmus:tear_down'

bundle exec rake strings:generate:reference   # regenerate REFERENCE.md after editing puppet-strings annotations
```

`rake spec` automatically runs `spec_prep` first, cloning the fixture modules listed in `.fixtures.yml` into `spec/fixtures/modules/`. If fixtures get stale after dependency changes, run `bundle exec rake spec_clean && bundle exec rake spec_prep`.

## Spec conventions

`spec/spec_helper_local.rb` defines `shared_context` blocks for OSes (`'RedHat 8'`, `'Debian 11'`, etc.) backed by `rspec-puppet-facts`. When adding tests for a new OS, prefer adding a `shared_context` here over inlining fact hashes. Use `include_examples 'RedHat 8'` — note: `include_examples`, **not** `include_context`. That's the project convention and tests written with the wrong helper will silently behave differently.

## Lint and CI

Lint configuration lives in `.puppet-lint.rc` and the `Rakefile`. `fail_on_warnings` is **on** — any new puppet-lint warning will fail CI. The `types/**/*.pp` directory is excluded from lint (Puppet type aliases use syntax that puppet-lint doesn't grok well). RuboCop exceptions are tracked in `.rubocop_todo.yml` — prefer fixing offenses over adding to the todo list.

`.github/workflows/{ci,nightly}.yml` are thin shims that call reusable workflows from `puppetlabs/cat-github-actions`. The acceptance matrix is built by `matrix_from_metadata_v3`, which reads `metadata.json`'s `operatingsystem_support` **and** cross-references the platform catalog in `puppetlabs/puppet_litmus/exe/matrix.json`. **Adding an OS/version to `metadata.json` does NOT automatically produce a CI job** — `puppet_litmus`'s matrix.json must also have a Docker image or provision-service entry for that platform. This is the most common cause of "I added the OS but no job appeared".

## Commit and branch conventions

- Branch names follow `<module-id>-<short-change-related-name>`, where `<module-id>` is the Jira ticket key (e.g. `MODULES-11816-add-claude-md`, `MODULES-12345-fix-el10-default-version`). Keep the trailing slug short, kebab-cased, and descriptive of the change. For test-PR runs of community PRs, the convention used here is `<module-id>-pr<upstream-pr-number>` (e.g. `MODULES-11807-pr1650`).
- Commit messages and PR titles start with `(MODULES-XXXX)` — the Jira automation uses this to link commits back to tickets.
- When cherry-picking community PRs, squash to one commit and add a `Co-authored-by:` trailer for the original contributor.

## Authoritative sources (do not duplicate here)

When you need any of these, read the file directly — the lists drift fast and a copy here would lie:

| What | Authoritative file |
|---|---|
| Supported operating systems and versions | `metadata.json` → `operatingsystem_support` |
| Puppet version range, module dependencies | `metadata.json` → `requirements`, `dependencies` |
| Class, defined-type, and parameter docs | `REFERENCE.md` (regenerate with `rake strings:generate:reference`) |
| Lint configuration | `.puppet-lint.rc`, `Rakefile` |
| Custom types and providers | `lib/puppet/type/`, `lib/puppet/provider/` |
| Puppet type aliases | `types/` |
| OS-specific Hiera defaults | `data/os/` |
| Fixture-module pins for unit tests | `.fixtures.yml` |
| CI workflow definitions | `.github/workflows/`, `puppetlabs/cat-github-actions` |
| CI platform catalog | `puppetlabs/puppet_litmus/exe/matrix.json` |
