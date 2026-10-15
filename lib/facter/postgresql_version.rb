# frozen_string_literal: true

Facter.add(:postgresql_version) do
  confine { Facter::Core::Execution.which('postgres') }

  setcode do
    postgres = Facter::Core::Execution.which('postgres')
    output   = Facter::Core::Execution.execute("#{postgres} --version")

    output.split.last
  end
end
