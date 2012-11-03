class { 'postgresql::server':
  config_hash => {
      'ip_mask_allow_all_users' => '0.0.0.0/0',
      'listen_addresses'        => '*',
      'manage_redhat_firewall'  => true,

      #'ip_mask_deny_postgres_user' => '0.0.0.0/32',
      #'postgres_password' => 'puppet',
  },
}

postgresql::db{ 'test1':
  user          => 'test1',
  password      => 'test1',
  grant         => 'all',
}

postgresql::db{ 'test2':
  user          => 'test2',
  password      => postgresql_password('test2', 'test2'),
  grant         => 'all',
}

postgresql::db{ 'test3':
  user          => 'test3',
  # The password here is a copy/paste of the output of the 'postgresql_password'
  #  function from this module, with a u/p of 'test3', 'test3'.
  password      => 'md5e12234d4575a12bfd61d61294f32b086',
  grant         => 'all',
}
