# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'postgresql::server::extension' do
  # Choose a contrib extension that exists on this distro (name and version
  # vary, so hard-coding either would be brittle).
  def discover_extension
    q = 'SELECT name, default_version FROM pg_available_extensions ' \
        "WHERE name IN ('unaccent', 'pg_visibility', 'pg_repack') ORDER BY name LIMIT 1"
    ext, ver = psql("-At --command=\"#{q}\" postgres", 'postgres').stdout.strip.split(%r{\s+})
    raise 'no contrib extension available on this platform' if ext.nil?

    [ext, ver]
  end

  it 'creates an extension at an explicit version and is idempotent' do
    ext, ver = discover_extension

    pp = <<-MANIFEST
      class { 'postgresql::server': } ->
      postgresql::server::database { 'ext_vtest':
        encoding => 'UTF8',
      } ->
      postgresql::server::extension { '#{ext}_v#{ver}':
        database  => 'ext_vtest',
        extension => '#{ext}',
        ensure    => 'present',
        version   => '#{ver}',
      }
    MANIFEST

    apply_manifest(pp, catch_failures: true, expect_changes: true)
    expect(psql("-tA --command=\"SELECT extversion FROM pg_extension WHERE extname = '#{ext}'\" ext_vtest", 'postgres').stdout)
      .to include(ver)
    apply_manifest(pp, catch_failures: true, expect_changes: false)
  end
end
