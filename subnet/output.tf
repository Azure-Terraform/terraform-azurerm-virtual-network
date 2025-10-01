output "id" {
  description = "subnet id"
  value       = azurerm_subnet.subnet.id
}

output "name" {
  description = "subnet name"
  value       = azurerm_subnet.subnet.name
}

output "network_security_group_id" {
  description = "network security group id"
  value       = (var.create_network_security_group ? azurerm_network_security_group.nsg.0.id : null)
}

output "network_security_group_name" {
  description = "network security group name"
  value       = (var.create_network_security_group ? azurerm_network_security_group.nsg.0.name : null)
}

output "subnet" {
  description = "subnet data object"
  value       = azurerm_subnet.subnet
}

output "ipam_allocation" {
  description = "IPAM pool allocation information for this subnet"
  value = var.ip_address_pool != null && var.number_of_ip_addresses != null ? {
    pool_id                = var.ip_address_pool
    number_of_ip_addresses = var.number_of_ip_addresses
    static_member_id       = azurerm_network_manager_static_member.subnet_ipam[0].id
  } : null
}
