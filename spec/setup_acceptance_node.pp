case $facts['os']['family'] {
  'SLES', 'SUSE': {
    if $facts['os']['release']['major'] == '15' {
      # CI needs netstat(1) to check listening port.  netstat is part of the
      # net-tools package which is deprecated and now a legacy module.
      exec { 'enable legacy repos':
        path =>  '/bin:/usr/bin/:/sbin:/usr/sbin',
        command =>  'SUSEConnect --product sle-module-legacy/15.4/x86_64',
        unless =>  'SUSEConnect --status-text | grep sle-module-legacy/15.4/x86_64',
      }
      package { 'net-tools':
        ensure => installed,
      }
    }
  }
}
