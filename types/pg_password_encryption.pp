# @summary the supported password_encryption
# Note that this Enum is also defined in:
# lib/puppet/functions/postgresql/postgresql_password.rb
type Postgresql::Pg_password_encryption = Enum['md5', 'scram-sha-256']
