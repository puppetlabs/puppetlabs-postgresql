# frozen_string_literal: true

Facter.add('postgres_version') do
  confine { Facter::Core::Execution.which('postgres') }
  setcode do
    version = Facter::Core::Execution.execute('postgres -V 2>/dev/null')
    version.match(%r{\d+\.\d+$})[0] if version
  end
end
