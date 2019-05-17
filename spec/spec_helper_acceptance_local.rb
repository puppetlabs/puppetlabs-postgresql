# frozen_string_literal: true

UNSUPPORTED_PLATFORMS = ['aix', 'windows', 'solaris'].freeze
class String
  def unindent
    gsub(%r{^#{scan(%r{^\s*}).min_by { |l| l.length }}}, '')
  end
end

def install_iproute2
  pp = <<-MANIFEST
    package { 'iproute2': ensure => installed }
  MANIFEST
  apply_manifest(pp) if os[:family] == 'ubuntu' && os[:release].start_with?('18.04')
end

def postgresql_version
  result = run_shell('psql --version')
  result.stdout.match(%r{\s(\d{1,2}\.\d)})[1]
end

def psql(psql_cmd, user = 'postgres', exit_codes = [0, 1], &block)
  psql = "psql #{psql_cmd}"
  run_shell("cd /tmp; su #{shellescape(user)} -c #{shellescape(psql)}", acceptable_exit_codes: exit_codes, &block)
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
