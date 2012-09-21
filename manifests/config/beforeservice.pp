# Class: postgresql::config::beforeservice
#
# Parameters:
#
#   [*ip_mask_deny_postgres_user*]   - ip mask for denying remote access for postgres user; defaults to '0.0.0.0/0',
#                                       meaning that all TCP access for postgres user is denied.
#   [*ip_mask_allow_all_users*]      - ip mask for allowing remote access for other users (besides postgres);
#                                       defaults to '127.0.0.1/32', meaning only allow connections from localhost
#   [*listen_addresses*]        - what IP address(es) to listen on; comma-separated list of addresses; defaults to
#                                    'localhost', '*' = all
#   [*pg_hba_conf_path*]        - path to pg_hba.conf file
#   [*postgresql_conf_path*]    - path to postgresql.conf file
#   [*manage_redhat_firewall*]  - boolean indicating whether or not the module should open a port in the firewall on
#                                    redhat-based systems; this parameter is likely to change in future versions.  Possible
#                                    changes include support for non-RedHat systems and finer-grained control over the
#                                    firewall rule (currently, it simply opens up the postgres port to all TCP connections).
#
# Actions:
#
# Requires:
#
# Usage:
#   This class is not intended to be used directly; it is
#   managed by postgresl::config.  It contains resources
#   that should be handled *before* the postgres service
#   has been started up.
#
#   class { 'postgresql::config::before_service':
#     ip_mask_allow_all_users    => '0.0.0.0/0',
#   }
#
class postgresql::config::beforeservice(
  $ip_mask_deny_postgres_user   = $postgresql::params::ip_mask_deny_postgres_user,
  $ip_mask_allow_all_users      = $postgresql::params::ip_mask_allow_all_users,
  $listen_addresses             = $postgresql::params::listen_addresses,
  $pg_hba_conf_path             = $postgresql::params::pg_hba_conf_path,
  $postgresql_conf_path         = $postgresql::params::postgresql_conf_path,
  $manage_redhat_firewall       = $postgresql::params::manage_redhat_firewall
) inherits postgresql::params {

  File {
    owner  => $postgresql::params::user,
    group  => $postgresql::params::group,
  }

  # We use a templated version of pg_hba.conf.  Our main needs are to
  #  make sure that md5 authentication can be made available for
  #  remote hosts.
  file { 'pg_hba.conf':
    ensure      => file,
    path        => $pg_hba_conf_path,
    content     => template("postgresql/pg_hba.conf.erb"),
    notify      => Service['postgresqld'],
  }

  # We must set a "listen_addresses" line in the postgresql.conf if we
  #  want to allow any connections from remote hosts.
  file_line { 'postgresql.conf':
    path        => $postgresql_conf_path,
    match       => '^listen_addresses\s*=.*$',
    line        => "listen_addresses = '${listen_addresses}'",
    notify      => Service['postgresqld'],
  }

  # TODO: is this a reasonable place for this firewall stuff?
  # TODO: figure out a way to make this not platform-specific; debian and ubuntu have
  #        an out-of-the-box firewall configuration that seems trickier to manage
  # TODO: get rid of hard-coded port
  if ($manage_redhat_firewall and $firewall_supported) {
      exec { "postgresql-persist-firewall":
        command => $persist_firewall_command,
        refreshonly => true,
      }

      Firewall {
        notify => Exec["postgresql-persist-firewall"]
      }

      firewall { '5432 accept - postgres':
        port => '5432',
        proto => 'tcp',
        action => 'accept',
      }
  }
}
