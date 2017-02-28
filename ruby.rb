Puppet::Type.type(:validate_db_connection).provide(:ruby) do

  commands :psql => 'psql'

  def psql_cmd
    final_cmd = []

    cmd_init = "#{resource[:psql_path]} --tuples-only --quiet "

    final_cmd.push cmd_init

    cmd_parts = {
      :database_host => "-h #{resource[:database_host]}",
      :database_port => "-p #{resource[:database_port]}",
      :database_username => "-U #{resource[:database_username]}",
      :database_password =>"PGPASSWORD=#{resource[:database_password]}"
    }

    cmd_parts.each do |k,v|
      final_cmd.push v if resource[k]
    end

    final_cmd.join ' '
  end

  def get_validate_cmd psql_cmd
    "/bin/echo 'SELECT 1' | #{psql_cmd}"
  end

  def sleep_and_try cmd
    sleep_length = resource[:sleep]
    tries = resource[:tries]

    state = 1
    count = 1

    (count..tries).each do |try|
      Puppet.debug "Count #{count}"

      if try > 1
        Puppet.debug "Sleeping for #{sleep_length}"
        sleep sleep_length
      end

      begin
        state = `#{cmd}`
      rescue Puppet::Error => error
        Puppet::Error.new("There was a problem running the psql command: #{error}")
      end

      exit 0 if state == 0
    end

    raise Puppet::Error.new("Unable to connect to postgresql database #{resource[:database_name]}")
  end

  sleep_and_try(get_validate_cmd psql_cmd)
end
