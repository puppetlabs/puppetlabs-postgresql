# frozen_string_literal: true

# @summary This function returns the postgresql password hash from the clear text username / password
Puppet::Functions.create_function(:'postgresql::postgresql_password') do
  # @param username
  #   The clear text `username`
  # @param password
  #   The clear text `password`
  #
  # @return [String]
  #   The postgresql password hash from the clear text username / password.
  dispatch :default_impl do
    param 'Variant[String[1],Integer]', :username
    param 'Variant[String[1],Integer]', :password
  end

  def default_impl(username, password)
    'md5' + Digest::MD5.hexdigest(password.to_s + username.to_s)
  end
end
