# @summary Class for setting cross-class global overrides.
#
# @note
#   Most server-specific defaults should be overridden in the postgresql::server class.
#   This class should be used only if you are using a non-standard OS, or if you are changing elements that can only be changed here, such as version or manage_package_repo.
#
#
# @param client_package_name  Overrides the default PostgreSQL client package name.
# @param server_package_name Overrides the default PostgreSQL server package name.
# @param contrib_package_name Overrides the default PostgreSQL contrib package name.
# @param devel_package_name Overrides the default PostgreSQL devel package name.
# @param java_package_name Overrides the default PostgreSQL java package name.
# @param docs_package_name Overrides the default PostgreSQL docs package name.
# @param perl_package_name Overrides the default PostgreSQL Perl package name.
# @param plperl_package_name Overrides the default PostgreSQL PL/Perl package name.
# @param plpython_package_name Overrides the default PostgreSQL PL/Python package name.
# @param python_package_name Overrides the default PostgreSQL Python package name.
# @param postgis_package_name Overrides the default PostgreSQL PostGIS package name.
#
# @param service_name Overrides the default PostgreSQL service name.
# @param service_provider Overrides the default PostgreSQL service provider.
# @param service_status Overrides the default status check command for your PostgreSQL service.
# @param default_database Specifies the name of the default database to connect with.
#
# @param validcon_script_path Scipt path for the connection validation check.
#
# @param initdb_path Path to the initdb command.
# @param createdb_path Deprecated. Path to the createdb command.
# @param psql_path Sets the path to the psql command.
# @param pg_hba_conf_path Specifies the path to your pg_hba.conf file.
# @param pg_ident_conf_path Specifies the path to your pg_ident.conf file.
# @param postgresql_conf_path Sets the path to your postgresql.conf file.
# @param postgresql_conf_mode Sets the mode of your postgresql.conf file. Only relevant if manage_postgresql_conf_perms is true.
# @param recovery_conf_path Path to your recovery.conf file.
# @param default_connect_settings Default connection settings.
#
# @param pg_hba_conf_defaults Disables the defaults supplied with the module for pg_hba.conf if set to false.
#
# @param datadir
#    Overrides the default PostgreSQL data directory for the target platform.
#    Changing the datadir after installation causes the server to come to a full stop before making the change.
#    For Red Hat systems, the data directory must be labeled appropriately for SELinux.
#    On Ubuntu, you must explicitly set needs_initdb = true to allow Puppet to initialize the database in the new datadir (needs_initdb defaults to true on other systems).
#    Warning! If datadir is changed from the default, Puppet does not manage purging of the original data directory, which causes it to fail if the data directory is changed back to the original
#
# @param confdir Overrides the default PostgreSQL configuration directory for the target platform.
# @param bindir Overrides the default PostgreSQL binaries directory for the target platform.
# @param xlogdir Overrides the default PostgreSQL xlog directory.
# @param logdir Overrides the default PostgreSQL log directory.
# @param log_line_prefix Overrides the default PostgreSQL log prefix.
#
# @param user Overrides the default PostgreSQL super user and owner of PostgreSQL related files in the file system.
# @param group Overrides the default postgres user group to be used for related files in the file system.
#
# @param version The version of PostgreSQL to install and manage.
# @param postgis_version Defines the version of PostGIS to install, if you install PostGIS.
# @param repo_proxy Sets the proxy option for the official PostgreSQL yum-repositories only.
#
# @param repo_baseurl Sets the baseurl for the PostgreSQL repository. Useful if you host your own mirror of the repository.
# @param yum_repo_commonurl Sets the url for the PostgreSQL common Yum repository. Useful if you host your own mirror of the YUM repository.
#
# @param needs_initdb Explicitly calls the initdb operation after the server package is installed and before the PostgreSQL service is started.
#
# @param encoding
#   Sets the default encoding for all databases created with this module.
#   On certain operating systems, this is also used during the template1 initialization, so it becomes a default outside of the module as well.
# @param locale
#   Sets the default database locale for all databases created with this module.
#   On certain operating systems, this is also used during the template1 initialization, so it becomes a default outside of the module as well.
#   On Debian, you'll need to ensure that the 'locales-all' package is installed for full functionality of PostgreSQL.
# @param data_checksums
#   Use checksums on data pages to help detect corruption by the I/O system that would otherwise be silent.
#   Warning: This option is used during initialization by initdb, and cannot be changed later.
#
# @param timezone Sets the default timezone of the postgresql server. The postgresql built-in default is taking the systems timezone information.
#
# @param manage_pg_hba_conf Allow Puppet to manage the pg_hba.conf file.
# @param manage_pg_ident_conf Allow Puppet to manage the pg_ident.conf file.
# @param manage_recovery_conf Allow Puppet to manage the recovery.conf file.
# @param manage_postgresql_conf_perms
#   Whether to manage the postgresql conf file permissions. This means owner,
#   group and mode. Contents are not managed but should be managed through
#   postgresql::server::config_entry.
#
# @param manage_datadir Set to false if you have file{ $datadir: } already defined
# @param manage_logdir Set to false if you have file{ $logdir: } already defined
# @param manage_xlogdir Set to false if you have file{ $xlogdir: } already defined
#
# @param manage_package_repo Sets up official PostgreSQL repositories on your host if set to true.
# @param manage_dnf_module
#   Manage the DNF module. This only makes sense on distributions that use DNF
#   package manager, such as EL8 or Fedora. It also requires Puppet 5.5.20+ or
#   Puppet 6.15.0+ since they ship the dnfmodule provider.
# @param module_workdir Specifies working directory under which the psql command should be executed. May need to specify if '/tmp' is on volume mounted with noexec option.
#
#
class postgresql::globals (
  $client_package_name                             = undef,
  $server_package_name                             = undef,
  $contrib_package_name                            = undef,
  $devel_package_name                              = undef,
  $java_package_name                               = undef,
  $docs_package_name                               = undef,
  $perl_package_name                               = undef,
  $plperl_package_name                             = undef,
  $plpython_package_name                           = undef,
  $python_package_name                             = undef,
  $postgis_package_name                            = undef,

  $service_name                                    = undef,
  $service_provider                                = undef,
  $service_status                                  = undef,
  $default_database                                = undef,

  $validcon_script_path                            = undef,

  $initdb_path                                     = undef,
  $createdb_path                                   = undef,
  $psql_path                                       = undef,
  $pg_hba_conf_path                                = undef,
  $pg_ident_conf_path                              = undef,
  $postgresql_conf_path                            = undef,
  Optional[Stdlib::Filemode] $postgresql_conf_mode = undef,
  $recovery_conf_path                              = undef,
  $default_connect_settings                        = {},

  $pg_hba_conf_defaults                            = undef,

  $datadir                                         = undef,
  $confdir                                         = undef,
  $bindir                                          = undef,
  $xlogdir                                         = undef,
  $logdir                                          = undef,
  $log_line_prefix                                 = undef,
  $manage_datadir                                  = undef,
  $manage_logdir                                   = undef,
  $manage_xlogdir                                  = undef,

  $user                                            = undef,
  $group                                           = undef,

  $version                                         = undef,
  $postgis_version                                 = undef,
  $repo_proxy                                      = undef,
  $repo_baseurl                                    = undef,
  $yum_repo_commonurl                              = undef,

  $needs_initdb                                    = undef,

  $encoding                                        = undef,
  $locale                                          = undef,
  $data_checksums                                  = undef,
  $timezone                                        = undef,

  $manage_pg_hba_conf                              = undef,
  $manage_pg_ident_conf                            = undef,
  $manage_recovery_conf                            = undef,
  $manage_postgresql_conf_perms                    = undef,
  $manage_selinux                                  = undef,

  $manage_package_repo                             = undef,
  Boolean $manage_dnf_module                       = false,
  $module_workdir                                  = undef,
) {
  # We are determining this here, because it is needed by the package repo
  # class.
  $default_version = $facts['os']['family'] ? {
    /^(RedHat|Linux)/ => $facts['os']['name'] ? {
      'Fedora' => $facts['os']['release']['major'] ? {
        /^(34)$/       => '13',
        /^(32|33)$/    => '12',
        /^(31)$/       => '11.6',
        /^(30)$/       => '11.2',
        /^(29)$/       => '10.6',
        /^(28)$/       => '10.4',
        /^(26|27)$/    => '9.6',
        /^(24|25)$/    => '9.5',
        /^(22|23)$/    => '9.4',
        /^(21)$/       => '9.3',
        /^(18|19|20)$/ => '9.2',
        /^(17)$/       => '9.1',
        default        => undef,
      },
      'Amazon' => '9.2',
      default => $facts['os']['release']['major'] ? {
        '8'     => '10',
        '7'     => '9.2',
        '6'     => '8.4',
        '5'     => '8.1',
        default => undef,
      },
    },
    'Debian' => $facts['os']['name'] ? {
      'Debian' => $facts['os']['release']['major'] ? {
        '8'     => '9.4',
        '9'     => '9.6',
        '10'    => '11',
        '11'    => '13',
        default => undef,
      },
      'Ubuntu' => $facts['os']['release']['major'] ? {
        /^(14.04)$/ => '9.3',
        /^(14.10|15.04|15.10)$/ => '9.4',
        /^(16.04|16.10)$/ => '9.5',
        /^(17.04|17.10)$/ => '9.6',
        /^(18.04)$/ => '10',
        /^(20.04)$/ => '12',
        default => undef,
      },
      default => undef,
    },
    'Archlinux' => '9.2',
    'Gentoo' => '9.5',
    'FreeBSD' => '12',
    'OpenBSD' => $facts['os']['release']['full'] ? {
      /5\.6/ => '9.3',
      /5\.[7-9]/ => '9.4',
      /6\.[0-9]/ => '9.5',
    },
    'Suse' => $facts['os']['name'] ? {
      'SLES' => $facts['os']['release']['full'] ? {
        /11\.[0-3]/ => '91',
        /11\.4/     => '94',
        /12\.0/     => '93',
        /12\.[1-3]/ => '94',
        /12\.[4-5]/ => '10',
        /15\.[0-9]/     => '10',
        default     => '96',
      },
      'OpenSuSE' => $facts['os']['release']['full'] ? {
        /42\.[1-2]/ => '94',
        default     => '96',
      },
      default => undef,
    },
    default => undef,
  }
  $globals_version = pick($version, $default_version, 'unknown')
  if($globals_version == 'unknown') {
    fail('No preferred version defined or automatically detected.')
  }

  $default_postgis_version = $globals_version ? {
    '8.1'   => '1.3.6',
    '8.4'   => '2.0',
    '9.0'   => '2.1',
    '9.1'   => '2.1',
    '91'    => '2.1',
    '9.2'   => '2.3',
    '9.3'   => '2.3',
    '93'    => '2.3',
    '9.4'   => '2.3',
    '9.5'   => '2.3',
    '9.6'   => '2.3',
    '10'    => '2.4',
    '11'    => '3.0',
    '12'    => '3.0',
    default => undef,
  }
  $globals_postgis_version = $postgis_version ? {
    undef   => $default_postgis_version,
    default => $postgis_version,
  }

  # Setup of the repo only makes sense globally, so we are doing this here.
  if($manage_package_repo) {
    class { 'postgresql::repo':
      version   => $globals_version,
      proxy     => $repo_proxy,
      baseurl   => $repo_baseurl,
      commonurl => $yum_repo_commonurl,
    }
  }

  if $manage_dnf_module {
    class { 'postgresql::dnfmodule':
      ensure => $globals_version,
    }
  }
}
