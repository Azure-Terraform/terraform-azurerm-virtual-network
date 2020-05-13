data "http" "naming_rules" {
  url = var.naming_conventions_yaml_url

  request_headers = {
    Accept = "application/yaml"
  }
}

locals {
  naming_rules = yamldecode(data.http.naming_rules.body)
  subnet_types = local.naming_rules.subnetType.allowed_values

  valid_subnet_type = (contains(keys(local.subnet_types), var.subnet_type) ? null : file("ERROR: invalid input value for reserved subnet type"))
}