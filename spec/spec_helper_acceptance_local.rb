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

def postgresql_version
  result = LitmusHelper.instance.run_shell('psql --version')
  result.stdout.match(%r{\s(\d{1,2}\.\d)})[1]
end

def psql(psql_cmd, user = 'postgres', exit_codes = [0, 1], &block)
  psql = "psql #{psql_cmd}"
  LitmusHelper.instance.run_shell("cd /tmp; su #{Shellwords.shellescape(user)} -c #{Shellwords.shellescape(psql)}", acceptable_exit_codes: exit_codes, &block)
end
