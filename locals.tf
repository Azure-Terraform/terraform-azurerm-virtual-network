locals {
  naming_rules = yamldecode(var.naming_rules)
  subnet_types = local.naming_rules.subnetType.allowed_values

  valid_subnet_type = [
    for subnet in keys(var.subnets):
    (contains(keys(local.subnet_types), subnet) ? null : file("ERROR: invalid input value for reserved subnet type"))
  ]

  subnets = zipmap(keys(var.subnets), [ for subnet in values(var.subnets): merge(var.subnet_defaults, subnet) ])

  route_table_associations = {for i, z in local.subnets: i => z.route_table_association if z.route_table_association != null}

  peers = zipmap(keys(var.peers), [ for peer in values(var.peers): merge(var.peer_defaults, peer) ])
}
