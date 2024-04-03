variable "virtual_machines" {
  description = "A map of virtual machines with their properties"
  type = map(object({
    vm_name               = string
    vm_size               = string
    admin_username        = string
    admin_password        = string
    nic_name              = string
    ip_configuration_name = string
    image_publisher       = string
    image_offer           = string
    image_sku             = string
    image_version         = string
    os_disk_name          = string
    os_disk_type          = string
    public_ip             = string
  }))
}

# variable "public_ip" {
#   description = "The public IP for vm"
# }

variable "availability_set" {
  description = "The name of the availability set"
  default     = "myAvailabilitySet" # Replace with the actual name
}

variable "nic_aset" {
  description = "The name of the nic card"
  default     = "myNic" # Replace with the actual name
}

# variable "subnet_id" {
#   description = "The ID of the subnet"
# }

variable "vm_name" {
  description = "The name of the virtual machine"
  default     = "myVM" # Replace with the actual name
}

variable "vm_size" {
  description = "The size of the virtual machine"
  default     = "Standard_DS1_v2" # Replace with the actual size
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  default     = "admin" # Replace with the actual username
}

variable "nic_name" {
  description = "The name of the network interface"
  default     = "myNic" # Replace with the actual name
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration"
  default     = "ipConfig" # Replace with the actual name
}

variable "image_publisher" {
  description = "The publisher of the VM image"
  default     = "Canonical" # Replace with the actual publisher
}

variable "image_offer" {
  description = "The offer of the VM image"
  default     = "0001-com-ubuntu-server-focal" # Replace with the actual offer
}

variable "image_sku" {
  description = "The SKU of the VM image"
  default     = "20_04-lts-gen2" # Replace with the actual SKU
}

variable "image_version" {
  description = "The version of the VM image"
  default     = "latest" # Replace with the actual version
}

variable "os_disk_name" {
  description = "The name of the OS disk"
  default     = "myOsDisk" # Replace with the actual name
}

variable "os_disk_type" {
  description = "The type of OS disk"
  default     = "Standard_LRS" # Replace with the actual type
}

variable "lb_name" {
  description = "name of loadbalancer"
  default     = "myLoadBalancer" # Replace with the actual name
}
