# @summary This resource manages an individual rule that applies to the file defined in target.
#
# @param map_name Sets the name of the user map that is used to refer to this mapping in pg_hba.conf.
# @param system_username Specifies the operating system user name (the user name used to connect to the database).
# @param database_username Specifies the user name of the database user. The system_username is mapped to this user name.
# @param description Sets a longer description for this rule if required. This description is placed in the comments above the rule in pg_ident.conf. Default value: 'none'.
# @param order Defines an order for placing the mapping in pg_ident.conf. Default value: 150.
# @param target Provides the target for the rule and is generally an internal only property. Use with caution.
define postgresql::server::pg_ident_rule (
  $map_name,
  $system_username,
  $database_username,
  $description = 'none',
  $order       = '150',

  # Needed for testing primarily, support for multiple files is not really
  # working.
  $target      = $postgresql::server::pg_ident_conf_path
) {
  if $postgresql::server::manage_pg_ident_conf == false {
    fail('postgresql::server::manage_pg_ident_conf has been disabled, so this resource is now unused and redundant, either enable that option or remove this resource from your manifests')
  } else {
    # Create a rule fragment
    $fragname = "pg_ident_rule_${name}"
    concat::fragment { $fragname:
      target  => $target,
      content => template('postgresql/pg_ident_rule.conf'),
      order   => $order,
    }
  }
}
