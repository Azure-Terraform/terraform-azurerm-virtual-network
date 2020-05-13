data "http" "naming_rules" {
  url = var.naming_conventions_yaml_url

  request_headers = {
    Accept = "application/yaml"
  }
}

locals {
  naming_rules = yamldecode(data.http.naming_rules.body)
  subnet_types = local.naming_rules.subnetType.allowed_values

  valid_subnet_input = [
    for subnet in keys(var.subnets):
      can(regex("^[0-9][0-9]-", subnet)) ? null : file("ERROR: var.subnets keys must begin with '[0-9][0-9]-'")
  ]

  valid_subnet_type = [
    for subnet in keys(var.subnets):
    (contains(keys(local.subnet_types), substr(subnet, 3, -1)) ? null : file("ERROR: invalid input value for reserved subnet type"))
  ]
}