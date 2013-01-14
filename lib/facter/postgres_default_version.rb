def get_debianfamily_postgres_version
  case Facter.value('operatingsystem')
    when "Debian"
      get_debian_postgres_version()
    when "Ubuntu"
      get_ubuntu_postgres_version()
    else
      nil
  end
end

def get_debian_postgres_version
  case Facter.value('operatingsystemrelease')
    # TODO: add more debian versions or better logic here
    when /^6\./
      "8.4"
    when /^wheezy/
      "9.1"
    else
      nil
  end
end

def get_ubuntu_postgres_version
  case Facter.value('operatingsystemrelease')
    # TODO: add more ubuntu versions or better logic here
    when "12.10"
      "9.1"
    when "12.04"
      "9.1"
    when "10.04"
      "8.4"
    else
      nil
  end
end

def get_redhatfamily_postgres_version
  case Facter.value('operatingsystemrelease')
    when /^6\./
      "8.4"
    when /^5\./
      "8.1"
    else
      nil
  end
end

Facter.add("postgres_default_version") do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhatfamily_postgres_version()
      when 'Linux'
        get_redhatfamily_postgres_version()
      when 'Debian'
        get_debianfamily_postgres_version()
      else
        "Unsupported OS!  Please check `postgres_default_version` fact."
    end
  end
end