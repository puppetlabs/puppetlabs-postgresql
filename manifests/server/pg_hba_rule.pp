# @summary This resource manages an individual rule that applies to the file defined in target.
#
# @param type Sets the type of rule.
#   Enum['local','host','hostssl','hostnossl','hostgssenc'].
# @param database Sets a comma-separated list of databases that this rule matches.
# @param user Sets a comma-separated list of users that this rule matches.
# @param auth_method Provides the method that is used for authentication for the connection that this rule matches. Described further in the PostgreSQL pg_hba.conf documentation.
# @param address Sets a CIDR based address for this rule matching when the type is not 'local'.
# @param description Defines a longer description for this rule, if required. This description is placed in the comments above the rule in pg_hba.conf. Default value: 'none'.
# @param auth_option For certain auth_method settings there are extra options that can be passed. Consult the PostgreSQL pg_hba.conf documentation for further details.
# @param order Sets an order for placing the rule in pg_hba.conf. This can be either a string or an integer. If it is an integer, it will be converted to a string by zero-padding it to three digits. E.g. 42 will be zero-padded to the string '042'. The pg_hba_rule fragments are sorted using the alpha sorting order. Default value: 150.
# @param target Provides the target for the rule, and is generally an internal only property. Use with caution.
# @param postgresql_version Manages pg_hba.conf without managing the entire PostgreSQL instance.
define postgresql::server::pg_hba_rule(
  Enum['local', 'host', 'hostssl', 'hostnossl', 'hostgssenc'] $type,
  String $database,
  String $user,
  String $auth_method,
  Optional[String] $address       = undef,
  String $description             = 'none',
  Optional[String] $auth_option   = undef,
  Variant[String, Integer] $order = 150,

  # Needed for testing primarily, support for multiple files is not really
  # working.
  Stdlib::Absolutepath $target  = $postgresql::server::pg_hba_conf_path,
  String $postgresql_version    = $postgresql::server::_version
) {

  #Allow users to manage pg_hba.conf even if they are not managing the whole PostgreSQL instance
  if !defined( 'postgresql::server' ) {
    $manage_pg_hba_conf = true
  }
  else {
    $manage_pg_hba_conf = $postgresql::server::manage_pg_hba_conf
  }

  if $manage_pg_hba_conf == false {
      fail('postgresql::server::manage_pg_hba_conf has been disabled, so this resource is now unused and redundant, either enable that option or remove this resource from your manifests')
  } else {

    if($type =~ /^host/ and $address == undef) {
      fail('You must specify an address property when type is host based')
    }

    if $order =~ Integer {
      $_order = sprintf('%03d', $order)
    }
    else {
      $_order = $order
    }

    $allowed_auth_methods = $postgresql_version ? {
      '10'  => ['trust', 'reject', 'scram-sha-256', 'md5', 'password', 'gss', 'sspi', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam', 'bsd'],
      '9.6' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam', 'bsd'],
      '9.5' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.4' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.3' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.2' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.1' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam'],
      '9.0' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'ldap', 'radius', 'cert', 'pam'],
      '8.4' => ['trust', 'reject', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'ldap', 'cert', 'pam'],
      '8.3' => ['trust', 'reject', 'md5', 'crypt', 'password', 'gss', 'sspi', 'krb5', 'ident', 'ldap', 'pam'],
      '8.2' => ['trust', 'reject', 'md5', 'crypt', 'password', 'krb5', 'ident', 'ldap', 'pam'],
      '8.1' => ['trust', 'reject', 'md5', 'crypt', 'password', 'krb5', 'ident', 'pam'],
      default => ['trust', 'reject', 'scram-sha-256', 'md5', 'password', 'gss', 'sspi', 'krb5', 'ident', 'peer', 'ldap', 'radius', 'cert', 'pam', 'crypt', 'bsd']
    }

    assert_type(Enum[$allowed_auth_methods], $auth_method)

    # Create a rule fragment
    $fragname = "pg_hba_rule_${name}"
    concat::fragment { $fragname:
      target  => $target,
      content => template('postgresql/pg_hba_rule.conf'),
      order   => $_order,
    }
  }
}
