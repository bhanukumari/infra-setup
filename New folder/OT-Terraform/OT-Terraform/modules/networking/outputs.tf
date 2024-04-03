output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "all_subnet_id" {
  value = azurerm_subnet.all_subnet[*].id
}

output "all_nsg_id" {
  value = azurerm_network_security_group.all_nsg[*].id
}