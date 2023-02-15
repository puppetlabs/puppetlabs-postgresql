# frozen_string_literal: true

require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.before :suite do
    LitmusHelper.instance.apply_manifest(File.read(File.join(__dir__, 'setup_acceptance_node.pp')))
  end
end

def export_locales(locale)
  LitmusHelper.instance.run_shell('echo export PATH="/opt/puppetlabs/bin:$PATH" > ~/.bashrc')
  LitmusHelper.instance.run_shell('echo export LC_ALL="C" > /etc/profile.d/my-custom.lang.sh')
  LitmusHelper.instance.run_shell("echo \"## #{locale} ##\" >> /etc/profile.d/my-custom.lang.sh")
  LitmusHelper.instance.run_shell("echo export LANG=#{locale} >> /etc/profile.d/my-custom.lang.sh")
  LitmusHelper.instance.run_shell("echo export LANGUAGE=#{locale} >> /etc/profile.d/my-custom.lang.sh")
  LitmusHelper.instance.run_shell('echo export LC_COLLATE=C >> /etc/profile.d/my-custom.lang.sh')
  LitmusHelper.instance.run_shell("echo export LC_CTYPE=#{locale} >> /etc/profile.d/my-custom.lang.sh")
  LitmusHelper.instance.run_shell('source /etc/profile.d/my-custom.lang.sh')
  LitmusHelper.instance.run_shell('echo export LC_ALL="C" >> ~/.bashrc')
  LitmusHelper.instance.run_shell('source ~/.bashrc')
end

def pre_run
  LitmusHelper.instance.apply_manifest("class { 'postgresql::server': postgres_password => 'postgres' }", catch_failures: true)
end

def postgresql_version
  result = LitmusHelper.instance.run_shell('psql --version')
  result.stdout.match(%r{\s(\d{1,2}\.\d)})[1]
end

def psql(psql_cmd, user = 'postgres', exit_codes = [0, 1], &block)
  psql = "psql #{psql_cmd}"
  LitmusHelper.instance.run_shell("cd /tmp; su #{shellescape(user)} -c #{shellescape(psql)}", acceptable_exit_codes: exit_codes, &block)
end

def shellescape(str)
  str = str.to_s

  # An empty argument will be skipped, so return empty quotes.
  return "''" if str.empty?

  str = str.dup

  # Treat multibyte characters as is.  It is caller's responsibility
  # to encode the string in the right encoding for the shell
  # environment.
  str.gsub!(%r{([^A-Za-z0-9_\-.,:/@\n])}, '\\\\\\1')

  # A LF cannot be escaped with a backslash because a backslash + LF
  # combo is regarded as line continuation and simply ignored.
  str.gsub!(%r{\n}, "'\n'")

  str
end
