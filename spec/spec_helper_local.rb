RSpec.configure do |c|
  c.mock_with :rspec

  c.include PuppetlabsSpec::Files
  c.after :each do
    PuppetlabsSpec::Files.cleanup
  end
end

if ENV['COVERAGE'] == 'yes'
  require 'simplecov'
  require 'simplecov-console'
  require 'codecov'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::Codecov,
  ]
  SimpleCov.start do
    track_files 'lib/**/*.rb'

    add_filter '/spec'

    # do not track vendored files
    add_filter '/vendor'
    add_filter '/.vendor'

    # do not track gitignored files
    # this adds about 4 seconds to the coverage check
    # this could definitely be optimized
    add_filter do |f|
      # system returns true if exit status is 0, which with git-check-ignore means file is ignored
      system("git check-ignore --quiet #{f.filename}")
    end
  end
end

# Convenience helper for returning parameters for a type from the
# catalogue.
def param(type, title, param)
  param_value(catalogue, type, title, param)
end
