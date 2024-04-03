# creating public IP for frontend for LB

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic" # or "Static" if you want a static public IP
  domain_name_label   = "tf-lb"
}

# creating availibility set

resource "azurerm_availability_set" "availibility-set" {
  name                = var.availability_set
  location            = var.location
  resource_group_name = var.resource_group_name
}

# creating NIC for availibility set

resource "azurerm_network_interface" "nic-availibility-set" {
  name                = var.nic_availibility-set
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating NIC for Virtual machine inside private subnet

resource "azurerm_network_interface" "vm_networkinterface" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating a virtual machine

resource "azurerm_virtual_machine" "virtual_machine" {
  name                          = var.vm_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  network_interface_ids         = [azurerm_network_interface.vm_networkinterface.id]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true
  availability_set_id           = azurerm_availability_set.availibility-set.id
  depends_on                    = [azurerm_network_interface.vm_networkinterface]

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

# Creating a Load Balancer

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Creating a Load Balancer Backend Pool

resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
  depends_on = [
    azurerm_availability_set.availibility-set,
    azurerm_lb.lb
  ]
}

# Associating NIC of VM in backend pool with backend address Pool

resource "azurerm_network_interface_backend_address_pool_association" "bp_association" {
  network_interface_id    = azurerm_network_interface.vm_networkinterface.id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_address_pool.id
}

# Health probes for Load Balancer

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "ssh-running-probe"
  port            = 22
}

# Rules for Load Balancer

resource "azurerm_lb_rule" "LBRule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule_01"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids  = [azurerm_lb_backend_address_pool.backend_address_pool.id]
  depends_on = [
    azurerm_availability_set.availibility-set,
    azurerm_lb.lb,
    azurerm_lb_probe.lb_probe
  ]
}