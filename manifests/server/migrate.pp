# PRIVATE CLASS: do not use directly
class postgresql::server::migrate {
  $pg_upgrade_path           = $postgresql::server::pg_upgrade_path
  $pg_ctl_path               = $postgresql::server::pg_ctl_path
  $psql_path                 = $postgresql::server::psql_path
  $new_datadir               = $postgresql::server::datadir
  $old_datadir               = pick($postgres_most_current_data_dir, $postgresql::server::datadir )
  $new_bindir                = $postgresql::server::bindir
  $old_bindir                = pick($postgres_most_current_bin_dir, $postgresql::server::bindir )
  $new_postgresql_conf_path  = $postgresql::server::postgresql_conf_path
  $user                      = $postgresql::server::user
  $group                     = $postgresql::server::group
  $old_confdir               = undef
  $old_postgresql_confpath   = undef
  $old_start_confpath        = undef

  include postgresql::server::contrib
  if ! defined(Class[postgresql::server::contrib]) {
    include postgresql::server::database
  }
  $old_version = regsubst($old_datadir, '.*/([0-9]\.[0-9])/.*', '\1', 'G')
  $new_version = $postgresql::server::_version
  $old_conf_dir = $osfamily ? {
      'Debian'  => pick($old_confdir, "/etc/postgresql/${old_version}/main" ),
      default   => pick($old_confdir, $postgres_most_current_data_dir, false ),
  }
  $old_postgresql_conf_path  = pick($old_postgresql_confpath, "${old_conf_dir}/postgresql.conf")
  $old_start_conf_path       = pick($old_start_confpath, "${old_conf_dir}/start.conf")

  # We only migrate data if we can find distinct directories for the old and
  # new version and we are using postgres versions from the postres repository
  # since these don't automaticaly migrate data like the versions from the OS
  # repos usually do.
  if ($new_datadir != $old_datadir) and ($new_bindir != $old_bindir) and ($postgresql::globals::manage_package_repo == true) and ($postgresql::server::migrate_data == true) {
    if ( $osfamily == 'Debian') {
      exec { 'postgresql_disable_startup':
        command     => "/bin/sed -i 's/^auto$/manual/g' ${old_start_conf_path}",
        refreshonly => true,
        subscribe   => Package['postgresql-server'],
        user        => $user,
        group       => $group,
        before      => Service['postgresqld'],
      }
    } else {
      exec { 'postgresql_disable_startup':
        command     => "/sbin/chkconfig ${postgres_latest_service_name} off",
        refreshonly => true,
        subscribe   => Package['postgresql-server'],
        before      => Service['postgresqld'],
      }
    }
    exec { 'postgresql_change_port':
      command     => "/bin/sed -ri \'s/(port = )([0-9]+)(.*)/echo \\1\$((\\2+1))\\3/ge\' ${old_postgresql_conf_path}",
      refreshonly => true,
      subscribe   => Package['postgresql-server'],
      user        => $user,
      group       => $group,
      before      => Service['postgresqld'],
    } ->
    exec { 'postgresql_stop_old':
      command     => "${pg_ctl_path} -D ${old_datadir} -o ' -c config_file=${old_postgresql_conf_path}' -m fast -w stop",
      refreshonly => true,
      subscribe   => Package['postgresql-server'],
      user        => $user,
      group       => $group,
      returns     => [0,1],
    } ->
    exec { 'postgresql_stop_new':
      command     => "${pg_ctl_path} -D ${new_datadir} -o ' -c config_file=${new_postgresql_conf_path}' -m fast -w stop",
      refreshonly => true,
      subscribe   => Package['postgresql-server'],
      user        => $user,
      group       => $group,
      returns     => [0,1],
    } ->
    exec { 'postgresql_migrate':
      command     => "$pg_upgrade_path -d ${old_datadir} -D ${new_datadir} -b ${old_bindir} -B ${new_bindir} -o ' -c config_file=${old_postgresql_conf_path}' -O ' -c config_file=${new_postgresql_conf_path}' ",
      refreshonly => true,
      subscribe   => Package['postgresql-server'],
      require     => Package['postgresql-contrib'],
      user        => $user,
      group       => $group,
      cwd         => '/tmp',
    } ->
    exec { 'postgresql_start_new':
      command     => "${pg_ctl_path} -D ${new_datadir} -o ' -c config_file=${new_postgresql_conf_path}' start",
      refreshonly => true,
      subscribe   => Package['postgresql-server'],
      user        => $user,
      group       => $group,
    }

    debug("Migrated data from ${old_data_path} to ${new_data_path}")
  } else {
    debug('Postgres migrations selected but we were not able to migrate anything')
  }
}
