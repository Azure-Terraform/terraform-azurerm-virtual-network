locals {
  enforce_subnet_names = (var.naming_rules == "" ? false : var.enforce_subnet_names)

  subnets = zipmap(keys(var.subnets), [ for subnet in values(var.subnets): merge(var.subnet_defaults, subnet) ])

  route_table_associations = {for i, z in local.subnets: i => z.route_table_association if z.route_table_association != null}

  aks_subnets = var.aks_subnets == null ? {} : { private = var.aks_subnets.private, public = var.aks_subnets.public }

  peers = zipmap(keys(var.peers), [ for peer in values(var.peers): merge(var.peer_defaults, peer) ])

  non_inline_routes = merge(values({ for route_table,info in var.route_tables:
    route_table => { for route,data in (info.use_inline_routes ? {} : info.routes):
      "${route_table}-${route}" => merge({ for k,v in data:
         k => v
      }, {"table" = route_table, name = route})
    }
  })...)
}
