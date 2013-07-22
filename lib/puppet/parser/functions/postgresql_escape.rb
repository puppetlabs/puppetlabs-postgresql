# hash a string as mysql's "PASSWORD()" function would do it
require 'digest/md5'

module Puppet::Parser::Functions
  newfunction(:postgresql_escape, :type => :rvalue, :doc => <<-EOS
    Escape a string with a random tag
    EOS
  ) do |args|

    raise(Puppet::ParseError, "postgresql_escape(): Wrong number of arguments " +
      "given (#{args.size} for 1)") if args.size != 1

    password = args[0]

    if password !~ /\$\$/ 
      retval = "$$#{password}$$"
    else
      escape = (0...5).map{(65+rand(26)).chr}.join
      until password !~ /#{escape}/
        escape = (0...5).map{(65+rand(26)).chr}.join
      end
      retval = "$#{escape}$#{password}$#{escape}$"
    end
    retval 
  end
end
