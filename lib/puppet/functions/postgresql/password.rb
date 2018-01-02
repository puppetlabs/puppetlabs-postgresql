# hash a string as mysql's "PASSWORD()" function would do it
# Returns the postgresql password hash from the clear text username / password.

require 'digest/md5'

Puppet::Functions.create_function(:'postgresql::password') do
  dispatch :password do
    required_param 'String', :username
    required_param 'Variant[String, Integer]', :password
    return_type 'String'
  end

  def password(username, password)
    'md5' + Digest::MD5.hexdigest(password.to_s + username.to_s)
  end
end
