# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Module overview

`puppetlabs-postgresql` manages PostgreSQL packages, services, databases, roles, grants, and `pg_hba.conf` / `pg_ident.conf` rules across RHEL-family, Debian-family, SLES, Arch, Gentoo, FreeBSD, and OpenBSD. The Puppet Forge entry point is `class { 'postgresql::server': }`, but every consumer is expected to declare `postgresql::globals` first (see Architecture).

## Architecture

The module has a three-layer composition that you must understand before changing anything in `manifests/`:

1. **`manifests/globals.pp`** — sole source of truth for version + OS detection. Resolves `$default_version` from `$facts['os']['family']`, `$facts['os']['name']`, and `$facts['os']['release']['major']` (a nested selector hash, ~70 lines). Also resolves `$default_postgis_version`. Optionally configures the PGDG yum/apt repo via `postgresql::repo`, or enables `postgresql::dnfmodule` on EL8+/Fedora. **Must be included before `postgresql::server`** — `postgresql::server` reads `$postgresql::globals::default_version` to decide package names. Adding a new OS or version means editing the selector here.

2. **`manifests/params.pp`** — translates the resolved version into package/service/path names per OS. Has a critical branch: if `$version == $default_version` (and not Amazon Linux), it uses unversioned package names (`postgresql`, `postgresql-server`) from the OS base repo; otherwise it constructs versioned names (`postgresql16-server`) for the PGDG repo. Changing default version mappings without understanding this branch will break either base-repo or PGDG installs.

3. **`manifests/server.pp` + `manifests/server/`** — the user-facing API. `server.pp` orchestrates `install` → `initdb` → `config` → `service` → `reload`. The defined types under `manifests/server/` (`db.pp`, `role.pp`, `grant.pp`, `database_grant.pp`, `default_privileges.pp`, `extension.pp`, `pg_hba_rule.pp`, `schema.pp`, `tablespace.pp`, `table_grant.pp`, etc.) are the public interface — each one ultimately fires a `postgresql_psql` custom resource.

**Multi-instance support** (`manifests/server_instance.pp` + `manifests/server/instance/`) is opt-in and currently tested only on RHEL 8 / CentOS Stream 8 — see the warning at `manifests/server_instance.pp:39`. Treat changes there as RHEL-8-specific unless explicitly broadening scope.

**Hiera-driven OS defaults**: `hiera.yaml` is keyed by `os.name`/`os.family` + `os.release.major`. Per-OS YAML lives in `data/os/<Family>/<major>.yaml` and `data/os/<Name>.yaml`. Add new-OS defaults here rather than hard-coding them in `params.pp` when possible.

**Custom types and providers** (`lib/puppet/`) — these are the actual workhorses; the manifests just wire them:
- `postgresql_psql` (type + provider in `lib/puppet/type/postgresql_psql.rb` and `lib/puppet/provider/postgresql_psql/ruby.rb`): runs idempotent SQL via the `unless`/`onlyif` query pattern. Every `server::*` defined type funnels through this.
- `postgresql_conf`: manages `postgresql.conf` entries as resources.
- `postgresql_conn_validator`: connectivity check; backed by `lib/puppet/util/postgresql_validator.rb`.
- `postgresql_replication_slot`: replication slot management.
- Functions in `lib/puppet/functions/`: `postgresql_password` (md5/scram-sha-256 hashing), `postgresql_escape` (dollar-quoting), plus the `postgresql::` namespace.
- Puppet type aliases in `types/`: `pg_hba_rule`, `pg_hba_rules`, `pg_password_encryption`, etc. — used as parameter types in the manifests.

## Common commands

All commands assume `bundle install --path=vendor` has been run.

**Validation (run before pushing):**
```sh
bundle exec rake validate           # puppet syntax + lint + metadata-json-lint
bundle exec rake lint               # puppet-lint only
bundle exec rake rubocop            # Ruby style for lib/ and spec/
```

**Unit tests:**
```sh
bundle exec rake spec               # full unit suite (rspec-puppet + lib specs)
bundle exec rake parallel_spec      # same, parallelized — preferred for full runs
bundle exec rspec spec/classes/globals_spec.rb                # one file
bundle exec rspec spec/classes/globals_spec.rb -e "RedHat 8"  # one example
```

`rake spec` automatically runs `spec_prep` first, which clones the fixture modules listed in `.fixtures.yml` into `spec/fixtures/modules/`. If fixtures get stale after dependency changes, run `bundle exec rake spec_clean && bundle exec rake spec_prep`.

**Acceptance tests (Litmus, run against a real container/VM):**
```sh
bundle exec rake 'litmus:provision[docker,litmusimage/almalinux:9]'
bundle exec rake 'litmus:install_agent'
bundle exec rake 'litmus:install_module'
bundle exec rake 'litmus:acceptance:parallel'
bundle exec rake 'litmus:tear_down'
```

A single acceptance spec, against an already-provisioned target listed in `spec/fixtures/litmus_inventory.yaml`:
```sh
bundle exec rspec spec/acceptance/server_spec.rb
```

**Reference docs:** `REFERENCE.md` is generated from puppet-strings annotations on classes/defines/types. Regenerate with `bundle exec rake strings:generate:reference` after editing parameter documentation.

## Spec layout conventions

- `spec/classes/` — `rspec-puppet` catalog tests for classes in `manifests/`.
- `spec/defines/` — `rspec-puppet` for defined types.
- `spec/functions/` — function tests.
- `spec/type_aliases/` — tests for Puppet type aliases in `types/`.
- `spec/unit/{type,provider,puppet}/` — pure Ruby tests for `lib/puppet/`.
- `spec/acceptance/` — Litmus tests; run on provisioned hosts, NOT in unit runs.

`spec/spec_helper_local.rb` defines `shared_context` blocks for OSes (`'RedHat 8'`, `'Debian 11'`, etc.) backed by `rspec-puppet-facts`. When adding tests for a new OS, prefer adding a `shared_context` here over inlining fact hashes. Use `include_examples 'RedHat 8'` (note: `include_examples`, not `include_context` — that's the project convention).

## Lint and style customizations

`.puppet-lint.rc` and the `Rakefile` disable: `80chars`, `140chars`, `class_inherits_from_params_class`, `autoloader_layout`, `documentation`, `single_quote_string_with_variables`, `anchor_resource`, `params_empty_string_assignment`, `relative`. `fail_on_warnings` is **on** — any new puppet-lint warning will fail CI. The lint ignores `types/**/*.pp` (Puppet type aliases use a different syntax that puppet-lint doesn't grok well).

RuboCop config lives in `.rubocop.yml` with overrides for puppet-module style. Existing exceptions are tracked in `.rubocop_todo.yml` — prefer fixing offenses over adding to the todo list.

## CI

`.github/workflows/ci.yml` and `nightly.yml` are thin shims that call reusable workflows from `puppetlabs/cat-github-actions`:
- `module_ci.yml` runs `rake validate` and `rake parallel_spec`.
- `module_acceptance.yml` runs Litmus against a matrix built by `matrix_from_metadata_v3`, which reads `metadata.json`'s `operatingsystem_support` and cross-references the platform catalog in `puppetlabs/puppet_litmus/exe/matrix.json`. **Adding an OS/version to `metadata.json` does NOT automatically produce a CI job** — `puppet_litmus`'s matrix.json must also have a Docker image or provision-service entry for that platform.

## Conventions when committing

- Branch names follow `<module-id>-<short-change-related-name>`, where `<module-id>` is the Jira ticket key (e.g. `MODULES-11816-add-claude-md`, `MODULES-12345-fix-el10-default-version`). Keep the trailing slug short, kebab-cased, and descriptive of the change. For test-PR runs of community PRs, the convention used here is `<module-id>-pr<upstream-pr-number>` (e.g. `MODULES-11807-pr1650`).
- Commit messages and PR titles start with `(MODULES-XXXX)` — the Jira automation uses this to link commits back to tickets.
- When cherry-picking community PRs, squash to one commit and add a `Co-authored-by:` trailer for the original contributor.

## Dependency boundaries

`metadata.json` declares the supported Puppet (`>= 8.0.0 < 9.0.0`) and module-dependency ranges. The hard runtime dependencies are `puppetlabs/stdlib`, `puppetlabs/apt`, `puppet/systemd`, `puppetlabs/concat`. Don't introduce new module dependencies without an explicit Jira ticket — they propagate to every consumer.
