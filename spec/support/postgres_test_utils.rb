module PostgresTestUtils
  def sudo_and_log(vm, cmd)
    @logger.debug("Running command: '#{cmd}'")
    result = ""
    @env.vms[vm].channel.sudo("cd /tmp && #{cmd}") do |ch, data|
      result << data
      @logger.debug(data)
    end
    result
  end

  def sudo_psql_and_log(vm, psql_cmd, user = 'postgres')
    sudo_and_log(vm, "su #{user} -c 'psql #{psql_cmd}'")
  end
end