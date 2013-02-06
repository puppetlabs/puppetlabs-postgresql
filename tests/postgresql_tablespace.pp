class { 'postgresql::server':
    config_hash => {
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users'    => '0.0.0.0/0',
        'listen_addresses'           => '*',
        'manage_redhat_firewall'     => true,
        'postgres_password'          => 'postgres',
    },
}

file { '/tmp':
  ensure => 'directory',
}
file { '/tmp/pg_tablespaces':
  ensure  => 'directory',
  owner   => 'postgres',
  group   => 'postgres',
  mode    => '0700',
  require => File['/tmp'],
}

postgresql::tablespace{ 'tablespace1':
  location => '/tmp/pg_tablespaces/space1',
  require => [Class['postgresql::server'], File['/tmp/pg_tablespaces']],
}
postgresql::database{ 'tablespacedb1':
  # TODO: ensure not yet supported
  #ensure  => present,
  charset => 'utf8',
  require => Class['postgresql::server'],
}
postgresql::database{ 'tablespacedb2':
  # TODO: ensure not yet supported
  #ensure  => present,
  charset => 'utf8',
  tablespace => 'tablespace1',
  require => Postgresql::Tablespace['tablespace1'],
}
postgresql::db{ 'tablespacedb3':
  # TODO: ensure not yet supported
  #ensure  => present,
  user => 'dbuser1',
  password => 'dbuser1',
  require => Class['postgresql::server'],
}
postgresql::db{ 'tablespacedb4':
  # TODO: ensure not yet supported
  #ensure  => present,
  user => 'dbuser2',
  password => 'dbuser2',
  tablespace => 'tablespace1',
  require => Postgresql::Tablespace['tablespace1'],
}

postgresql::database_user{ 'spcuser':
  # TODO: ensure is not yet supported
  #ensure        => present,
  password_hash => postgresql_password('spcuser', 'spcuser'),
  require       => Class['postgresql::server'],
}
postgresql::tablespace{ 'tablespace2':
  location => '/tmp/pg_tablespaces/space2',
  owner => 'spcuser',
  require => [Postgresql::Database_user['spcuser'], File['/tmp/pg_tablespaces']],
}
postgresql::database{ 'tablespacedb5':
  # TODO: ensure not yet supported
  #ensure  => present,
  charset => 'utf8',
  tablespace => 'tablespace2',
  require => Postgresql::Tablespace['tablespace2'],
}

