source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'puppetlabs_spec_helper', :require => false
  gem 'beaker', '~> 1.11.0',    :require => false
  gem 'beaker-rspec', :path => '~/source/beaker-rspec',           :require => false
  gem 'rspec-puppet'
  gem 'puppet-lint'
  gem 'serverspec'
  gem 'specinfra', '~> 1.11.0'
  gem 'jwt', '~> 0.1'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
