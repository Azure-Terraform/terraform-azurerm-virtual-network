output "id" {
  description = "subnet id"
  value       = azurerm_subnet.subnet.id
}

output "name" {
  description  = "subnet name"
  value        = azurerm_subnet.subnet.name
}

output "nsg_id" {
  description = "network security group id"
  value       = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
  description = "network security group name"
  value       = azurerm_network_security_group.nsg.name
}

output "subnet" {
  description = "subnet data object"
  value       = azurerm_subnet.subnet
}
