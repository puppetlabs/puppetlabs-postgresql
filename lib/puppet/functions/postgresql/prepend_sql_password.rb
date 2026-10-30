# frozen_string_literal: true

# @summary Builds the `ENCRYPTED PASSWORD '...'` clause used by `postgresql::server::role`.
#
# The function is called either directly at compile time or as a Deferred function when
# the role password is itself Deferred. In the Deferred case the resolved password may
# arrive wrapped in `Sensitive` (for example from `vault_lookup::lookup`, or whenever the
# agent runs with `preprocess_deferred = true`), so both forms are accepted.
Puppet::Functions.create_function(:'postgresql::prepend_sql_password') do
  # @param password
  #   The clear text `password`
  # @return The SQL clause with the password quoted as an SQL string literal
  dispatch :from_string do
    required_param 'String', :password
    return_type 'String'
  end

  # @param password
  #   The clear text `password` wrapped in `Sensitive`
  # @return The SQL clause with the password quoted as an SQL string literal
  dispatch :from_sensitive do
    required_param 'Sensitive[String]', :password
    return_type 'String'
  end

  def from_string(password)
    "ENCRYPTED PASSWORD '#{password.gsub("'", "''")}'"
  end

  def from_sensitive(password)
    from_string(password.unwrap)
  end
end
