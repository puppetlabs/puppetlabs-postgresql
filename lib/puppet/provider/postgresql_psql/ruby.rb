# frozen_string_literal: true

Puppet::Type.type(:postgresql_psql).provide(:ruby) do
  desc 'Postgres psql provider'
  def run_unless_sql_command(sql)
    # for the 'unless' queries, we wrap the user's query in a 'SELECT COUNT',
    # which makes it easier to parse and process the output.
    run_sql_command('SELECT COUNT(*) FROM (' + sql + ') count')
  end

  def run_sql_command(sql)
    if resource[:search_path]
      sql = "set search_path to #{Array(resource[:search_path]).join(',')}; #{sql}"
    end

    command = [resource[:psql_path]]
    command.push('-d', resource[:db]) if resource[:db]
    command.push('-p', resource[:port].to_s) if resource[:port]
    command.push('-t', '-X', '-c', sql)

    environment = fetch_environment

    if resource[:cwd]
      Dir.chdir resource[:cwd] do
        run_command(command, resource[:psql_user], resource[:psql_group], environment)
      end
    else
      run_command(command, resource[:psql_user], resource[:psql_group], environment)
    end
  end

  private

  def fetch_environment
    environment = (resource[:connect_settings] || {}).dup
    envlist = resource[:environment]
    return environment unless envlist

    envlist = [envlist] unless envlist.is_a? Array
    envlist.each do |setting|
      if setting =~ %r{^(\w+)=((.|\n)+)$}
        env_name = Regexp.last_match(1)
        value = Regexp.last_match(2)
        if environment.include?(env_name) || environment.include?(env_name.to_sym)
          if env_name == 'NEWPGPASSWD'
            warning "Overriding environment setting '#{env_name}' with '****'"
          else
            warning "Overriding environment setting '#{env_name}' with '#{value}'"
          end
        end
        environment[env_name] = value
      else
        warning "Cannot understand environment setting #{setting.inspect}"
      end
    end
    environment
  end

  def run_command(command, user, group, environment)
    output = Puppet::Util::Execution.execute(command, uid: user,
                                                      gid: group,
                                                      failonfail: false,
                                                      combine: true,
                                                      override_locale: true,
                                                      custom_environment: environment,
                                                      sensitive: resource[:sensitive] == :true)
    [output, $CHILD_STATUS.dup]
  end
end
