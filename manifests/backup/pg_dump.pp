# @summary
#   "Provider" for pg_dump backup
#
# @api private
#
# @param compress
#   Whether or not to compress the backup. Support for compression also depends on other backup parameters.
# @param databases
#   Databases to backup. By default `[]` will back up all databases.
# @param db_user
#   PostgreSQL user to create with superuser privileges.
# @param db_password
#   Password to create for `$db_user`.
# @param dir
#   Directory to store backup.
# @param dir_mode
#   Permissions applied to the backup directory. This parameter is passed directly to the file resource.
# @param dir_owner
#   Owner for the backup directory. This parameter is passed directly to the file resource.
# @param dir_group
#   Group owner for the backup directory. This parameter is passed directly to the file resource.
# @param format
#   Backup format to use, must be supported by pg_dump or pg_dumpall. The choice will affect other options, i.e. compression.
# @param install_cron
#   Manage installation of cron package.
# @param manage_user
#   Manage creation of the backup user.
# @param optional_args
#   Specifies an array of optional arguments which should be passed through to the backup tool. These options are not validated,
#   unsupported options may break the backup.
# @param post_script
#   One or more scripts that are executed when the backup is finished. This could be used to sync the backup to a central store.
# @param pre_script
#   One or more scripts that are executed before the backup begins.
# @param rotate
#   Backup rotation interval in 24 hour periods.
# @param success_file_path
#   Specify a path where upon successful backup a file should be created for checking purposes.
# @param time
#   An array of two elements to set the backup time. Allows `['23', '5']` (i.e., 23:05) or `['3', '45']` (i.e., 03:45) for HH:MM times.
# @param weekday
#   Weekdays on which the backup job should run. Defaults to `*`. This parameter is passed directly to the cron resource.
class postgresql::backup::pg_dump (
  String[1]                                    $dir,
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $ensure = 'present',
  Boolean                                      $compress           = true,
  Array                                        $databases          = [],
  Boolean                                      $delete_before_dump = false,
  String[1]                                    $dir_group          = '0',
  String[1]                                    $dir_mode           = '0700',
  String[1]                                    $dir_owner          = 'root',
  Enum['plain','custom','directory','tar']     $format             = 'plain',
  Boolean                                      $install_cron       = true,
  Boolean                                      $manage_user        = false,
  Array                                        $optional_args      = [],
  Stdlib::Absolutepath                         $pgpass_path        = '/root/.pgpass',
  Integer                                      $rotate             = 30,
  Stdlib::Absolutepath                         $script_path        = '/usr/local/sbin/pg_dump.sh',
  Stdlib::Absolutepath                         $success_file_path  = '/tmp/pgbackup_success',
  String[1]                                    $template           = 'postgresql/pg_dump.sh.epp',
  Array                                        $time               = ['23', '5'],
  String[1]                                    $weekday            = '*',
  Optional[Variant[String, Sensitive[String]]] $db_password        = undef,
  Optional[String[1]]                          $db_user            = undef,
  Optional[String[1]]                          $package_name       = undef,
  Optional[String[1]]                          $post_script        = undef,
  Optional[String[1]]                          $pre_script         = undef,
) {
  # Install required packages
  if $package_name {
    stdlib::ensure_packages($package_name)
  }
  if $install_cron {
    if $facts['os']['family'] == 'RedHat' {
      stdlib::ensure_packages('cronie')
    } elsif $facts['os']['family'] != 'FreeBSD' {
      stdlib::ensure_packages('cron')
    }
  }

  # Setup db user with required permissions
  if $manage_user and $db_user and $db_password {
    # Create user with superuser privileges
    postgresql::server::role { $db_user:
      ensure        => $ensure,
      password_hash => postgresql::postgresql_password($db_user, $db_password, true, pick($postgresql::server::password_encryption, 'md5')),
      superuser     => true,
    }

    # Allow authentication from localhost
    postgresql::server::pg_hba_rule { 'local access as backup user':
      type        => 'local',
      database    => 'all',
      user        => $db_user,
      auth_method => pick($postgresql::server::password_encryption, 'md5'),
      order       => 1,
    }
  }

  # Create backup directory
  file { $dir:
    ensure => 'directory',
    mode   => $dir_mode,
    owner  => $dir_owner,
    group  => $dir_group,
  }

  # Create backup script
  file { $script_path:
    ensure  => $ensure,
    mode    => '0700',
    owner   => 'root',
    group   => '0', # Use GID for compat with Linux and BSD.
    content => epp($template, {
        compress           => $compress,
        databases          => $databases,
        db_user            => $db_user,
        delete_before_dump => $delete_before_dump,
        dir                => $dir,
        format             => $format,
        optional_args      => $optional_args,
        post_script        => $post_script,
        pre_script         => $pre_script,
        rotate             => $rotate,
        success_file_path  => $success_file_path,
      }
    ),
  }

  # Create password file for pg_dump
  file { $pgpass_path:
    ensure    => $ensure,
    mode      => '0600',
    owner     => 'root',
    group     => '0', # Use GID for compat with Linux and BSD.
    content   => inline_epp ( '*:*:*:<%= $db_user %>:<%= $db_password %>', {
        db_password => $db_password,
        db_user     => $db_user,
      }
    ),
    show_diff => false,
  }

  # Create cron job
  cron { 'pg_dump backup job':
    ensure  => $ensure,
    command => $script_path,
    user    => 'root',
    hour    => $time[0],
    minute  => $time[1],
    weekday => $weekday,
  }
}
