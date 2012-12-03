class postgresql_tests::non_default::test_install {

    file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-92':
        source => 'puppet:///modules/postgresql_tests/RPM-GPG-KEY-PGDG-92'
    } ->

    yumrepo { 'pgdg92':
        descr    => 'PostgreSQL 9.2 $releasever - $basearch',
        baseurl  => 'http://yum.postgresql.org/9.2/redhat/rhel-$releasever-$basearch',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-92',
    } ->

    class { "postgresql::server":
        package_name => 'postgresql92-server'
    }
}