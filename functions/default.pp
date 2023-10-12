# @summary This function pull default values from the `params` class  or `globals` class if the value is not present in `params`.
#
# @example
#   postgresql::default('variable')
#
function postgresql::default(
  String $parameter_name
) {
  include postgresql::params

  # Search for the variable name in params.
  # params inherits from globals, so it will also catch these variables.
  pick(getvar("postgresql::params::${parameter_name}"))
}
