# @summary This function pull default values
# from the params or globals classes as
# appropriate
#
# This function pull default values
# from the params or globals classes as
# appropriate
#
# @example
#   postgresql::default('variable')

function postgresql::default(
  String $parameter_name
){
  include postgresql::params

  #search for the variable name in params first
  #then fall back to globals if not found
  pick( getvar("postgresql::params::${parameter_name}"),
    "postgresql::globals::${parameter_name}")
}
