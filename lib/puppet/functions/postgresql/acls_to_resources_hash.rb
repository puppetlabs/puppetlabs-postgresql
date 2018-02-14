#    This internal function translates the ipv(4|6)acls format into a resource
#    suitable for create_resources. It is not intended to be used outside of the
#    postgresql internal classes/defined resources.
#
#    This function accepts an array of strings that are pg_hba.conf rules. It
#    will return a hash that can be fed into create_resources to create multiple
#    individual pg_hba_rule resources.
#
#    The second parameter is an identifier that will be included in the namevar
#    to provide uniqueness. It must be a string.
#
#    The third parameter is an order offset, so you can start the order at an
#    arbitrary starting point.
Puppet::Functions.create_function(:'postgresql::acls_to_resources_hash') do
  dispatch :acls_to_resources_hash do
    required_param 'Array', :acls
    required_param 'String', :id
    required_param 'Integer', :offset
    return_type 'Hash'
  end

  def acls_to_resources_hash(acls, id, offset)
    func_name = "postgresql::acls_to_resources_hash()"

    resources = {}
    acls.each do |acl|
      index = acls.index(acl)

      parts = acl.split

      raise(Puppet::ParseError, "#{func_name}: acl line #{index} does not " +
        "have enough parts") unless parts.length >= 4

      resource = {
        'type' => parts[0],
        'database' => parts[1],
        'user' => parts[2],
        'order' => format('%03d', offset + index),
      }
      if parts[0] == 'local' then
        resource['auth_method'] = parts[3]
        if parts.length > 4 then
          resource['auth_option'] = parts.last(parts.length - 4).join(" ")
        end
      else
        if parts[4] =~ /^\d/
          resource['address'] = parts[3] + ' ' + parts[4]
          resource['auth_method'] = parts[5]

          if parts.length > 6 then
            resource['auth_option'] = parts.last(parts.length - 6).join(" ")
          end
        else
          resource['address'] = parts[3]
          resource['auth_method'] = parts[4]

          if parts.length > 5 then
            resource['auth_option'] = parts.last(parts.length - 5).join(" ")
          end
        end
      end
      resources["postgresql class generated rule #{id} #{index}"] = resource
    end
    resources
  end
end
