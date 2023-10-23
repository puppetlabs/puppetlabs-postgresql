postgresql_conf { '/tmp/first-postgresql.conf:other':
  value  => 'bla',
}

postgresql_conf { '/tmp/first-postgresql.conf:port':
  value  => 5432,
}

postgresql_conf { '/tmp/second-postgresql.conf:other':
  value  => 'bla',
}

postgresql_conf { '/tmp/second-postgresql.conf:port':
  value  => 5433,
}

# TODO: make target optional
#postgresql_conf { 'port':
#  value  => 5434,
#}
