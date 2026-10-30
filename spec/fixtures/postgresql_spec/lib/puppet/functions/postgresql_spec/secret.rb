# frozen_string_literal: true

# Test-only helper that mimics agent-side secret lookup functions such as
# `vault_lookup::lookup`: it declares a bare `Sensitive` return type (no inner type),
# which Puppet checks against the parameter type when the function is used in Deferred.
Puppet::Functions.create_function(:'postgresql_spec::secret') do
  dispatch :secret do
    required_param 'String', :value
    return_type 'Sensitive'
  end

  def secret(value)
    Puppet::Pops::Types::PSensitiveType::Sensitive.new(value)
  end
end
