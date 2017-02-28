module Puppet
  module Util
    class PostgresqlValidator
      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def build_psql_cmd
        final_cmd = []

        cmd_init = "#{@resource[:psql_path]} --tuples-only --quiet "

        final_cmd.push cmd_init

        cmd_parts = {
          :host => "-h #{@resource[:host]}",
          :port => "-p #{@resource[:port]}",
          :db_username => "-U #{@resource[:db_username]}",
          :db_name => "--dbname #{@resource[:db_name]}"
        }

        cmd_parts[:db_password] = "-w " if @resource[:db_password]

        cmd_parts.each do |k,v|
          final_cmd.push v if @resource[k]
        end

        final_cmd.join ' '
      end

      def parse_connect_settings
        c_settings = @resource[:connect_settings] || {}
        c_settings.merge! ({ 'PGPASSWORD' => @resource[:db_password] }) if @resource[:db_password]
        return c_settings.map { |k,v| "#{k}=#{v}" }
      end

      def attempt_connection(sleep_length, tries)
        (0..tries-1).each do |try|
          Puppet.debug "PostgresqlValidator.attempt_connection: Attempting connection to #{@resource[:db_name]}"
          if execute_command =~ /1/
            Puppet.debug "PostgresqlValidator.attempt_connection: Connection to #{@resource[:db_name]} successful!"
            return true
          else
            Puppet.warning "PostgresqlValidator.attempt_connection: Sleeping for #{sleep_length} seconds"
            sleep sleep_length
          end
        end
        false
      end

      private

      def execute_command
        Execution.execute(build_validate_cmd, :uid => @resource[:run_as])
      end

      def build_validate_cmd
        "/bin/echo 'SELECT 1' | #{parse_connect_settings.join(' ')} #{build_psql_cmd} "
      end
    end
  end
end
