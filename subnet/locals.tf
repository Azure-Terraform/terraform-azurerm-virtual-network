locals {
  naming_rules = (var.naming_rules != "" ? yamldecode(var.naming_rules) : null)

  network_security_group_name = (var.network_security_group_name != null ? var.network_security_group_name : "${var.names.resource_group_type}-${var.names.product_name}-${var.subnet_type}-security-group")

  allowed_subnet_info = (local.naming_rules != null ? local.naming_rules.subnetType.allowed_values : {})

  valid_subnet_type = (var.enforce_subnet_names ? (contains(keys(local.allowed_subnet_info), var.subnet_type) ?
  null : file("ERROR: invalid input value for reserved subnet type")) : null)
}
