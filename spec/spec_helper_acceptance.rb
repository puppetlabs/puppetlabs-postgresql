require 'serverspec'
require 'solid_waffle'
include SolidWaffle

UNSUPPORTED_PLATFORMS = ['AIX', 'windows', 'Solaris', 'Suse'].freeze

if ENV['TARGET_HOST'].nil?
  puts 'Running tests against this machine !'
else
  puts "TARGET_HOST #{ENV['TARGET_HOST']}"
  # load inventory
  inventory_hash = load_inventory_hash
  if host_in_group(inventory_hash, ENV['TARGET_HOST'], 'ssh_nodes')
    set :backend, :ssh
    options = Net::SSH::Config.for(host)
    options[:user] = 'root'
    host = ENV['TARGET_HOST']
    set :host,        options[:host_name] || host
    set :ssh_options, options
  elsif host_in_group(inventory_hash, ENV['TARGET_HOST'], 'win_rm_nodes')
    require 'winrm'

    set :backend, :winrm
    set :os, :family => 'windows'
    user = 'Administrator'
    pass = 'Qu@lity!'
    endpoint = "http://#{ENV['TARGET_HOST']}:5985/wsman"

    opts = {
       user: user,
       password: pass,
       endpoint: endpoint,
       operation_timeout: 300,
    }

    winrm = WinRM::Connection.new ( opts)
    Specinfra.configuration.winrm = winrm
  else
    raise "#{ENV['TARGET_HOST']} is not a member of any handled groups, check inventory.yaml"
  end
end

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

