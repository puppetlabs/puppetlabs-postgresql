# frozen_string_literal: true

# @summary DEPRECATED.  Use the namespaced function [`postgresql::postgresql_password`](#postgresqlpostgresql_password) instead.
Puppet::Functions.create_function(:postgresql_password) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'postgresql_password', 'This method is deprecated, please use postgresql::postgresql_password instead.')
    call_function('postgresql::postgresql_password', *args)
  end
end
