# Basic remote access
postgresql::pg_hba_rule{ 'allow access to db foo from 2.2.2.0/24 for user foo':
  type        => 'host',
  database    => 'foo',
  user        => 'foo',
  address     => '2.2.2.0/24',
  auth_method => 'md5',
}

# LDAP Integration
postgresql::pg_hba_rule{ 'allow ldap access to db foo from 10.1.1.0/24 for all':
  type        => 'host',
  database    => 'foo',
  user        => 'all',
  address     => '10.1.1.0/24',
  auth_method => 'ldap',
  auth_option => 'ldapserver=ldap.example.net ldapprefix="cn=" ldapsuffix=", dc=example, dc=net"',
}
