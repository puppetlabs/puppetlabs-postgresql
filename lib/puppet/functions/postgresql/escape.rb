# Safely escapes a string using $$ using a random tag which should be consistent

require 'digest/md5'

Puppet::Functions.create_function(:'postgresql::escape') do
  dispatch :escape do
    required_param 'String', :password
    return_type 'String'
  end

  def escape(password)
    if password !~ /\$\$/ and password[-1] != '$'
      retval = "$$#{password}$$"
    else
      escape = Digest::MD5.hexdigest(password)[0..5].gsub(/\d/,'')
      until password !~ /#{escape}/
        escape = Digest::MD5.hexdigest(escape)[0..5].gsub(/\d/,'')
      end
      retval = "$#{escape}$#{password}$#{escape}$"
    end
    retval
  end
end
