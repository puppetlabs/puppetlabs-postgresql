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
  # @param salt
  #   Use a specific salt value for scram-sha-256, default is username
  #
  # @return
  #   The postgresql password hash from the clear text username / password.
  dispatch :default_impl do
    required_param 'Variant[String[1], Integer]', :username
    required_param 'Variant[String[1], Sensitive[String[1]], Integer]', :password
    optional_param 'Boolean', :sensitive
    optional_param "Optional[Enum['md5', 'scram-sha-256']]", :hash
    optional_param 'Optional[Variant[String[1], Integer]]', :salt
    return_type 'Variant[String, Sensitive[String]]'
  end

  def default_impl(username, password, sensitive = false, hash = 'md5', salt = nil)
    password = password.unwrap if password.respond_to?(:unwrap)
    pass = if hash == 'md5'
             'md5' + Digest::MD5.hexdigest(password.to_s + username.to_s)
           else
             pg_sha256(password, (salt || username))
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
      server_key: Base64.strict_encode64(server_key(digest)),
    }
  end

  def digest_key(password, salt)
    OpenSSL::KDF.pbkdf2_hmac(
      password,
      salt: salt,
      iterations: 4096,
      length: 32,
      hash: OpenSSL::Digest::SHA256.new,
    )
  end

  def client_key(digest_key)
    hmac = OpenSSL::HMAC.new(digest_key, OpenSSL::Digest::SHA256.new)
    hmac << 'Client Key'
    hmac.digest
    OpenSSL::Digest.new('SHA256').digest hmac.digest
  end

  def server_key(digest_key)
    hmac = OpenSSL::HMAC.new(digest_key, OpenSSL::Digest::SHA256.new)
    hmac << 'Server Key'
    hmac.digest
  end
end
