Facter.add(:postgresql_version) do
  setcode do
    if Facter::Util::Resolution.which('postgres')
      postgresql_version = Facter::Util::Resolution.exec('postgres -V 2>&1')
      %r{^postgres \(PostgreSQL\) ([\w\.]+)}.match(postgresql_version)[1]
    end
  end
end
