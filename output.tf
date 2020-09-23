output "vnet" {
  description  = "Virtual network data object"
  value        = azurerm_virtual_network.vnet
}

output "subnet" {
  description = "Map of subnet data objects"
  value       = zipmap(
    [for subnet in module.subnet: subnet.name],
    [for subnet in module.subnet: subnet.subnet]
  )
}

output "subnet_nsg_ids" {
  description = "Map of subnet ids to associated network_security_group ids"
  value       =  zipmap(
    [for subnet in module.subnet: subnet.id],
    [for subnet in module.subnet: subnet.nsg_id]
  )
}

output "subnet_nsg_names" {
  description = "Map of subnet names to associated network_security_group names"
  value       =  zipmap(
    [for subnet in module.subnet: subnet.name],
    [for subnet in module.subnet: subnet.nsg_name]
  )
}
