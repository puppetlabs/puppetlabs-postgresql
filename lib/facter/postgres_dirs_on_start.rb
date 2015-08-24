# Record postgres bin and data directories so data migrations can be performed
# if postgres is upgraded
require 'puppet'
Facter.add(:postgres_most_current_bin_dir) do
  confine :osfamily => %w{Debian Redhat}
  os = Facter.value(:osfamily)
  setcode do
    if os == 'Debian'
      cmd = 'find /usr/lib/postgresql -maxdepth 2 -type d -wholename "/usr/lib/postgresql/[0-9]*.[0-9]*/bin" | sort -V | tail -n 1'
    else
      cmd = 'find /usr -type f -name "psql" | sort -V | tail -n 2 | head -n 1 | xargs dirname'
    end
    Facter::Util::Resolution.exec(cmd)
  end
end

Facter.add(:postgres_most_current_data_dir) do
  confine :osfamily => %w{Debian Redhat}
  os = Facter.value(:osfamily)
  setcode do
    if os == 'Debian'
      cmd =  'find /var/lib/postgresql -maxdepth 2 -type d -regex ".*[0-9]\.[0-9]/main" | sort -V | tail -n 1'
    else
      cmd = 'find /var/lib -maxdepth 4 -type d -regex ".*\(pgsql\|postgres\)+.*/data" | sort -V | head -n 1'
    end
    Facter::Util::Resolution.exec(cmd)
  end
end
