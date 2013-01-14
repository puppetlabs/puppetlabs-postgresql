class postgresql_tests::system_default::test_pgconf_include {

  $pg_conf_include_file = '/tmp/postgresql_conf_extras.conf'

  file { $pg_conf_include_file :
    content => 'port = 5433'
  } ->

  class { 'postgresql::server':
    config_hash => {
        'include' => '/tmp/postgresql_conf_extras.conf'
    }
  }

}
