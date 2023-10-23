# frozen_string_literal: true

require 'puppet/provider/parsedfile'

Puppet::Type.type(:postgresql_conf).provide(
  :parsed,
  parent: Puppet::Provider::ParsedFile,
  default_target: '/etc/postgresql.conf',
  filetype: :flat,
) do
  desc 'Set key/values in postgresql.conf.'

  text_line :comment, match: %r{^\s*#}
  text_line :blank, match: %r{^\s*$}

  record_line :parsed,
              fields: ['key', 'value', 'comment'],
              optional: ['comment'],
              match: %r{^\s*([\w.]+)\s*=?\s*(.*?)(?:\s*#\s*(.*))?\s*$},
              to_line: proc { |h|
                # simple string and numeric values don't need to be enclosed in quotes
                val = if h[:value].is_a?(Numeric)
                        h[:value].to_s
                      elsif h[:value].is_a?(Array)
                        # multiple listen_addresses specified as a string containing a comma-speparated list
                        h[:value].join(', ')
                      else
                        h[:value]
                      end
                dontneedquote = val.match(%r{^(\d+.?\d+|\w+)$})
                dontneedequal = h[:key].match(%r{^(include|include_if_exists)$}i)

                str =  h[:key].downcase # normalize case
                str += dontneedequal ? ' ' : ' = '
                str += "'" unless dontneedquote && !dontneedequal
                str += val
                str += "'" unless dontneedquote && !dontneedequal
                str += " # #{h[:comment]}" unless h[:comment].nil? || h[:comment] == :absent
                str
              },
              post_parse: proc { |h|
                h[:key].downcase! # normalize case
                h[:value].gsub!(%r{(^'|'$)}, '') # strip out quotes
              }
end
