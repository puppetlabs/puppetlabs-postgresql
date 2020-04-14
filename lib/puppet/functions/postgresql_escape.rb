# @summary DEPRECATED.  Use the namespaced function [`postgresql::postgresql_escape`](#postgresqlpostgresql_escape) instead.
Puppet::Functions.create_function(:postgresql_escape) do
  dispatch :deprecation_gen do
    repeated_param 'Any', :args
  end
  def deprecation_gen(*args)
    call_function('deprecation', 'postgresql_escape', 'This method is deprecated, please use postgresql::postgresql_escape instead.')
    call_function('postgresql::postgresql_escape', *args)
  end
end
