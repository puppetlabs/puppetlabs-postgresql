# @summary This class installs the PL/Perl procedural language for postgresql.
# 
# @param package_ensure The ensure parameter passed on to PostgreSQL PL/Perl package resource.
# @param package_name The name of the PostgreSQL PL/Perl package.
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
