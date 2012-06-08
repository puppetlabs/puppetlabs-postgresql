class { 'postgresql::server':
    config_hash => {
        'ip_mask_postgres_user' => '0.0.0.0/0',
        'ip_mask_all_users' => '0.0.0.0/0',
        'listen_addresses' => '*',
        'manage_redhat_firewall' => true,
        'postgres_password' => 'postgres',
    },
}
