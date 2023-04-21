# frozen_string_literal: true

Puppet::Type.newtype(:postgresql_replication_slot) do
  @doc = <<~EOS
    @summary Manages Postgresql replication slots.

    This type allows to create and destroy replication slots
    to register warm standby replication on a Postgresql
    primary server.
  EOS

  ensurable

  newparam(:name) do
    desc 'The name of the slot to create. Must be a valid replication slot name.'
    isnamevar
    newvalues %r{^[a-z0-9_]+$}
  end
end
