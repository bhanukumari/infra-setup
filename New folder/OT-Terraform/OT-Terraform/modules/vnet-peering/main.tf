# Create Azure Resource group
resource "azurerm_resource_group" "vnet" {
  count = length(var.location)
  name = "rg-global-vnet-peering-${count.index}"
  location = element(var.location, count.index)
}

# Create Azure vnet per location
resource "azurerm_virtual_network" "vnet" {
  count = length(var.location)
  name = "vnet-${count.index}"
  resource_group_name = element(azurerm_resource_group.vnet.*.name, count.index)
  address_space = [element(var.vnet_address_space, count.index)]
  location = element(azurerm_resource_group.vnet.*.location, count.index)
}

# Create azure vnet subnet per subnet
resource "azurerm_subnet" "peering-subnet" {
  count = length(var.location)
  name = "peering-subnet"
  resource_group_name = element(azurerm_resource_group.vnet.*.name, count.index)
  virtual_network_name = element(azurerm_virtual_network.vnet.*.name, count.index)
  address_prefixes = [cidrsubnet(
    element(
      azurerm_virtual_network.vnet[count.index].address_space,
      count.index
    ),
    8,
    count.index
  )]
}

# Enable global peering between the two vnet
resource "azurerm_virtual_network_peering" "peering" {
  count = length(var.location)
  name = "peering-to-${element(azurerm_virtual_network.vnet.*.name, 1 - count.index)}"
  resource_group_name = element(azurerm_resource_group.vnet.*.name, count.index)
  virtual_network_name = element(azurerm_virtual_network.vnet.*.name, count.index)
  remote_virtual_network_id = element(azurerm_virtual_network.vnet.*.id, 1 - count.index)
  allow_virtual_network_access = true
  allow_forwarded_traffic = true

  # 'allow_gateway_transit' must be set to false for vnet Global Peering
  allow_gateway_transit = false
}