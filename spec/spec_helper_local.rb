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

shared_examples 'postgresql_password function' do
  it { is_expected.not_to eq(nil) }

  it {
    is_expected.to run.with_params('foo', 'bar').and_return('md596948aad3fcae80c08a35c9b5958cd89')
  }
  it {
    is_expected.to run.with_params('foo', 1234).and_return('md539a0e1b308278a8de5e007cd1f795920')
  }
  it 'raises an error if there is only 1 argument' do
    is_expected.to run.with_params('foo').and_raise_error(StandardError)
  end
end

shared_examples 'postgresql_escape function' do
  it { is_expected.not_to eq(nil) }
  it {
    is_expected.to run.with_params('foo')
                      .and_return('$$foo$$')
  }
  it {
    is_expected.to run.with_params('fo$$o')
                      .and_return('$ed$fo$$o$ed$')
  }
  it {
    is_expected.to run.with_params('foo$')
                      .and_return('$a$foo$$a$')
  }
  it 'raises an error if there is more than 1 argument' do
    is_expected.to run.with_params(['foo'], ['foo'])
                      .and_raise_error(StandardError)
  end
end
