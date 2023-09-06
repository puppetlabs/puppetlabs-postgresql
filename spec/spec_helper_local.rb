# frozen_string_literal: true

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
      system('git', 'check-ignore', '--quiet', f.filename)
    end
  end
end

# Convenience helper for returning parameters for a type from the
# catalogue.
def param(type, title, param)
  param_value(catalogue, type, title, param)
end

shared_examples 'postgresql_password function' do
  it { is_expected.not_to be_nil }

  it {
    expect(subject).to run.with_params('foo', 'bar').and_return(
      'md596948aad3fcae80c08a35c9b5958cd89',
    )
  }

  it {
    expect(subject).to run.with_params('foo', 1234).and_return(
      'md539a0e1b308278a8de5e007cd1f795920',
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', true).and_return(
      sensitive(%(md596948aad3fcae80c08a35c9b5958cd89)),
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', false, 'scram-sha-256').and_return(
      'SCRAM-SHA-256$4096:Zm9v$ea66ynZ8cS9Ty4ZkEYicwC72StsKLSwjcXIXKMgepTk=:dJYmOU6BMCaWkQOB3lrXH9OAF3lW2n3NJ26NO7Srq7U=',
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', true, 'scram-sha-256').and_return(
      sensitive(%(SCRAM-SHA-256$4096:Zm9v$ea66ynZ8cS9Ty4ZkEYicwC72StsKLSwjcXIXKMgepTk=:dJYmOU6BMCaWkQOB3lrXH9OAF3lW2n3NJ26NO7Srq7U=)),
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', false, 'scram-sha-256', 'salt').and_return(
      'SCRAM-SHA-256$4096:c2FsdA==$hl63wu9L6vKIjd/UGPfpRl/hIQRBnlkoCiJ9KgxzbX0=:3Q39uiwDZ51m3iPpV8rSgISgRiYqkbnpc+wScL2lSAU=',
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', true, 'scram-sha-256', 'salt').and_return(
      sensitive(%(SCRAM-SHA-256$4096:c2FsdA==$hl63wu9L6vKIjd/UGPfpRl/hIQRBnlkoCiJ9KgxzbX0=:3Q39uiwDZ51m3iPpV8rSgISgRiYqkbnpc+wScL2lSAU=)),
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', false, nil, 'salt').and_return(
      'md596948aad3fcae80c08a35c9b5958cd89',
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'bar', true, nil, 'salt').and_return(
      sensitive(%(md596948aad3fcae80c08a35c9b5958cd89)),
    )
  }

  it {
    expect(subject).to run.with_params('foo', 'md596948aad3fcae80c08a35c9b5958cd89', false).and_return(
      'md596948aad3fcae80c08a35c9b5958cd89',
    )
  }

  it {
    expect(subject).to run.with_params('foo', sensitive(%(SCRAM-SHA-256$4096:c2FsdA==$hl63wu9L6vKIjd/UGPfpRl/hIQRBnlkoCiJ9KgxzbX0=:3Q39uiwDZ51m3iPpV8rSgISgRiYqkbnpc+wScL2lSAU=)), true).and_return(
      sensitive(%(SCRAM-SHA-256$4096:c2FsdA==$hl63wu9L6vKIjd/UGPfpRl/hIQRBnlkoCiJ9KgxzbX0=:3Q39uiwDZ51m3iPpV8rSgISgRiYqkbnpc+wScL2lSAU=)),
    )
  }

  it {
    expect(subject).to run.with_params('foo', sensitive('md596948aad3fcae80c08a35c9b5958cd89'), false).and_return(
      'md596948aad3fcae80c08a35c9b5958cd89',
    )
  }

  it 'raises an error if there is only 1 argument' do
    expect(subject).to run.with_params('foo').and_raise_error(StandardError)
  end
end

shared_examples 'postgresql_escape function' do
  it { is_expected.not_to be_nil }

  it {
    expect(subject).to run.with_params('foo')
                          .and_return('$$foo$$')
  }

  it {
    expect(subject).to run.with_params('fo$$o')
                          .and_return('$ed$fo$$o$ed$')
  }

  it {
    expect(subject).to run.with_params('foo$')
                          .and_return('$a$foo$$a$')
  }

  it 'raises an error if there is more than 1 argument' do
    expect(subject).to run.with_params(['foo'], ['foo'])
                          .and_raise_error(StandardError)
  end
end

# This duplicates spec_helper but we need it for add_custom_fact
include RspecPuppetFacts
# Rough conversion of grepping in the puppet source:
# grep defaultfor lib/puppet/provider/service/*.rb
# See https://github.com/voxpupuli/voxpupuli-test/blob/master/lib/voxpupuli/test/facts.rb
add_custom_fact :service_provider, ->(_os, facts) do
  case facts[:osfamily].downcase
  when 'archlinux', 'debian'
    'systemd'
  when 'darwin'
    'launchd'
  when 'freebsd'
    'freebsd'
  when 'gentoo'
    'openrc'
  when 'openbsd'
    'openbsd'
  when 'redhat'
    (facts[:operatingsystemrelease].to_i >= 7) ? 'systemd' : 'redhat'
  when 'suse'
    (facts[:operatingsystemmajrelease].to_i >= 12) ? 'systemd' : 'redhat'
  when 'windows'
    'windows'
  else
    'init'
  end
end

shared_context 'Debian 10' do
  let(:facts) { on_supported_os['debian-10-x86_64'] }
end

shared_context 'Debian 11' do
  let(:facts) { on_supported_os['debian-11-x86_64'] }
end

shared_context 'Ubuntu 18.04' do
  let(:facts) { on_supported_os['ubuntu-18.04-x86_64'] }
end

shared_context 'RedHat 7' do
  let(:facts) { on_supported_os['redhat-7-x86_64'] }
end

shared_context 'RedHat 8' do
  let(:facts) { on_supported_os['redhat-8-x86_64'] }
end

shared_context 'Fedora 33' do
  let(:facts) do
    {
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      selinux: true,
      os: {
        'architecture' => 'x86_64',
        'family' => 'RedHat',
        'hardware' => 'x86_64',
        'name' => 'Fedora',
        'release' => {
          'full' => '33',
          'major' => '33',
          'minor' => '33'
        },
        selinux: { 'enabled' => true }
      },
      operatingsystem: 'Fedora',
      operatingsystemrelease: '33',
      service_provider: 'systemd'
    }
  end
end

shared_context 'Amazon 1' do
  let :facts do
    {
      os: {
        family: 'RedHat',
        name: 'Amazon',
        release: {
          'full' => '1.0',
          'major' => '1'
        },
        selinux: { 'enabled' => true }
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      selinux: true,
      service_provider: 'redhat'
    }
  end
end

shared_context 'Gentoo' do
  let :facts do
    {
      os: {
        family: 'Gentoo',
        name: 'Gentoo',
        release: {
          'full' => 'unused',
          'major' => 'unused'
        },
        selinux: { 'enabled' => false }
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      selinux: false,
      service_provider: 'openrc'
    }
  end
end
