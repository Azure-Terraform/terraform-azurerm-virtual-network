output "vnet" {
  description = "Virtual network details"
  value       = module.virtual_network.vnet
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = module.virtual_network.vnet.id
}

output "vnet_name" {
  description = "Virtual network name"
  value       = module.virtual_network.vnet.name
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.test.name
}
