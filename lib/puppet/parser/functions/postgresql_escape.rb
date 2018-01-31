require 'digest/md5'

# postgresql_escape.rb
module Puppet::Parser::Functions
  newfunction(:postgresql_escape, type: :rvalue, doc: <<-EOS
    Safely escapes a string using $$ using a random tag which should be consistent
    EOS
             ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, 'postgresql_escape(): Wrong number of arguments ' \
        "given (#{args.size} for 1)")
    end

    password = args[0]

    if password !~ %r{\$\$} && password[-1] != '$'
      retval = "$$#{password}$$"
    else
      escape = Digest::MD5.hexdigest(password)[0..5].gsub(%r{\d}, '')
      until password !~ %r{#{escape}}
        escape = Digest::MD5.hexdigest(escape)[0..5].gsub(%r{\d}, '')
      end
      retval = "$#{escape}$#{password}$#{escape}$"
    end
    retval
  end
end
