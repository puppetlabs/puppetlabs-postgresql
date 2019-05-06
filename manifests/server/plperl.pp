# @summary This class installs the PL/Perl procedural language for postgresql.
# 
# @param package_ensure
# @param package_name
#
class postgresql::server::plperl(
  $package_ensure = 'present',
  $package_name   = $postgresql::server::plperl_package_name
) {
  package { 'postgresql-plperl':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'puppetlabs-postgresql',
  }

  anchor { 'postgresql::server::plperl::start': }
  -> Class['postgresql::server::install']
  -> Package['postgresql-plperl']
  -> Class['postgresql::server::service']
  anchor { 'postgresql::server::plperl::end': }

}
