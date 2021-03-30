locals {
  enforce_subnet_names = (var.naming_rules == "" ? false : var.enforce_subnet_names)

  subnets = zipmap(keys(var.subnets), [ for subnet in values(var.subnets): merge(var.subnet_defaults, subnet) ])

  route_table_associations = {for i, z in local.subnets: i => z.route_table_association if z.route_table_association != null}

  peers = zipmap(keys(var.peers), [ for peer in values(var.peers): merge(var.peer_defaults, peer) ])
}
