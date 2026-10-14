# frozen_string_literal: true

# @summary This function exists for usage of a role password that is a deferred function
Puppet::Functions.create_function(:'postgresql::prepend_sql_password') do
  # @param password
  #   The clear text `password`
  #   Accept both String and Sensitive[String]
  dispatch :default_impl do
    required_param 'Variant[String, Sensitive[String]]', :password
    return_type 'String'
  end
  def default_impl(password)
    pwd = password.respond_to?(:unwrap) ? password.unwrap : password
    "ENCRYPTED PASSWORD '#{pwd}'"
  end
end
