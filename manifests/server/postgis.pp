# Install the postgis postgresql packaging. See README.md for more details.
class postgresql::server::postgis (
  $package_name   = $postgresql::params::postgis_package_name,
  $extension_ensure = 'present',
  $package_ensure = undef,
  $template = false,
  $template_name = 'template_postgis',
  $base_template = 'template1',
  $extensions = ['postgis', 'postgis_topology'],
) inherits postgresql::params {
  validate_string($package_name)

  if $template {
    postgresql::server::database { 'postgis template':
      dbname     => $template_name,
      istemplate => true,
      template   => $base_template,
    }
    postgresql::server::extension { $extensions:
      database       => $template_name,
      ensure         => $extension_ensure,
      package_name   => $package_name,
      package_ensure => $package_ensure,
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
