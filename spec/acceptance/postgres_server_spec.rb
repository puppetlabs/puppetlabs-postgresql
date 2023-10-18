# frozen_string_literal: true

require 'spec_helper_acceptance'

# These Tests are written to cover https://github.com/puppetlabs/puppetlabs-postgresql/issues/1533
# we expected this to be covered by the pipeline.
describe 'postgresql::server with postgresql.org repo, version and encoding/locale' do
  pp = <<-MANIFEST
    class { 'postgresql::globals':
      encoding            => 'UTF-8',
      locale              => 'en_US.UTF-8',
      manage_package_repo => true,
      version             => '14',
    }
    include postgresql::server
  MANIFEST
  it 'installs postgres' do
    apply_manifest(pp, catch_failures: true)
  end
end
