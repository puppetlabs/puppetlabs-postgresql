#!/opt/puppetlabs/puppet/bin/ruby
# frozen_string_literal: true

require 'json'
require 'open3'
require 'puppet'

def get(sql, database, user, port, password, host)
  env_hash = {}
  env_hash['PGPASSWORD'] = password unless password.nil?
  cmd_string = ['psql', '-c', sql]
  cmd_string << "--dbname=#{database}" unless database.nil?
  cmd_string << "--username=#{user}" unless user.nil?
  cmd_string << "--port=#{port}" unless port.nil?
  cmd_string << "--host=#{host}" unless host.nil?
  stdout, stderr, status = Open3.capture3(env_hash, *cmd_string)
  raise Puppet::Error, stderr if status != 0

  { status: stdout.strip }
end

params = JSON.parse($stdin.read)
database = params['database']
host = params['host']
password = params['password']
port = params['port']
sql = params['sql']
user = params['user']

begin
  result = get(sql, database, user, port, password, host)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end
