# frozen_string_literal: true

Puppet::Type.newtype(:postgresql_conf) do
  @doc = 'This type allows puppet to manage postgresql.conf parameters.'

  ensurable

  def self.title_patterns
  [
    [ /^(.+\.conf):([\w.]+)$/m, [ [:target], [:key] ] ],
    # TODO: make target optional
    #[ /^([\w.]+)$/m, [ [:key] ] ],
  ]
  end


  newparam(:key, namevar: true) do
    desc 'The postgresql parameter name to manage.'
    isrequired
    newvalues(%r{^[\w.]+$})
  end

  newproperty(:value) do
    desc 'The value to set for this parameter.'
  end

  newparam(:target, namevar: true) do
    desc 'The path to postgresql.conf'
    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end
  end
end
