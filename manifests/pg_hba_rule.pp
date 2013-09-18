# This resource manages an individual rule that applies to the file defined in
# $target.
define postgresql::pg_hba_rule(
  $type,
  $database,
  $user,
  $auth_method,
  $address = undef,
  $description = 'none',
  $auth_option = undef,
  $target = $postgresql::params::pg_hba_conf_path,
  $order = '150'
) {
  include postgresql::params

  validate_re($type, '^(local|host|hostssl|hostnossl)$',
    "The type you specified [${type}] must be one of: local, host, hostssl, hostnosssl")

  $allowed_auth_methods = $postgresql::params::version ? {
    "9.3" => ["trust", "reject", "md5", "password", "gss", "sspi", "krb5", "ident", "peer", "ldap", "radius", "cert", "pam"],
    "9.2" => ["trust", "reject", "md5", "password", "gss", "sspi", "krb5", "ident", "peer", "ldap", "radius", "cert", "pam"],
    "9.1" => ["trust", "reject", "md5", "password", "gss", "sspi", "krb5", "ident", "peer", "ldap", "radius", "cert", "pam"],
    "9.0" => ["trust", "reject", "md5", "password", "gss", "sspi", "krb5", "ident", "ldap", "radius", "cert", "pam"],
    "8.4" => ["trust", "reject", "md5", "password", "gss", "sspi", "krb5", "ident", "ldap", "cert", "pam"],
    "8.3" => ["trust", "reject", "md5", "crypt", "password", "gss", "sspi", "krb5", "ident", "ldap", "pam"],
    "8.2" => ["trust", "reject", "md5", "crypt", "password", "krb5", "ident", "ldap", "pam"],
    "8.1" => ["trust", "reject", "md5", "crypt", "password", "krb5", "ident", "pam"],
    default => ["trust", "reject", "md5", "password", "gss", "sspi", "krb5", "ident", "peer", "ldap", "radius", "cert", "pam", "crypt"]
  }

  $auth_method_regex = join(["^(", join($allowed_auth_methods, '|'), ")$"])
  validate_re($auth_method, $auth_method_regex,
    join(["The auth_method you specified [${auth_method}] must be one of: ", join($allowed_auth_methods, ', ')]))

  if($type =~ /^host/ and $address == undef) {
    fail('You must specify an address property when type is host based')
  }

  # This is required to make sure concat::setup is initialized first. This
  # probably points to a bug inside ripienaar-concat.
  include concat::setup

  # Create a rule fragment
  $fragname = "pg_hba_rule_${name}"
  concat::fragment { $fragname:
    target  => $target,
    content => template('postgresql/pg_hba_rule.conf'),
    order   => $order,
    owner   => $::id,
    mode    => '0600',
  }

  Class['concat::setup']->
    Concat::Fragment[$fragname]
}
