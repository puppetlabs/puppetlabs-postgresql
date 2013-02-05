require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send("disable_80chars")

RSpec::Core::RakeTask.new(:system_test) do |c|
  c.pattern = "spec/system/**/*_spec.rb"
end


namespace :spec do
  desc 'Run system tests'
  task :system => :system_test
end
