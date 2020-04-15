# @summary This internal function translates the ipv(4|6)acls format into a resource suitable for create_resources.
# @api private
Puppet::Functions.create_function(:'postgresql::postgresql_acls_to_resources_hash') do
  # @param acls
  #   An array of strings that are pg_hba.conf rules.
  # @param id
  #   An identifier that will be included in the namevar to provide uniqueness.
  # @param offset
  #   An order offset, so you can start the order at an arbitrary starting point.
  #
  # @return [Hash]
  #   A hash that can be fed into create_resources to create multiple individual pg_hba_rule resources.
  dispatch :default_impl do
    param 'Array[String]', :acls
    param 'String[1]', :id
    param 'Integer[0]', :offset
  end

  def default_impl(acls, id, offset)
    resources = {}
    acls.each do |acl|
      index = acls.index(acl)

      parts = acl.split

      unless parts.length >= 4
        raise(Puppet::ParseError, "postgresql::postgresql_acls_to_resources_hash(): acl line #{index} does not " \
          'have enough parts')
      end

      resource = {
        'type'     => parts[0],
        'database' => parts[1],
        'user'     => parts[2],
        'order'    => '%03d' % (offset + index),
      }
      if parts[0] == 'local'
        resource['auth_method'] = parts[3]
        if parts.length > 4
          resource['auth_option'] = parts.last(parts.length - 4).join(' ')
        end
      elsif parts[4] =~ %r{^\d}
        resource['address'] = parts[3] + ' ' + parts[4]
        resource['auth_method'] = parts[5]

        resource['auth_option'] = parts.last(parts.length - 6).join(' ') if parts.length > 6
      else
        resource['address'] = parts[3]
        resource['auth_method'] = parts[4]

        resource['auth_option'] = parts.last(parts.length - 5).join(' ') if parts.length > 5
      end
      resources["postgresql class generated rule #{id} #{index}"] = resource
    end
    resources
  end
end
