# frozen_string_literal: true

module Puppet::Util
  # postgresql_validator.rb
  class PostgresqlValidator
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def build_psql_cmd
      cmd = [@resource[:psql_path], '--tuples-only', '--quiet', '--no-psqlrc']

      args = {
        host: '--host',
        port: '--port',
        db_username: '--username',
        db_name: '--dbname',
        command: '--command',
      }

      args.each do |k, v|
        if @resource[k]
          cmd.push v
          cmd.push @resource[k]
        end
      end

      cmd
    end

    def connect_settings
      result = @resource[:connect_settings] || {}
      result['PGPASSWORD'] = @resource[:db_password] if @resource[:db_password]
      result
    end

    def attempt_connection(sleep_length, tries)
      (0..tries - 1).each do |_try|
        Puppet.debug "PostgresqlValidator.attempt_connection: Attempting connection to #{@resource[:db_name]}"
        cmd = build_psql_cmd
        Puppet.debug "PostgresqlValidator.attempt_connection: #{cmd.inspect}"
        result = Execution.execute(cmd, custom_environment: connect_settings, uid: @resource[:run_as])

        if result && !result.empty?
          Puppet.debug "PostgresqlValidator.attempt_connection: Connection to #{@resource[:db_name] || connect_settings.select { |elem| elem.include?('PGDATABASE') }} successful!"
          return true
        else
          Puppet.warning "PostgresqlValidator.attempt_connection: Sleeping for #{sleep_length} seconds"
          sleep sleep_length
        end
      end
      false
    end
  end
end
