pg_role { 'user1':
  ensure => present,
  inrole => ['group1'],
}

pg_role { 'group1':
  ensure => present,
}

pg_role { 'new_user':
  ensure => present,
  password => 'secret',
  replication => true,
  superuser => true,
  connection_limit => 13,
  createdb => true,
  valid_until => 'Nov 24 11:11:11 2017',
  inrole => ['group1'],
  require => Class['postgresql::server'],
}

pg_role { 'user2':
  ensure => present,
  inrole => ['group2'],
}

pg_role { 'group2':
  ensure => present,
}

