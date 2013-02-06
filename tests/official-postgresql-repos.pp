# This manifest shows an example of how you can use a newer version of
# postgres from yum.postgresql.org or apt.postgresql.org, rather than your
# system's default version.
#
# Note that it is important that you use the '->', or a
# before/require metaparameter to make sure that the `params`
# class is evaluated before any of the other classes in the module.
#
# Also note that this example includes automatic management of the yumrepo or 
# apt resource.  If you'd prefer to manage the repo yourself, simply pass
# 'false' or omit the 'manage_repo' parameter--it defaults to 'false'.  You will
# still need to use the 'postgresql' class to specify the postgres version
# number, though, in order for the other classes to be able to find the
# correct paths to the postgres dirs.
class { 'postgresql':
    version               => '9.2',
    manage_package_repo   => true,
}->
class { 'postgresql::server': }
