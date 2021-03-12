locals {
  naming_rules = (var.naming_rules != "" ? yamldecode(var.naming_rules) : null)

  subnet_types = (local.naming_rules != null ? local.naming_rules.subnetType.allowed_values : null)

  valid_subnet_type = (local.naming_rules != null ? (contains(keys(local.subnet_types), var.subnet_type) ?
                       null : file("ERROR: invalid input value for reserved subnet type")) : null)
}
