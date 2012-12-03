class postgresql_tests::non_default::test_install {

    class { "postgresql::package_source_info":
        version     => '9.2',
        source      => 'yum.postgresql.org',
        manage_repo => true,
    } ->

    class { "postgresql::server": }
}