# This manifest shows an example of how you can use a newer version of
# postgres from yum.postgresql.org, rather than your system's
# default version.
#
# Note that it is important that you use the '->', or a
# before/require metaparameter to make sure that the `package_source_info`
# class is evaluated before any of the other classes in the module.
#
# Also note that this example includes automatic management of the yumrepo
# resource.  If you'd prefer to manage the repo yourself, simply pass 'false'
# or omit the 'manage_repo' parameter--it defaults to 'false'.  You will still
# need to use the 'package_source_info' class to specify the postgres version
# number, though, in order for the other classes to be able to find the
# correct paths to the postgres dirs.

class { "postgresql::package_source_info":
    version     => '9.2',
    source      => 'yum.postgresql.org',
    manage_repo => true,
} ->

class { "postgresql::server": }