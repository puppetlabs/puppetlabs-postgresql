# Install the postgis postgresql packaging. See README.md for more details.
class postgresql::server::postgis (
  $package_name   = $postgresql::params::postgis_package_name,
  $package_ensure = 'present',
  $template = false,
  $template_name = 'template_postgis',
  $base_template = 'template1',
  $extensions = ['postgis', 'postgis_topology'],
) inherits postgresql::params {
  validate_string($package_name)

  package { 'postgresql-postgis':
    ensure => $package_ensure,
    name   => $package_name,
    tag    => 'postgresql',
  }

  if $template {
    postgresql::server::database { 'postgis template':
      dbname     => $template_name,
      istemplate => true,
      template   => $base_template,
    }
    postgresql::server::extension { $extensions:
      database => $template_name,
    }
  }

  anchor { 'postgresql::server::postgis::start': }->
  Class['postgresql::server::install']->
  Package['postgresql-postgis']->
  Class['postgresql::server::service']->
  anchor { 'postgresql::server::postgis::end': }

  if $postgresql::globals::manage_package_repo {
    Class['postgresql::repo'] ->
    Package['postgresql-postgis']
  }
}
