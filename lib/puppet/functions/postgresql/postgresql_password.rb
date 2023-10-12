# frozen_string_literal: true

require 'openssl'
require 'base64'

# @summary This function returns the postgresql password hash from the clear text username / password
Puppet::Functions.create_function(:'postgresql::postgresql_password') do
  # @param username
  #   The clear text `username`
  # @param password
  #   The clear text `password`
  # @param sensitive
  #   If the Postgresql-Passwordhash should be of Datatype Sensitive[String]
  # @param hash
  #   Set type for password hash
  #
  #   Default value comes from `postgresql::params::password_encryption` and changes based on the `postgresql::globals::version`.
  # @param salt
  #   Use a specific salt value for scram-sha-256, default is username
  #
  # @return
  #   The postgresql password hash from the clear text username / password.
  dispatch :default_impl do
    required_param 'Variant[String[1], Integer]', :username
    required_param 'Variant[String[1], Sensitive[String[1]], Integer]', :password
    optional_param 'Boolean', :sensitive
    optional_param 'Optional[Postgresql::Pg_password_encryption]', :hash
    optional_param 'Optional[Variant[String[1], Integer]]', :salt
    return_type 'Variant[String, Sensitive[String]]'
  end

  def default_impl(username, password, sensitive = false, hash = nil, salt = nil)
    hash = call_function('postgresql::default', 'password_encryption') if hash.nil?
    password = password.unwrap if password.respond_to?(:unwrap)
    if password.is_a?(String) && password.match?(%r{^(md5[0-9a-f]{32}$|SCRAM-SHA-256\$)})
      return Puppet::Pops::Types::PSensitiveType::Sensitive.new(password) if sensitive

      return password
    end
    pass = case hash
           when 'md5', nil # ensure default value when definded with nil
             "md5#{Digest::MD5.hexdigest(password.to_s + username.to_s)}"
           when 'scram-sha-256'
             pg_sha256(password, (salt || username))
           else
             raise(Puppet::ParseError, "postgresql::postgresql_password(): got unkown hash type '#{hash}'")
           end
    if sensitive
      Puppet::Pops::Types::PSensitiveType::Sensitive.new(pass)
    else
      pass
    end
  end

  def pg_sha256(password, salt)
    digest = digest_key(password, salt)
    'SCRAM-SHA-256$%{iterations}:%{salt}$%{client_key}:%{server_key}' % {
      iterations: '4096',
      salt: Base64.strict_encode64(salt),
      client_key: Base64.strict_encode64(client_key(digest)),
      server_key: Base64.strict_encode64(server_key(digest))
    }
  end

  def digest_key(password, salt)
    OpenSSL::KDF.pbkdf2_hmac(
      password,
      salt: salt,
      iterations: 4096,
      length: 32,
      hash: OpenSSL::Digest.new('SHA256'),
    )
  end

  def client_key(digest_key)
    hmac = OpenSSL::HMAC.new(digest_key, OpenSSL::Digest.new('SHA256'))
    hmac << 'Client Key'
    hmac.digest
    OpenSSL::Digest.new('SHA256').digest hmac.digest
  end

  def server_key(digest_key)
    hmac = OpenSSL::HMAC.new(digest_key, OpenSSL::Digest.new('SHA256'))
    hmac << 'Server Key'
    hmac.digest
  end
end
