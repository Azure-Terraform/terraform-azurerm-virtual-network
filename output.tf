output "vnet" {
  description  = "Virtual network resource"
  value        = azurerm_virtual_network.vnet
}

output "subnet" {
  description = "Map of subnet resources"
  value       = var.enable_nsg && length(var.subnets) < 0 ? zipmap(
    [for subnet in azurerm_subnet.subnet: subnet.name],
    [for subnet in azurerm_subnet.subnet: subnet]
  ): null
}

output "subnet_nsg_ids" {
  description = "Map of subnet ids to associated network_security_group ids"
  value       =  var.enable_nsg && length(var.subnets) > 0 ? zipmap(
    [for subnet in azurerm_subnet.subnet: subnet.id],
    [for nsg in azurerm_network_security_group.nsg: nsg.id]
  ): null
}

output "subnet_nsg_names" {
  description = "Map of subnet names to associated network_security_group names"
  value       =  var.enable_nsg && length(var.subnets) > 0 ? zipmap(
    [for subnet in azurerm_subnet.subnet: subnet.name],
    [for nsg in azurerm_network_security_group.nsg: nsg.name]
  ): null
}

