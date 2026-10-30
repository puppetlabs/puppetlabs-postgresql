# frozen_string_literal: true

Facter.add(:postgresql_version) do
  confine { Facter::Core::Execution.which('postgres') }

  setcode do
    output   = Facter::Core::Execution.execute("postgres --version")

    output.split.last
  end
end
