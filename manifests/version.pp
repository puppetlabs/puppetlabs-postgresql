# ==Class: postgresql::version
#
#   Used by other classes in the postgresql module to
#   determine which version of Postgresql to install/configure.
#
#   Note: It must be declared before the postgresql or
#   postgresql::server classes get included.
#
# === Parameters
#
# [*version*] the version number.
#
# === Examples
#
# class { 'postgresql::version':
#   version => '9.0',
# }
#
# class { 'postgresql::server':
#   config_hash => {
#     'ip_mask_deny_postgres_user' => '0.0.0.0/32',
#     'ip_mask_allow_all_users'    => '0.0.0.0/0',
#     'listen_addresses'           => '*',
#     'manage_redhat_firewall'     => false,
#     'postgres_password'          => 'changeme',
#   },
# }
#
# === Authors
#
# Etienne Pelletier <epelletier@maestrodev.com>
#
class postgresql::version($version = $::postgres_default_version) {
}