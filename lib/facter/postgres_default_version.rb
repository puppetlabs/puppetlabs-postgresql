Facter.add("postgres_default_version") do
  confine :osfamily => ['Debian', 'Ubuntu']
  setcode do

    case Facter.value('operatingsystemrelease')
    # Ubuntu matches.
    when '11.10', '12.04', '12.10', '13.04'
      '9.1'
    when '10.04', '10.10', '11.04'
      '8.4'
    # Debian matches.
    when /squeeze/, /^6\./
      '8.4'
    when /^wheezy/, /^7\./
      '9.1'
    when /^jessie/, /^8\./
      '9.3'
    else
      nil
    end
  end
end

Facter.add("postgres_default_version") do
  confine :osfamily => ['RedHat', 'Linux']
  setcode do
    case Facter.value('operatingsystemrelease')
    when /^6\./
      '8.4'
    when /^5\./
      '8.1'
    else
      nil
    end
  end
end
