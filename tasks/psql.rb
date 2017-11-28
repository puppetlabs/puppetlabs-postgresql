#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def get(sql, host, port, database, user, password)
  env_hash = {'PGPASSWORD' => password} unless password.nil?
  cmd_string = "psql -c \"#{sql}\""
  cmd_string << " --host=#{host}" unless host.nil?
  cmd_string << " --port=#{port}" unless port.nil?
  cmd_string << " --dbname=#{database}" unless database.nil?
  cmd_string << " --username=#{user}" unless user.nil?
  stdout, stderr, status = Open3.capture3(env_hash, cmd_string)
  raise Puppet::Error, _("stderr: '#{stderr}'") if status != 0
  { status: stdout.strip }
end

params = JSON.parse(STDIN.read)
host = params['host']
port = params['port']
database = params['database']
user = params['user']
password = params['password']
sql = params['sql']

begin
  result = get(sql, host, port, database, user, password)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end
