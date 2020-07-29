locals {
  naming_rules = yamldecode(var.naming_rules)
  subnet_types = local.naming_rules.subnetType.allowed_values

  valid_subnet_type = (contains(keys(local.subnet_types), var.subnet_type) ? null : file("ERROR: invalid input value for reserved subnet type"))
}
