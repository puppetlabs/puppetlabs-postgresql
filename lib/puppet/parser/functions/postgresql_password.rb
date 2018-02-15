# hash a string as mysql's "PASSWORD()" function would do it
require 'digest/md5'

# postgresql_password.rb
module Puppet::Parser::Functions
  newfunction(:postgresql_password, type: :rvalue, doc: <<-EOS
    Returns the postgresql password hash from the clear text username / password.
    EOS
             ) do |args|

    if args.size != 2
      raise(Puppet::ParseError, 'postgresql_password(): Wrong number of arguments ' \
        "given (#{args.size} for 2)")
    end

    username = args[0]
    password = args[1]

    'md5' + Digest::MD5.hexdigest(password.to_s + username.to_s)
  end
end
