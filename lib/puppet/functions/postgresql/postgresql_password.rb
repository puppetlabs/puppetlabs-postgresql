# frozen_string_literal: true

# @summary This function returns the postgresql password hash from the clear text username / password
Puppet::Functions.create_function(:'postgresql::postgresql_password') do
  # @param username
  #   The clear text `username`
  # @param password
  #   The clear text `password`
  # @param sensitive
  #   If the Postgresql-Passwordhash should be of Datatype Sensitive[String]
  #
  # @return
  #   The postgresql password hash from the clear text username / password.
  dispatch :default_impl do
    required_param 'Variant[String[1], Integer]', :username
    required_param 'Variant[String[1], Sensitive[String[1]], Integer]', :password
    optional_param 'Boolean', :sensitive
    return_type 'Variant[String, Sensitive[String]]'
  end

  def default_impl(username, password, sensitive = false)
    password = password.unwrap if password.respond_to?(:unwrap)
    result_string = 'md5' + Digest::MD5.hexdigest(password.to_s + username.to_s)
    if sensitive
      Puppet::Pops::Types::PSensitiveType::Sensitive.new(result_string)
    else
      result_string
    end
  end
end
