class { 'postgresql::server':
    config_hash => {
        'ip_mask_postgres_user' => '0.0.0.0/0',
        'ip_mask_all_users' => '0.0.0.0/0',
        'listen_addresses' => '*',
        'manage_redhat_firewall' => true,
        'postgres_password' => 'postgres',
    },
}

postgresql::database{ ['test1', 'test2', 'test3']:
  # TODO: ensure not yet supported
  #ensure  => present,
  charset => 'utf8',
  require => Class['postgresql::server'],
}
postgresql::database{ 'test4':
  # TODO: ensure not yet supported
  #ensure  => present,
  charset => 'latin1',
  require => Class['postgresql::server'],
}
