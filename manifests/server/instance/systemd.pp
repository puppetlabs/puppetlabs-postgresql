# @summary This define handles systemd drop-in files for the postgres main instance (default) or additional instances
# @param service_name Overrides the default PostgreSQL service name.
# @param drop_in_ensure sets the Systemd drop-in file to present or absent
# @api private
define postgresql::server::instance::systemd (
  Variant[String[1], Stdlib::Port] $port,
  Stdlib::Absolutepath $datadir,
  Optional[String[1]] $extra_systemd_config = undef,
  String[1] $service_name                   = $name,
  Enum[present, absent] $drop_in_ensure     = 'present',

) {
  if $port =~ String {
    deprecation('postgres_port', 'Passing a string to the port parameter is deprecated. Stdlib::Port will be the enforced datatype in the next major release')
  }
  # Template uses:
  # - $port
  # - $datadir
  # - $extra_systemd_config
  systemd::dropin_file { "${service_name}.conf":
    ensure  => $drop_in_ensure,
    unit    => "${service_name}.service",
    owner   => 'root',
    group   => 'root',
    content => epp('postgresql/systemd-override.conf.epp', {
        port                 => $port,
        datadir              => $datadir,
        extra_systemd_config => $extra_systemd_config,
      }
    ),
    notify  => Class['postgresql::server::service'],
    before  => Class['postgresql::server::reload'],
  }
}
