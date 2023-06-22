//-----------------------------------------------------------------------------
// locals.tf - locally format variables for module usage
//-----------------------------------------------------------------------------


locals {
  secrets = flatten([for k, v in var.functions : [
    for k1, v1 in try(v.secrets, {}) : {
      function = k
      secret   = v1
    }
  ]])
}
