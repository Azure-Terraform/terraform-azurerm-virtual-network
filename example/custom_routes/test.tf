data "azurerm_subnet" "subnet" {
  for_each = module.virtual_network.subnets	

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

output "foo" {
  #value = (lookup(data.azurerm_subnet.subnet["iaas-public"], "route_table_id", null) != null ? "foo" : "bar")
  #value = data.azurerm_subnet.subnet["iaas-public"].route_table_id
  value = (data.azurerm_subnet.subnet["iaas-outbound"].route_table_id == "" ? "foo" : "bar")
}
