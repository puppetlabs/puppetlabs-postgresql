# @summary This define handles systemd drop-in files for the postgres main instance (default) or additional instances
# @param service_name Overrides the default PostgreSQL service name.
# @param drop_in_ensure sets the Systemd drop-in file to present or absent
# @api private
define postgresql::server::instance::systemd (
  Stdlib::Port $port,
  Stdlib::Absolutepath $datadir,
  String[1] $instance_name                  = $name,
  Optional[String[1]] $extra_systemd_config = undef,
  String[1] $service_name                   = $name,
  Enum[present, absent] $drop_in_ensure     = 'present',
) {
  if $facts['service_provider'] == 'systemd' {
    if $facts['os']['family'] in ['RedHat', 'Gentoo'] {
      # RHEL 7 and 8 both support drop-in files for systemd units.
      # Gentoo also supports drop-in files.
      # RHEL based Systems need Variables set for $PGPORT, $DATA_DIR or $PGDATA, thats what the drop-in file is for.
      # For additional instances (!= 'main') we need a new systemd service anyhow and use one systemd-file. no dropin needed.
      #
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
  }
}
