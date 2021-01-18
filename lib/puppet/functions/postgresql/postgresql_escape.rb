# frozen_string_literal: true

require 'digest/md5'

# @summary This function escapes a string using [Dollar Quoting](https://www.postgresql.org/docs/12/sql-syntax-lexical.html#SQL-SYNTAX-DOLLAR-QUOTING) using a randomly generated tag if required.
Puppet::Functions.create_function(:'postgresql::postgresql_escape') do
  # @param input_string
  #   The unescaped string you want to escape using `dollar quoting`
  #
  # @return [String]
  #   A `Dollar Quoted` string
  dispatch :default_impl do
    param 'String[1]', :input_string
  end

  def default_impl(input_string)
    # Where allowed, just return the original string wrapped in `$$`
    return "$$#{input_string}$$" unless tag_needed?(input_string)

    # Keep generating possible values for tag until we find one that doesn't appear in the input string
    tag = Digest::MD5.hexdigest(input_string)[0..5].gsub(%r{\d}, '')
    tag = Digest::MD5.hexdigest(tag)[0..5].gsub(%r{\d}, '') until input_string !~ %r{#{tag}}

    "$#{tag}$#{input_string}$#{tag}$"
  end

  def tag_needed?(input_string)
    input_string.include?('$$') || input_string.end_with?('$')
  end
end
