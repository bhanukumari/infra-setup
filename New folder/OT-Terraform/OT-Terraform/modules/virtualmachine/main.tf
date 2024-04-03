# Creating a network interface for virtual machine which contains ip configuration

resource "azurerm_network_interface" "vm_networkinterface" {
  name                      = var.nic_name
  location                  = var.location
  resource_group_name       = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_networkinterface.id]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = true
  depends_on            = [azurerm_network_interface.vm_networkinterface]
  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  storage_os_disk {
    name              = var.os_disk_name
    caching           = "ReadWrite"
    create_option     = "fromImage"
    managed_disk_type = var.os_disk_type
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "Opstree@0"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

