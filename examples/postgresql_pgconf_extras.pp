class { 'postgresql::server':
    config_hash => {
        'ip_mask_deny_postgres_user' => '0.0.0.0/32',
        'ip_mask_allow_all_users'    => '0.0.0.0/0',
        'listen_addresses'           => '*',
        'manage_redhat_firewall'     => true,
        'postgres_password'          => 'postgres',
    },
}

include 'postgresql::params'

$pg_conf_include_file = "${postgresql::params::confdir}/postgresql_puppet_extras.conf"

file { $pg_conf_include_file:
  content => 'max_connections = 123',
  notify  => Service['postgresqld'],
}

