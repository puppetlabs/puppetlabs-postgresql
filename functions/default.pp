function postgresql::default(
  String $parameter_name
){
  include postgresql::params

  #search for the variable name in params first
  #then fall back to globals if not found
  getvar("postgresql::params::${parameter_name}",
    "postgresql::globals::${parameter_name}")
}
