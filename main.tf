resource "azurerm_virtual_network" "vnet" {
  name                = "${var.names.product_group}-${var.names.subscription_type}-${var.names.location}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnets)
  name                 = "${substr(keys(var.subnets)[count.index], 3, -1)}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = values(var.subnets)[count.index]
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg" {
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.subnet.*.id[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.*.id[count.index]
}

resource "azurerm_network_security_group" "nsg" {
  count               = length(var.subnets)
  name                = "${var.names.resource_group_type}-${var.names.product_name}-${substr(keys(var.subnets)[count.index], 3, -1)}-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, {subnet_type = lookup(local.subnet_types,substr(keys(var.subnets)[count.index], 3, -1))})
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  count                       = length(var.subnets)
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
  network_security_group_name = azurerm_network_security_group.nsg.*.name[count.index]
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  count                       = length(var.subnets)
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
  network_security_group_name = azurerm_network_security_group.nsg.*.name[count.index]
}