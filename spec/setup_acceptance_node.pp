if $facts['os']['name'] == 'Ubuntu' and $facts['os']['release']['major'] == '18.04' {
  package { 'iproute2':
    ensure => installed,
  }
}

# needed for netstat, for serverspec checks
if $facts['os']['family'] in ['SLES', 'SUSE'] {
  exec { 'Enable legacy repos':
    path    => '/bin:/usr/bin/:/sbin:/usr/sbin',
    command => 'SUSEConnect --product sle-module-legacy/15.5/x86_64',
    unless  => 'SUSEConnect --status-text | grep sle-module-legacy/15.5/x86_64',
  }

  package { 'net-tools-deprecated':
    ensure  => 'latest',
    require => Exec['Enable legacy repos'],
  }
}

if $facts['os']['family'] == 'RedHat' {
  if versioncmp($facts['os']['release']['major'], '8') >= 0 {
    $package = ['iproute', 'policycoreutils-python-utils']
  } else {
    $package = 'policycoreutils-python'
  }
  package { $package:
    ensure => installed,
  }
}
