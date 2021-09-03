require 'beaker-pe'
require 'beaker-puppet'
require 'puppet'
require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'
require 'beaker-task_helper'

run_puppet_install_helper
configure_type_defaults_on(hosts)
install_ca_certs unless pe_install?

UNSUPPORTED_PLATFORMS = ['aix', 'windows', 'solaris'].freeze

install_bolt_on(hosts) unless pe_install?
install_module_on(hosts)
install_module_dependencies_on(hosts)

DEFAULT_PASSWORD = if default[:hypervisor] == 'vagrant'
                     'vagrant'
                   elsif default[:hypervisor] == 'vcloud'
                     'Qu@lity!'
                   end

# Class String - unindent - Provide ability to remove indentation from strings, for the purpose of
# left justifying heredoc blocks.
class String
  def unindent
    gsub(%r{^#{scan(%r{^\s*}).min_by { |l| l.length }}}, '')
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
  str.gsub!(%r{([^A-Za-z0-9_\-.,:\/@\n])}, '\\\\\\1')

  # A LF cannot be escaped with a backslash because a backslash + LF
  # combo is regarded as line continuation and simply ignored.
  str.gsub!(%r{\n}, "'\n'")

  str
end

def psql(psql_cmd, user = 'postgres', exit_codes = [0, 1], &block)
  psql = "psql #{psql_cmd}"
  shell("su #{shellescape(user)} -c #{shellescape(psql)}", acceptable_exit_codes: exit_codes, &block)
end

def idempotent_apply(hosts, manifest, opts = {}, &block)
  block_on hosts, opts do |host|
    file_path = host.tmpfile('apply_manifest.pp')
    create_remote_file(host, file_path, manifest + "\n")

    puppet_apply_opts = { :verbose => nil, 'detailed-exitcodes' => nil }
    on_options = { acceptable_exit_codes: [0, 2] }
    on host, puppet('apply', file_path, puppet_apply_opts), on_options, &block
    puppet_apply_opts2 = { :verbose => nil, 'detailed-exitcodes' => nil }
    on_options2 = { acceptable_exit_codes: [0] }
    on host, puppet('apply', file_path, puppet_apply_opts2), on_options2, &block
  end
end

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    run_puppet_access_login(user: 'admin') if pe_install? && (Gem::Version.new(puppet_version) >= Gem::Version.new('5.0.0'))
    # Set up selinux if appropriate.
    if os[:family] == 'redhat' && fact('selinux') == 'true'
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

      apply_manifest_on(agents, pp, catch_failures: false)
    end

    # net-tools required for netstat utility being used by be_listening
    if os[:family] == 'redhat' && os[:release].start_with?('7') ||
       os[:family] == 'debian' && os[:release].start_with?('9', '18.04')
      pp = <<-EOS
        package { 'net-tools': ensure => installed }
      EOS

      apply_manifest_on(agents, pp, catch_failures: false)
    end

    hosts.each do |host|
      on host, 'chmod 755 /root'
      next unless fact_on(host, 'osfamily') == 'Debian'
      on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
      on host, '/usr/sbin/locale-gen'
      on host, '/usr/sbin/update-locale'
    end
  end
end
