# Class: postgresql::params
#
#   The postgresql configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::params {  
  $user                         = 'postgres'
  $group                        = 'postgres'
  $ip_mask_deny_postgres_user   = '0.0.0.0/0'
  $ip_mask_allow_all_users      = '127.0.0.1/32'
  $listen_addresses             = 'localhost'
  $ipv4acls                     = []
  $ipv6acls                     = []
  # TODO: figure out a way to make this not platform-specific
  $manage_redhat_firewall       = false

  # This is a bit hacky, but if the puppet nodes don't have pluginsync enabled,
  # they will fail with a not-so-helpful error message.  Here we are explicitly
  # verifying that the custom fact exists (which implies that pluginsync is
  # enabled and succeeded).  If not, we fail with a hint that tells the user
  # that pluginsync might not be enabled.  Ideally this would be handled directly
  # in puppet.
  if ($::postgres_default_version == undef) {
    fail "No value for postgres_default_version facter fact; it's possible that you don't have pluginsync enabled."
  }

  case $::operatingsystem {
    default: {
      $service_provider = undef
    }
  }

  case $::osfamily {
    'RedHat': {
      $needs_initdb             = true
      $firewall_supported       = true
      $persist_firewall_command = '/sbin/iptables-save > /etc/sysconfig/iptables'      
    }
    'Debian': {
      $needs_initdb             = false
      $firewall_supported       = false
      $service_status           = "/etc/init.d/${service_name} status | /bin/egrep -q 'Running clusters: .+'"
      # TODO: not exactly sure yet what the right thing to do for Debian/Ubuntu is.
      #$persist_firewall_command = '/sbin/iptables-save > /etc/iptables/rules.v4'

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
    }
  }
}
