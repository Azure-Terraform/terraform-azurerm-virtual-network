resource "azurerm_virtual_network" "vnet" {
  name                = local.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
  dns_servers         = var.dns_servers
}

module "subnet" {
  source   = "./subnet"
  for_each = local.subnets

  names               = var.names
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  security_group_perfix              = var.security_group_perfix

  naming_rules         = var.naming_rules
  enforce_subnet_names = local.enforce_subnet_names

  virtual_network_name = azurerm_virtual_network.vnet.name
  subnet_type          = each.key
  cidrs                = each.value.cidrs

  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  service_endpoints = each.value.service_endpoints
  delegations       = each.value.delegations

  create_network_security_group = each.value.create_network_security_group
  configure_nsg_rules           = each.value.configure_nsg_rules
  allow_internet_outbound       = each.value.allow_internet_outbound
  allow_lb_inbound              = each.value.allow_lb_inbound
  allow_vnet_inbound            = each.value.allow_vnet_inbound
  allow_vnet_outbound           = each.value.allow_vnet_outbound
}

resource "azurerm_route_table" "route_table" {
  for_each = var.route_tables

  name                          = "${var.resource_group_name}-${each.key}-routetable"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = each.value.bgp_route_propagation_enabled

  dynamic "route" {
    for_each = (each.value.use_inline_routes ? each.value.routes : {})
    content {
      name                   = route.key
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }

  tags = var.tags
}

resource "azurerm_route" "non_inline_route" {
  for_each = local.non_inline_routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table[each.value.table].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
}

resource "azurerm_subnet_route_table_association" "association" {
  depends_on = [module.aks_subnet, azurerm_route_table.route_table]
  for_each   = local.route_table_associations

  subnet_id      = module.subnet[each.key].id
  route_table_id = azurerm_route_table.route_table[each.value].id
}

module "aks_subnet" {
  source   = "./subnet"
  for_each = local.aks_subnets

  names               = var.names
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  enforce_subnet_names = false

  virtual_network_name = azurerm_virtual_network.vnet.name
  subnet_type          = each.key
  cidrs                = each.value.cidrs

  #private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  service_endpoints = each.value.service_endpoints
  delegations       = each.value.delegations

  create_network_security_group = false
  configure_nsg_rules           = false
}

resource "azurerm_route_table" "aks_route_table" {
  for_each = local.aks_route_tables

  lifecycle {
    ignore_changes = [tags]
  }

  name = format("%s-%s-routetable", var.resource_group_name, (startswith(each.key, "aks-") ? each.key : "aks-${each.key}"))
  # name                = "${var.resource_group_name}-aks-${each.key}-routetable"
  location            = var.location
  resource_group_name = var.resource_group_name
  #disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "aks_route" {
  for_each = local.aks_routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.aks_route_table[each.value.aks_id].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address, null)
}

resource "azurerm_subnet_route_table_association" "aks" {
  depends_on = [module.aks_subnet, azurerm_route_table.aks_route_table]
  for_each   = local.aks_subnets

  subnet_id      = module.aks_subnet[each.key].id
  route_table_id = azurerm_route_table.aks_route_table[each.value.aks_id].id
}

resource "azurerm_virtual_network_peering" "peer" {
  for_each = local.peers

  name                         = each.key
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = each.value.id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}
