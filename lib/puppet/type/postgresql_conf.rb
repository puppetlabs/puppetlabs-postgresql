# frozen_string_literal: true

Puppet::Type.newtype(:postgresql_conf) do
  @doc = 'This type allows puppet to manage postgresql.conf parameters.'
  ensurable

  newparam(:name) do
    desc 'A unique title for the resource.'
    newvalues(%r{^[\w.]+$})
  end

  newparam(:key) do
    desc 'The Postgresql parameter to manage.'
    newvalues(%r{^[\w.]+$})
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
    newvalues(%r{^(\S.*)?$})

    munge do |value|
      if value.to_i.to_s == value
        value.to_i
      elsif value.to_f.to_s == value
        value.to_f
      else
        value
      end
    end
  end

  newproperty(:comment) do
    desc 'The comment to set for this parameter.'
    newvalues(%r{^[\w\W]+$})
  end

  newparam(:target) do
    desc 'The path to the postgresql config file'
    newvalues(%r{^/\S+[a-z0-9(/)-]*\w+.conf$})
  end
end
