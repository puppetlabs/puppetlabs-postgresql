# Same thing as postgresql_setting, but defaults target to
# the config file specified to the postgresql::params class
define postgresql::setting (
  $ensure=present,
  $name=$title,
  $value=undef,
  $target=$postgresql::params::postgresql_conf_path,
) {
  postgresql_setting { $title:
    ensure => $ensure,
    name   => $name,
    value  => $value,
    target => $target,
  }
}
