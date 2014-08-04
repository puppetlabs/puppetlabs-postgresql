module Puppet::Parser::Functions
  newfunction(:hash_to_pgs_config_entries, :type => :rvalue, :doc => <<-EOS
    This function accepts a hash of (postgresql.conf) key values. It
    will return a hash that can be fed into create_resources to create multiple
    individual config_entry resources.
    It is not intended to be used outside of the postgresql internal
    classes/defined resources.

    EOS
  ) do |args|
    func_name = ":hash_to_pgs_config_entries()"

    raise(Puppet::ParseError, "#{func_name}: Wrong number of arguments " +
      "given (#{args.size} for 1)") if args.size != 1

    kv = args[0]
    kv.each do |k, v|
      kv[k] = {:value => v}
    end
  end
end
