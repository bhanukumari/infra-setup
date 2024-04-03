# 3 virtual machines added -> python 

virtual_machines = {
  vm1 = {
    vm_name               = "python-vm"
    vm_size               = "Standard_B2ms"
    admin_username        = "azureuser"
    admin_password        = "password"
    nic_name              = "vm_nic_python"
    ip_configuration_name = "ipconfig"
    image_publisher       = "Canonical"
    image_offer           = "0001-com-ubuntu-server-focal"
    image_sku             = "20_04-lts-gen2" # or the version you want
    image_version         = "latest"         # or specify a specific version if needed
    os_disk_name          = "myosdisk_python"
    os_disk_type          = "Standard_LRS"
    public_ip             = "python-publicIP"
  },
  vm2 = {
    vm_name               = "postgres-vm"
    vm_size               = "Standard_B1s"
    admin_username        = "azureuser"
    admin_password        = "password"
    nic_name              = "vm_nic_postgres"
    ip_configuration_name = "ipconfig"
    image_publisher       = "Canonical"
    image_offer           = "0001-com-ubuntu-server-focal"
    image_sku             = "20_04-lts-gen2" # or the version you want
    image_version         = "latest"         # or specify a specific version if needed
    os_disk_name          = "myosdisk_postgres"
    os_disk_type          = "Standard_LRS"
    public_ip             = "postgres_publicIP"
  },
  vm3 = {
    vm_name               = "frontend-vm"
    vm_size               = "Standard_B1s"
    admin_username        = "azureuser"
    admin_password        = "password"
    nic_name              = "vm_nic_frontend"
    ip_configuration_name = "ipconfig"
    image_publisher       = "Canonical"
    image_offer           = "0001-com-ubuntu-server-focal"
    image_sku             = "20_04-lts-gen2" # or the version you want
    image_version         = "latest"         # or specify a specific version if needed
    os_disk_name          = "myosdisk_frontend"
    os_disk_type          = "Standard_LRS"
    public_ip             = "frontend_publicIP"
  },
}