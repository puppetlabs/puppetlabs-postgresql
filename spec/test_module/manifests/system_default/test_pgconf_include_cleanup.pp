class postgresql_tests::system_default::test_pgconf_include_cleanup {

  require postgresql::params

  $pg_conf_include_file = "${postgresql::params::confdir}/postgresql_conf_extras.conf"

  file { $pg_conf_include_file :
    ensure => absent
  }

}
