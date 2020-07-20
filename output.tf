output "vnet" {
  description  = "Virtual network resource"
  value        = azurerm_virtual_network.vnet
}

output "vnet_name" {
  description  = "Virtual network resource"
  value        = azurerm_virtual_network.vnet.name
}

output "subnet" {
  description = "Map of subnet resources"
  value       = zipmap(
    [for subnet in azurerm_subnet.subnet: subnet.name],
    [for subnet in azurerm_subnet.subnet: subnet]
  )
}

output "subnet_nsg_ids" {
  description = "Map of subnet ids to associated network_security_group ids"
  value       =  zipmap(
    [for subnet in azurerm_subnet.subnet: subnet.id],
    [for nsg in azurerm_network_security_group.nsg: nsg.id]
  )
}

output "subnet_nsg_names" {
  description = "Map of subnet names to associated network_security_group names"
  value       =  zipmap(
    [for subnet in azurerm_subnet.subnet: subnet.name],
    [for nsg in azurerm_network_security_group.nsg: nsg.name]
  )
}
