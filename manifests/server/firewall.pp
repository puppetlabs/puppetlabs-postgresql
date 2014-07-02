# PRIVATE CLASS: do not use directly
class postgresql::server::firewall {
  $manage_firewall    = $postgresql::server::manage_firewall
  $firewall_supported = $postgresql::server::firewall_supported
  $port               = $postgresql::server::port

  if ($manage_firewall and $firewall_supported) {
    firewall { "${port} accept - postgres":
      port   => $port,
      proto  => 'tcp',
      action => 'accept',
    }
  }
}
