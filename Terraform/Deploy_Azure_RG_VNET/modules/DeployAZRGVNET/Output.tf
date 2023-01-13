output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}
output "vnet_name" {
  value = azurerm_virtual_network.cloudops_vnet.name
}
output "vnet_cidr" {
  value = azurerm_virtual_network.cloudops_vnet.address_space
}
output "publicsubnet_name" {
  value = azurerm_subnet.publicsubnet.name
}
output "publicsubnet_cidr" {
  value = azurerm_subnet.publicsubnet.address_prefixes
}
output "privatesubnet_name" {
  value = azurerm_subnet.privatesubnet.name
}
output "privatesubnet_cidr" {
  value = azurerm_subnet.privatesubnet.address_prefixes
}
