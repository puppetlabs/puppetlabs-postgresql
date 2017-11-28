require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

def install_bolt_on(hosts)
  on(hosts, "/opt/puppetlabs/puppet/bin/gem install --source http://rubygems.delivery.puppetlabs.net bolt -v '> 0.0.1'", acceptable_exit_codes: [0, 1]).stdout
end

def pe_install?
  ENV['PUPPET_INSTALL_TYPE'] =~ %r{pe}i
end

run_puppet_install_helper
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ /pe/i
install_bolt_on(hosts) unless pe_install?

UNSUPPORTED_PLATFORMS = ['AIX','windows','Solaris','Suse']

# monkey patch to get around apt/forge issue (PUP-8008)
module Beaker::ModuleInstallHelper
  include Beaker::DSL

  def module_dependencies_from_metadata
    metadata = module_metadata
    return [] unless metadata.key?('dependencies')

    dependencies = []

    # get it outta here!
    metadata['dependencies'].delete_if {|d| d['name'] == 'puppetlabs/apt' }

    metadata['dependencies'].each do |d|
      tmp = { module_name: d['name'].sub('/', '-') }

      if d.key?('version_requirement')
        tmp[:version] = module_version_from_requirement(tmp[:module_name],
                                                        d['version_requirement'])
      end
      dependencies.push(tmp)
    end

    dependencies
  end
end

def puppet_version
  (on default, puppet('--version')).output.chomp
end

DEFAULT_PASSWORD = if default[:hypervisor] == 'vagrant'
                     'vagrant'
                   elsif default[:hypervisor] == 'vcloud'
                     'Qu@lity!'
                   end

install_module_on(hosts)
install_module_dependencies_on(hosts)
install_module_from_forge_on(hosts,'puppetlabs/apt','< 4.2.0')

class String
  # Provide ability to remove indentation from strings, for the purpose of
  # left justifying heredoc blocks.
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

def shellescape(str)
  str = str.to_s

  # An empty argument will be skipped, so return empty quotes.
  return "''" if str.empty?

  str = str.dup

  # Treat multibyte characters as is.  It is caller's responsibility
  # to encode the string in the right encoding for the shell
  # environment.
  str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1")

  # A LF cannot be escaped with a backslash because a backslash + LF
  # combo is regarded as line continuation and simply ignored.
  str.gsub!(/\n/, "'\n'")

  return str
end

def psql(psql_cmd, user = 'postgres', exit_codes = [0,1], &block)
  psql = "psql #{psql_cmd}"
  shell("su #{shellescape(user)} -c #{shellescape(psql)}", :acceptable_exit_codes => exit_codes, &block)
end

def run_puppet_access_login(user:, password: '~!@#$%^*-/ aZ', lifetime: '5y')
  on(master, puppet('access', 'login', '--username', user, '--lifetime', lifetime), stdin: password)
end

def run_task(task_name:, params: nil, password: DEFAULT_PASSWORD)
  if pe_install?
    run_puppet_task(task_name: task_name, params: params)
  else
    run_bolt_task(task_name: task_name, params: params, password: password)
  end
end

def run_bolt_task(task_name:, params: nil, password: DEFAULT_PASSWORD)
  on(hosts, "/opt/puppetlabs/puppet/bin/bolt task run #{task_name} --modules /etc/puppetlabs/code/modules --nodes localhost --password #{password} #{params}", acceptable_exit_codes: [0, 1]).stdout # rubocop:disable Metrics/LineLength
end

def run_puppet_task(task_name:, params: nil)
  on(master, puppet('task', 'run', task_name, '--nodes', fact_on(master, 'fqdn'), params.to_s), acceptable_exit_codes: [0, 1]).stdout
end

def expect_multiple_regexes(result:, regexes:)
  regexes.each do |regex|
    expect(result).to match(regex)
  end
end

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Set up selinux if appropriate.
    if fact('osfamily') == 'RedHat' && fact('selinux') == 'true'
      pp = <<-EOS
        if $::osfamily == 'RedHat' and $::selinux == 'true' {
          $semanage_package = $::operatingsystemmajrelease ? {
            '5'     => 'policycoreutils',
            default => 'policycoreutils-python',
          }

          package { $semanage_package: ensure => installed }
          exec { 'set_postgres':
            command     => 'semanage port -a -t postgresql_port_t -p tcp 5433',
            path        => '/bin:/usr/bin/:/sbin:/usr/sbin',
            subscribe   => Package[$semanage_package],
          }
        }
      EOS

      run_puppet_access_login(user: 'admin') if pe_install?
      apply_manifest_on(agents, pp, :catch_failures => false)
    end

    # net-tools required for netstat utility being used by be_listening
    if fact('osfamily') == 'RedHat' && fact('operatingsystemmajrelease') == '7'
      pp = <<-EOS
        package { 'net-tools': ensure => installed }
      EOS

      apply_manifest_on(agents, pp, :catch_failures => false)
    end

    hosts.each do |host|
      on host, "/bin/touch #{host['puppetpath']}/hiera.yaml"
      on host, 'chmod 755 /root'
      if fact_on(host, 'osfamily') == 'Debian'
        on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
        on host, '/usr/sbin/locale-gen'
        on host, '/usr/sbin/update-locale'
      end
    end
  end
end
