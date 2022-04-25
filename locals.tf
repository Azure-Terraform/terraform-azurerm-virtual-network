locals {
  enforce_subnet_names = (var.naming_rules == "" ? false : var.enforce_subnet_names)

  subnets = zipmap(keys(var.subnets), [for subnet in values(var.subnets) : merge(var.subnet_defaults, subnet)])

  route_table_associations = { for i, z in local.subnets : i => z.route_table_association if z.route_table_association != null }

  peers = zipmap(keys(var.peers), [for peer in values(var.peers) : merge(var.peer_defaults, peer)])

  non_inline_routes = merge(values({ for route_table, info in var.route_tables :
    route_table => { for route, data in(info.use_inline_routes ? {} : info.routes) :
      "${route_table}-${route}" => merge({ for k, v in data :
        k => v
      }, { "table" = route_table, name = route })
    }
  })...)

  aks_info = (var.aks_subnets == null ? {} : var.aks_subnets)

  aks_subnets = merge([for id in keys(local.aks_info) :
    {
      "aks-${id}" = merge({ aks_id = id }, merge(var.subnet_defaults, local.aks_info[id].subnet_info))
    }
  ]...)

  aks_route_tables = { for id, info in local.aks_info :
    id => local.aks_info[id].route_table
  }

  aks_routes = merge([for id, route_table in local.aks_route_tables :
    { for desc, info in route_table.routes :
      "${id}-${desc}" => merge({ aks_id = id, name = desc }, info)
    }
  ]...)

}