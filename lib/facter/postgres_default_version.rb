def get_debian_postgres_version
  depends = Facter::Util::Resolution.exec('apt-cache show postgresql |grep "^Depends" |head -n 1')
  if match = /^Depends: postgresql-(.*)$/.match(depends)
    match[1]
  else
    nil
  end
end

def get_redhat_postgres_version
  version = Facter::Util::Resolution.exec('yum info postgresql-server |grep "^Version"')
  if match = /^Version\s*:\s*(\d+\.\d+).*$/.match(version)
    match[1]
  else
    nil
  end
end

Facter.add("postgres_default_version") do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_postgres_version()
      when 'Debian'
        get_debian_postgres_version()
      else
        nil
    end
  end
end