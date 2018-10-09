require 'serverspec'
require 'solid_waffle'
include SolidWaffle

set :backend, :ssh

options = Net::SSH::Config.for(host)
options[:user] = 'root'
inventory_hash = load_inventory_hash
targets = find_targets(nil, inventory_hash)
host = targets.first.to_s

set :host,        options[:host_name] || host
set :ssh_options, options

UNSUPPORTED_PLATFORMS = ['AIX', 'windows', 'Solaris', 'Suse'].freeze

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
inventory_hash = load_inventory_hash
targets = find_targets(nil, inventory_hash)
host = targets.first.to_s
  run_command("su #{shellescape(user)} -c #{shellescape(psql)}", host, config: nil, inventory: inventory_hash)  
#  shell("su #{shellescape(user)} -c #{shellescape(psql)}", acceptable_exit_codes: exit_codes, &block)
end

