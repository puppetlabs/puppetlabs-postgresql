class postgresql_tests::non_default::test_install {

    class { "postgresql":
        version               => '9.2',
        manage_package_repo   => true,
        package_source        => 'yum.postgresql.org',
    } ->

    class { "postgresql::server": }
}
