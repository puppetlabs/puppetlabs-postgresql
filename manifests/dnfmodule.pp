# @summary Manage the DNF module
#
# On EL8 and newer and Fedora DNF can manage modules. This is a method of providing
# multiple versions on the same OS. Only one DNF module can be active at the
# same time.
#
# @api private
class postgresql::dnfmodule (
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $ensure = 'installed',
  String[1] $module = 'postgresql',
) {
  package { 'postgresql dnf module':
    ensure      => $ensure,
    name        => $module,
    enable_only => true,
    provider    => 'dnfmodule',
  }

  Package['postgresql dnf module'] -> Package<|tag == 'puppetlabs-postgresql'|>
}
