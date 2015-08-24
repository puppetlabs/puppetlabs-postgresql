# Record postgres locale info so data migrations can be performed
# if postgres is upgraded and new cluster can be created with the same locale
require 'puppet'
require 'etc'

def run_sql_command(sql)
  postgres_user = Etc.getpwnam("postgres")
  user = postgres_user['uid']
  group = postgres_user['gid']
  command = "psql -qtc '#{sql}'"
  if Puppet::PUPPETVERSION.to_f < 3.0
    require 'puppet/util/execution'
    Puppet::Util::Execution.withenv environment do
      output = Puppet::Util::SUIDManager.run_and_capture(command, user, group)
    end
  elsif Puppet::PUPPETVERSION.to_f < 3.4
    Puppet::Util.withenv environment do
      output  = Puppet::Util::SUIDManager.run_and_capture(command, user, group)
    end
  else
      output = Puppet::Util::Execution.execute(command, { :uid => user, :gid => group})
  end
  output.strip
end

Facter.add(:postgres_cluster_locale_collate) do
  setcode do
      run_sql_command('show LC_COLLATE;')
  end
end

Facter.add(:postgres_cluster_locale_ctype) do
  setcode do
      run_sql_command('show LC_CTYPE;')
  end
end

Facter.add(:postgres_cluster_locale_messages) do
  setcode do
      run_sql_command('show LC_MESSAGES;')
  end
end

Facter.add(:postgres_cluster_locale_monetary) do
  setcode do
      run_sql_command('show LC_MONETARY;')
  end
end

Facter.add(:postgres_cluster_locale_numeric) do
  setcode do
      run_sql_command('show LC_NUMERIC;')
  end
end

Facter.add(:postgres_cluster_locale_time) do
  setcode do
      run_sql_command('show LC_TIME;')
  end
end

Facter.add(:postgres_server_encoding) do
  setcode do
      run_sql_command('show SERVER_ENCODING;')
  end
end

