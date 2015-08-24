# PRIVATE CLASS: do not call directly
class postgresql::server::initdb {
  $needs_initdb          = $postgresql::server::needs_initdb
  $initdb_path           = $postgresql::server::initdb_path
  $datadir               = $postgresql::server::datadir
  $xlogdir               = $postgresql::server::xlogdir
  $logdir                = $postgresql::server::logdir
  $encoding              = $postgresql::server::encoding
  $locale                = $postgresql::server::locale
  $group                 = $postgresql::server::group
  $user                  = $postgresql::server::user
  $psql_path             = $postgresql::server::psql_path
  $pg_ctl_path           = $postgresql::server::pg_ctl_path
  $port                  = $postgresql::server::port
  $version               = $postgresql::server::_version
  $bindir                = $postgresql::server::bindir
  $postgresql_conf_path  = $postgresql::server::postgresql_conf_path

  # Set the defaults for the postgresql_psql resource
  Postgresql_psql {
    psql_user  => $user,
    psql_group => $group,
    psql_path  => $psql_path,
    port       => $port,
  }

  # Make sure the data directory exists, and has the correct permissions.
  file { $datadir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }

  if($xlogdir) {
    # Make sure the xlog directory exists, and has the correct permissions.
    file { $xlogdir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0700',
    }
  }

  if($logdir) {
    # Make sure the log directory exists, and has the correct permissions.
    file { $logdir:
      ensure => directory,
      owner  => $user,
      group  => $group,
    }
  }

  if $locale != undef {
    # [workaround]
    # by default pg_createcluster encoding/locale derived from locale
    # but it do does not work by installing postgresql via puppet because puppet
    # always override LANG to 'C'
    # See:  https://projects.puppetlabs.com/issues/4695
    # We only drop the cluster if no databases have been created and if ctype
    # on template 0 does not match specified locale
    # Port numbers need to be dynamically detected in case of multple versions
    # running at the same time and listening to different ports, especially
    # during migrations
    if $osfamily == 'Debian' {
      exec { 'postgresql_drop_cluster':
        command     => "pg_dropcluster --stop ${version} main",
        unless      => "${psql_path} -qt -p $(grep '^port = ' ${postgresql_conf_path} | awk -F= '{print \$2}' | awk -F\\# '{print \$1}' | tr -d '[[:space:]]') -c '\\l' | grep template0 | awk -F\\| '{ print \$4 }' | tr -d '[[:space:]]' | grep -q '${postgres_cluster_locale_ctype}' > /dev/null",
        onlyif      => "test \"$(${psql_path} -qt -p $(grep '^port = ' ${postgresql_conf_path} | awk -F= '{print \$2}' | awk -F\\# '{print \$1}' | tr -d '[[:space:]]') -c '\\l' | grep -v '^\\s*|' | grep -v '^\\w*$' | wc -l)\" = 3",
        user        => $user,
        group       => $group,
        path        => [$bindir, "/bin", "/sbin", "/usr/bin", "/usr/sbin"],
        before      => Exec['postgresql_initdb'],
      }
      $force_initdb = true
    } else {
      exec { 'postgresql_drop_cluster':
        command     => "rm -Rf ${datadir}",
        unless      => "${psql_path} -qt -p $(grep '^port = ' ${postgresql_conf_path} | awk -F= '{print \$2}' | awk -F\\# '{print \$1}' | tr -d '[[:space:]]') -c '\\l' | grep template0 | awk -F\\| '{ print \$4 }' | tr -d '[[:space:]]' | grep -q '${postgres_cluster_locale_ctype}'",
        onlyif      => [ "test \"$(${psql_path} -qt -p $(grep '^port = ' ${postgresql_conf_path} | awk -F= '{print \$2}' | awk -F\\# '{print \$1}' | tr -d '[[:space:]]') -c '\\l' | grep -v '^\\s*|' | grep -v '^\\w*$' | wc -l)\" = 3",
                         "${pg_ctl_path} -D ${datadir} -o ' -c config_file=${postgresql_conf_path}' -m fast -w stop"
                       ],
        user        => $user,
        group       => $group,
        path        => [$bindir, "/bin", "/sbin", "/usr/bin", "/usr/sbin"],
        subscribe   => Package['postgresql-server'],
        refreshonly => true,
        before      => Exec['postgresql_initdb'],
      }
      $force_initdb = true
    }
  } else {
    $force_initdb = false
  }

  if($needs_initdb) or ($force_initdb) {
    # Build up the initdb command.
    #
    # We optionally add the locale switch if specified. Older versions of the
    # initdb command don't accept this switch. So if the user didn't pass the
    # parameter, lets not pass the switch at all.
    $ic_base = "${initdb_path} --encoding '${encoding}' --pgdata '${datadir}'"
    $pg_base = "pg_createcluster --start -e '${encoding}' -d '${datadir}'"
    $ic_xlog = $xlogdir ? {
      undef   => $ic_base,
      default => "${ic_base} --xlogdir '${xlogdir}'"
    }

    # The xlogdir need to be present before initdb runs.
    # If xlogdir is default it's created by package installer
    if($xlogdir) {
      $require_before_initdb = [$datadir, $xlogdir]
    } else {
      $require_before_initdb = [$datadir]
    }

    $initdb_command = $locale ? {
      undef   => $ic_xlog,
      default => "${ic_xlog} --locale '${locale}'"
    }

    $pg_locale = $locale ? {
      undef   => $pg_base,
      default => "${pg_base} --locale '${locale}'"
    }

    $pg_clustercreate_command = $xlogdir ? {
      undef   => "$pg_locale ${version} main",
      default => "${pg_locale} ${version} main -- --xlogdir '${xlogdir}'"
    }

    # The package will take care of this for us the first time, but if we
    # ever need to init a new db we need to copy these files explicitly
    if $::operatingsystem == 'Debian' or $::operatingsystem == 'Ubuntu' {
      # This runs the pg_createcluster command, we use the existance of the PG_VERSION
      # file to ensure we don't keep running this command. Debian is special :)
      exec { 'postgresql_initdb':
        command   => $pg_clustercreate_command,
        creates   => "${datadir}/PG_VERSION",
        user      => $user,
        group     => $group,
        logoutput => on_failure,
        path      => [$bindir, "/bin", "/sbin", "/usr/bin", "/usr/sbin"],
        require   => File[$require_before_initdb],
      }

      if $::operatingsystemrelease =~ /^6/ or $::operatingsystemrelease =~ /^7/ or $::operatingsystemrelease =~ /^10\.04/ or $::operatingsystemrelease =~ /^12\.04/ {
        file { 'server.crt':
          ensure  => file,
          path    => "${datadir}/server.crt",
          source  => 'file:///etc/ssl/certs/ssl-cert-snakeoil.pem',
          owner   => $::postgresql::server::user,
          group   => $::postgresql::server::group,
          mode    => '0644',
          require => Exec['postgresql_initdb'],
        }
        file { 'server.key':
          ensure  => file,
          path    => "${datadir}/server.key",
          source  => 'file:///etc/ssl/private/ssl-cert-snakeoil.key',
          owner   => $::postgresql::server::user,
          group   => $::postgresql::server::group,
          mode    => '0600',
          require => Exec['postgresql_initdb'],
        }
      }
    } else {
      # This runs the initdb command, we use the existance of the PG_VERSION
      # file to ensure we don't keep running this command.
      exec { 'postgresql_initdb':
        command   => $initdb_command,
        creates   => "${datadir}/PG_VERSION",
        user      => $user,
        group     => $group,
        logoutput => on_failure,
        require   => File[$require_before_initdb],
      }
    }
  } elsif $encoding != undef {
    # [workaround]
    # by default pg_createcluster encoding/locale derived from locale
    # but it do does not work by installing postgresql via puppet because puppet
    # always override LANG to 'C'
    # See:  https://projects.puppetlabs.com/issues/4695

    postgresql_psql { "Set template1 encoding to ${encoding}":
      command => "UPDATE pg_database
        SET datistemplate = FALSE
        WHERE datname = 'template1'
        ;
        UPDATE pg_database
        SET encoding = pg_char_to_encoding('${encoding}'), datistemplate = TRUE
        WHERE datname = 'template1'",
      unless  => "SELECT datname FROM pg_database WHERE
        datname = 'template1' AND encoding = pg_char_to_encoding('${encoding}')",
    }
  }
}
