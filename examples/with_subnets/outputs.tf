output "vnet" {
  description = "Virtual network details"
  value       = module.virtual_network.vnet
}

output "subnets" {
  description = "Subnet details"
  value       = module.virtual_network.subnets
}

output "subnet_nsg_ids" {
  description = "Subnet NSG IDs"
  value       = module.virtual_network.subnet_nsg_ids
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.test.name
}
