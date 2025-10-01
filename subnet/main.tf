resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_type
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  # For IPAM pools, address_prefixes should be dynamically allocated
  # Currently, Azure provider may still require address_prefixes even with IPAM
  # This is a limitation that will be resolved when IPAM pool resources are fully supported
  address_prefixes = var.cidrs

  private_endpoint_network_policies             = var.private_endpoint_network_policies
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled


  service_endpoints = var.service_endpoints

  dynamic "delegation" {
    for_each = var.delegations
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count = (var.create_network_security_group ? 1 : 0)

  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.0.id
}

resource "azurerm_network_security_group" "nsg" {
  count = (var.create_network_security_group ? 1 : 0)

  name                = local.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, { subnet_type = lookup(local.allowed_subnet_info, var.subnet_type, var.subnet_type) })
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  count = ((var.create_network_security_group && var.configure_nsg_rules) ? 1 : 0)

  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  count = ((var.create_network_security_group && var.configure_nsg_rules) ? 1 : 0)

  name                        = "DenyAllOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_lb_inbound" {
  count = ((var.create_network_security_group && var.configure_nsg_rules && var.allow_lb_inbound) ? 1 : 0)

  name                        = "AllowAzureLoadBalancerIn"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_internet_outbound" {
  count = ((var.create_network_security_group && var.configure_nsg_rules && var.allow_internet_outbound) ? 1 : 0)

  name                        = "AllowInternetOut"
  priority                    = 4095
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  count = ((var.create_network_security_group && var.configure_nsg_rules && var.allow_vnet_inbound) ? 1 : 0)

  name                        = "AllowVnetIn"
  priority                    = 4094
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

resource "azurerm_network_security_rule" "allow_vnet_outbound" {
  count = ((var.create_network_security_group && var.configure_nsg_rules && var.allow_vnet_outbound) ? 1 : 0)

  name                        = "AllowVnetOut"
  priority                    = 4094
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.0.name
}

# IPAM Pool Static CIDR Allocation
# Note: The actual IPAM pool allocation should be handled by azurerm_network_manager_ipam_pool_static_cidr
# or similar resources when they become available in the AzureRM provider.
# For now, we're storing the configuration for future use.
locals {
  ipam_config = var.ip_address_pool != null && var.number_of_ip_addresses != null ? {
    pool_id                = var.ip_address_pool
    number_of_ip_addresses = var.number_of_ip_addresses
    subnet_name            = var.subnet_type
  } : null
}
