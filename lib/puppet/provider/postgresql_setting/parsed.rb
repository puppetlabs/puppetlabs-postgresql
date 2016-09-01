require 'puppet/provider/parsedfile'

# Unfortunately this pretty much duplicates the logic in params.pp
postgres_version = Facter.value(:postgres_default_version)
postgres_config = case Facter.value(:osfamily)
when 'Debian'
  "/etc/postgresql/#{postgres_version}/main/postgresql.conf"
else
  "/var/lib/pgsql/#{postgres_version}/data/postgresql.conf"
end

Puppet::Type.type(:postgresql_setting).provide(
  :parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => postgres_config,
  :filetype => :flat) do

  text_line :comment, :match => /^\s*#/
  text_line :blank, :match => /^\s*$/

  record_line :parsed, :fields => %w{name value description},
    :optional => %{description},
    :match => /^\s*(\w+)\s*[=\s]\s*'?(.*?)'?\s*(?:#\s*(.*))?$/,
    :post_parse => proc { |h|
      h[:name] = h[:name].downcase
      h
    },
    :to_line => proc { |h|
      quote = case h[:value]
      when %w{on off true false yes no}
        ''
      when /^\d+(\.\d+)?(ms|s|min|h|d|kB|MB|GB)?$/
        ''
      else
        '\''
      end
      str = "#{h[:name]} = #{quote}#{h[:value]}#{quote}"
      if description = h[:description] and description != :absent and !description.empty?
        str += " # #{description}"
      end
      str
    }
end
