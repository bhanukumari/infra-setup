variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The location for the resources"
}

variable "vm_name" {
  description = "The name of the virtual machine"
}

variable "vm_size" {
  description = "The size of the virtual machine"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
}

variable "nic_name" {
  description = "The name of the network interface"
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration"
}

variable "subnet_id" {
  description = "The ID of the subnet"
}

variable "image_publisher" {
  description = "The publisher of the VM image"
}

variable "image_offer" {
  description = "The offer of the VM image"
}

variable "image_sku" {
  description = "The SKU of the VM image"
}

variable "image_version" {
  description = "The version of the VM image"
}

variable "os_disk_name" {
    description = "The name of the OS disk"
}

variable "os_disk_type" {
    description = "The type of OS disk"
}