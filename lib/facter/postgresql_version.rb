Facter.add(:postgresql_version) do
  setcode do
    if Facter::Util::Resolution.which('psql')
      postgresql_version = Facter::Util::Resolution.exec('psql -V 2>&1')
      %r{^psql \(PostgreSQL\) ([\w\.]+)}.match(postgresql_version)[1]
    end
  end
end
