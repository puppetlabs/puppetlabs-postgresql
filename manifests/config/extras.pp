# Class: postgresql::config::extras
#
# Parameters:
#
#   [*config_restart_hash*]    - hash of postgresql config settings that require a service RESTART
#   [*config_reload_hash*]     - hash of postgresql config settings that require a service RELOAD
#   [*postgresql_conf_dir*]    - directory which contains postgresql configuration
#
# Actions:
#
# Requires:
#
# Usage:
#   This class manages configuration settings for PostgreSQL.
#   Configuration added to config_restart_hash will force PostgreSQL to be 
#   restarted. If the configuration change that needs to be made only requires
#   a PostgreSQL reload then add the change to the config_reload_hash.
#
#   class { 'postgresql::config::extras':
#     config_restart_hash => {
#       'max_connections' => 200,
#     },
#     config_reload_hash  => {
#       'log_hostname'    => 'on',
#     },
#     postgresql_conf_dir => '/var/lib/pgsql/data',
#   }
class postgresql::config::extras(
  $config_restart_hash = {},
  $config_reload_hash  = {},
  $postgresql_conf_dir,
) {
  File {
    owner   => $postgresql::params::user,
    group   => $postgresql::params::group,
    mode    => 0600,
    require => Class['Postgresql::Config::Beforeservice'],
  }

  file { "${postgresql_conf_dir}/postgresql_puppet_extras.conf":
    ensure  => file,
    content => inline_template("<% config_restart_hash.keys.sort.each do |k| -%>
<%= k %> = <%= config_restart_hash[k] %>
<% end %>"),
    notify  => Service['postgresqld'],
  }

  file { "${postgresql_conf_dir}/postgresql_puppet_extras_reload.conf":
    ensure  => file,
    content => inline_template("<% config_reload_hash.keys.sort.each do |k| -%>
<%= k %> = <%= config_reload_hash[k] %>
<% end %>"),
    notify  => Exec['reload_postgresql'],
  }

}
