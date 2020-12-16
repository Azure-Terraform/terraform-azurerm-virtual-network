resource "azurerm_virtual_network" "vnet" {
  name                = "${var.names.product_group}-${var.names.subscription_type}-${var.names.location}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

module "subnet" {
  source   = "./subnet"
  for_each = local.subnets

  naming_rules        = var.naming_rules
  resource_group_name = var.resource_group_name
  location            = var.location
  names               = var.names
  tags                = var.tags

  virtual_network_name = azurerm_virtual_network.vnet.name
  subnet_type          = each.key
  cidrs                = each.value.cidrs

  enforce_private_link_endpoint_network_policies = each.value.enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies  = each.value.enforce_private_link_service_network_policies

  service_endpoints = each.value.service_endpoints
  delegations       = each.value.delegations

  allow_internet_outbound = each.value.allow_internet_outbound
  allow_lb_inbound        = each.value.allow_lb_inbound
  allow_vnet_inbound      = each.value.allow_vnet_inbound
  allow_vnet_outbound     = each.value.allow_vnet_outbound
}

resource "azurerm_virtual_network_peering" "peer" {
  for_each                     = local.peers
  name                         = each.key
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = each.value.id
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

