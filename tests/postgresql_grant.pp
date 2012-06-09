# TODO: in mysql module, the grant resource name might look like this: 'user@host/dbname';
#  I think that the API for the resource type should split these up, because it's
#  easier / safer to recombine them for mysql than it is to parse them for other
#  databases.  Also, in the mysql module, the hostname portion of that string
#  affects the user's ability to connect from remote hosts.  In postgres this is
#  managed via pg_hba.conf; not sure if we want to try to reconcile that difference
#  in the modules or not.
postgresql::database_grant{'test1':
    # TODO: mysql supports an array of privileges here.  We should do that if we
    #  port this to ruby.
    privilege   => 'ALL',
    db          => 'test1',
    role        => 'dan',
}
