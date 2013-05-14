Puppet::Type.newtype(:postgresql_setting) do
  @doc = "Manage postgresql config settings"

  ensurable

  newparam(:name) do
    desc "The option name"

    isnamevar

    validate do |value|
      raise Puppet::Error, "Name must only contain word characters" if value =~ /\W/
    end

    munge do |value|
      value.downcase
    end
  end

  newproperty(:value) do
    desc "The parameter value"
  end

  newproperty(:description) do
    desc "An optional description"
  end

  newproperty(:target) do
    desc "The location of the configuration file"

    defaultto do
      if @resource.class.defaultprovider.ancestors.include? Puppet::Provider::ParsedFile
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end
  end
end
