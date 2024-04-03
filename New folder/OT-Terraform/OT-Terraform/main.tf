resource "azurerm_resource_group" "rg" {
  name     = "shubhamP"
  location = "East US"
}

# Module for networking

module "networking" {
  source                         = "./modules/networking"
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = azurerm_resource_group.rg.location
  virtual_network_name           = "myvnet"
  virtual_network_address_prefix = ["10.1.0.0/16"]
  public_subnet_address_prefix   = ["10.1.1.0/24"]
  subnet_backend_address_prefix  = ["10.1.2.0/24"]
  subnet_database_address_prefix = ["10.1.3.0/24"]
  nsg_frontend_name              = "nsg_frontend"
  nsg_backend_name               = "nsg_backend"
  nsg_database_name              = "nsg_database"
  public_subnet_name             = "public-subnet"
  subnet_backend_name            = "subnet_backend"
  subnet_database_name           = "subnet_database"
}

# module "virtual_machines" {
#   source                        = "./modules/virtualmachine"
#   for_each = var.virtual_machines
#   resource_group_name           = azurerm_resource_group.rg.name
#   location                      = azurerm_resource_group.rg.location
#   vm_name                       = each.value.vm_name
#   vm_size                       = each.value.vm_size
#   admin_username                = each.value.admin_username
#   admin_password                = each.value.admin_password
#   nic_name                      = each.value.nic_name
#   ip_configuration_name         = each.value.ip_configuration_name
#   subnet_id                     = each.key == "vm1" ? module.networking.subnet_backend_id : each.key == "vm2" ? module.networking.subnet_database_id : each.key == "vm3" ? module.networking.subnet_backend_id : null
#   image_publisher               = each.value.image_publisher
#   image_offer                   = each.value.image_offer
#   image_sku                     = each.value.image_sku  # or the version you want
#   image_version                 = each.value.image_version     # or specify a specific version if needed
#   os_disk_name                  = each.value.os_disk_name
#   os_disk_type                  = each.value.os_disk_type
# }

# module for load balancer to connect with backend pool

# module "loadbalancer" {
#   source                = "./modules/loadbalancer"
#   public_ip             = "frontend_publicIP"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   availability_set      = "vm_backend_availability_set"
#   nic_availibility-set  = "your_nic_card"
#   subnet_id             = module.networking.subnet_backend_id
#   vm_name               = "frontend-vm"
#   vm_size               = "Standard_B1s"
#   admin_username        = "azureuser"
#   nic_name              = "vm_nic_frontend"
#   ip_configuration_name = "ipconfig"
#   image_publisher       = "Canonical"
#   image_offer           = "0001-com-ubuntu-server-focal"
#   image_sku             = "20_04-lts-gen2" # or the version you want
#   image_version         = "latest"         # or specify a specific version if needed
#   os_disk_name          = "myosdisk_frontend"
#   os_disk_type          = "Standard_LRS"
#   lb_name               = "public_loadbalancer_name"
# }

# module for vnet-peering
module "vneet-peering" {
  source             = "./modules/vnet-peering"
  location           = ["uksouth", "southeastasia"]
  vnet_address_space = ["10.0.0.0/16", "10.1.0.0/16"]
}