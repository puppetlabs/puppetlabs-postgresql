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
#   [*ipv4acls*]                - list of strings for access control for connection method, users, databases, IPv4
#                                    addresses; see postgresql documentation about pg_hba.conf for information
#   [*ipv6acls*]                - list of strings for access control for connection method, users, databases, IPv6
#                                    addresses; see postgresql documentation about pg_hba.conf for information
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


define postgresql::config::pg_hba_conf($ensure='present', $type, $database, $user, $address=undef, $method){
    # guid of this entry
    $key = "$type/$database/$user/$address/$method"

    # validate parameters
    if ($type == 'local' and $address) {
        fail("'local' type can't have configured address!")
    }

    if !($ensure in [present, absent]) {
        fail('ensure parameter must be "present" or "absent"')
    }

    # configure filter and changes, depending on ACL type
    if ($type == 'local'){
        $filter = "type='$type' and database='$database' and user='$user' and method='$method'"

        $changes = [
            "set 01/type $type",
            "set 01/database $database",
            "set 01/user \"$user\"",
            "set 01/method $method",
        ]
    }
    else {
        $filter = "type='$type' and database='$database' and user='$user' and address='$address' and method='$method'"

        $changes = [
            "set 01/type $type",
            "set 01/database $database",
            "set 01/user \"$user\"",
            "set 01/address $address",
            "set 01/method $method",
        ]
    }

    if $ensure == 'present'{
        augeas { $key:
          lens      => "Pg_Hba.lns",
          incl      => "$pg_hba_conf_path",
          onlyif    => "match *[$filter] size != 1",
          changes   => $changes,
        }
    }
    else {
        augeas { $key:
          lens      => "Pg_Hba.lns",
          incl      => "$pg_hba_conf_path",
          changes   => "rm *[$filter]",
        }

    }

}

define postgresql::config::postgresql_conf($value=undef){
    if ($value){
        $changes = "set .anon/$name $value"
    } else {
        $changes = "remove .anon/$name"
    }

    augeas { "postgresql_conf/$name":
        lens      => "PHP.lns",
        incl      => "$postgresql_conf_path",
        changes   => $changes,
        notify    => Service['postgresqld'],
    }

}

class postgresql::config::beforeservice(
  $pg_hba_conf_path,
  $postgresql_conf_path,
  $ip_mask_deny_postgres_user   = $postgresql::params::ip_mask_deny_postgres_user,
  $ip_mask_allow_all_users      = $postgresql::params::ip_mask_allow_all_users,
  $listen_addresses             = $postgresql::params::listen_addresses,
  $ipv4acls                     = $postgresql::params::ipv4acls,
  $ipv6acls                     = $postgresql::params::ipv6acls,
  $manage_redhat_firewall       = $postgresql::params::manage_redhat_firewall,
  $au_pg_hba_conf               = $postgresql::params::au_pg_hba_conf,
  $au_postgresql_conf           = $postgresql::params::au_postgresql_conf,
) inherits postgresql::params {


  File {
    owner  => $postgresql::params::user,
    group  => $postgresql::params::group,
  }

  if !empty($au_pg_hba_conf){
    create_resources('postgresql::config::pg_hba_conf', $au_pg_hba_conf)
  }
  else {
      # We use a templated version of pg_hba.conf.  Our main needs are to
      #  make sure that md5 authentication can be made available for
      #  remote hosts.
      file { 'pg_hba.conf':
        ensure      => file,
        path        => $pg_hba_conf_path,
        content     => template('postgresql/pg_hba.conf.erb'),
        notify      => Exec['reload_postgresql'],
      }
  }


  if ($au_postgresql_conf){
    create_resources('postgresql::config::postgresql_conf', $au_postgresql_conf)
  }
  else {
      # We must set a "listen_addresses" line in the postgresql.conf if we
      #  want to allow any connections from remote hosts.
      file_line { 'postgresql.conf':
        path        => $postgresql_conf_path,
        match       => '^listen_addresses\s*=.*$',
        line        => "listen_addresses = '${listen_addresses}'",
        notify      => Service['postgresqld'],
      }
  }

  # TODO: is this a reasonable place for this firewall stuff?
  # TODO: figure out a way to make this not platform-specific; debian and ubuntu have
  #        an out-of-the-box firewall configuration that seems trickier to manage
  # TODO: get rid of hard-coded port
  if ($manage_redhat_firewall and $firewall_supported) {
      exec { 'postgresql-persist-firewall':
        command     => $persist_firewall_command,
        refreshonly => true,
      }

      Firewall {
        notify => Exec['postgresql-persist-firewall']
      }

      firewall { '5432 accept - postgres':
        port   => '5432',
        proto  => 'tcp',
        action => 'accept',
      }
  }
}
