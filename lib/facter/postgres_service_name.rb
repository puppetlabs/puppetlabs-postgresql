# Find latest/highest version service name for postgres
require 'puppet'
Facter.add(:postgres_service_names) do
  confine :osfamily => %w{Debian Redhat}
  setcode do
    cmd = 'find /etc/init.d/ -maxdepth 1 -type f -regex "/etc/init.d/postgresql-?[0-9]*.?[0-9]*" -exec basename {} \;'
    Facter::Util::Resolution.exec(cmd).gsub(/\s+/m, ' ').strip.split(' ')
  end
end

Facter.add(:postgres_latest_service_name) do
  confine :osfamily => %w{Debian Redhat}
  setcode do
    cmd = 'find /etc/init.d/ -maxdepth 1 -type f -regex "/etc/init.d/postgresql-?[0-9]*.?[0-9]*" -exec basename {} \; | sort -V | tail -n 1'
    Facter::Util::Resolution.exec(cmd).strip
  end
end
