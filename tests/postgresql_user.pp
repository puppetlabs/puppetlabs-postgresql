class { 'postgresql::server':
    config_hash => {
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users' => '0.0.0.0/0',
        'listen_addresses' => '*',
        'manage_redhat_firewall' => true,
        'postgres_password' => 'postgres',
    },
}

# TODO: in mysql module, the username includes, e.g., '@%' or '@localhost', which
#  affects the user's ability to connect from remote hosts.  In postgres this is
#  managed via pg_hba.conf; not sure if we want to try to reconcile that difference
#  in the modules or not.
postgresql::database_user{ 'redmine':
  # TODO: ensure is not yet supported
  #ensure        => present,
  password_hash => postgresql_password('redmine', 'redmine'),
  require       => Class['postgresql::server'],
}

postgresql::database_user{ 'dan':
  # TODO: ensure is not yet supported
  #ensure        => present,
  password_hash => postgresql_password('dan', 'blah'),
  require       => Class['postgresql::server'],
}

