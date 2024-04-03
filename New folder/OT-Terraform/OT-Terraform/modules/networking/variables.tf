variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The location of the resources"
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
}

variable "virtual_network_address_prefix" {
  description = "The address space for the virtual network"
}

variable "mysubnets" {
  type = list(object({
    ip_range = string
    name = string
  }))
  default = [
    {
      ip_range = "10.0.1.0/24"
      name = "subnet_public"
    },
    {
      ip_range = "10.0.2.0/24"
      name = "subnet_backend"
    },
    {
      ip_range = "10.0.3.0/24"
      name = "subnet_database"
    }
  ]
}

variable "all_nsg" {
  default = ["nsg_frontend", "nsg_backend", "nsg_database"]
}

variable "allow_frontend" {
  type = list(object({
    priority = number
    destination_port_range = string
    name = string
  }))
  default = [
    {
      priority = 100
      direction = "Inbound"
      destination_port_range = "22"
      name = "AllowSSHFrontend"
    },
    {
      priority = 110
      direction = "Inbound"
      destination_port_range = "80"
      name = "AllowFrontendTraffic"
    }
  ]
}

variable "all_nsg_id" {
  type = list(string)
}

variable "allow_frontend_backend" {
  type = list(object({
    name = string
    priority = number
    destination_port_range = number
    source_address_prefix = string
    destination_address_prefix = string
  }))
  default = [ 
    {
      name = "AllowSSHFrontendBackend"
      priority = 100
      direction = "Inbound"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "AllowBackendTraffic"
      priority = 110
      direction = "Inbound"
      destination_port_ranges = ["8080", "8081", "8082", "8083"]
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "AllowDatabaseTraffic"
      priority = 130
      direction = "Inbound"
      destination_port_ranges = ["6379", "5432", "9042"]
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "AllowOutboundBackend"
      priority = 100
      direction = "Outbound"
      destination_port_ranges = ["6379", "5432", "9042"]
      source_address_prefix = "10.1.2.0/24"
      destination_address_prefix  = "10.1.3.0/24"
    }
  ]
}

variable "deny_vnet_to_vnet_frontend_backend" {
  type = list(object({
    name = "DenyVnetToVnetInboundBackend"
    direction = "Inbound"
  },{
    name = "DenyVnetToVnetOutboundBackend"
    direction = "Outbound"
  }))
}

variable "all_allow_database" {
  type = list(object({
    name = string
    priority = number
    direction = string
    destination_port_ranges = number
    source_address_prefix = string
    destination_address_prefix  = string
  }))
  default = [ 
    {
      name = "AllowSSHDatabase"
      priority = 100
      direction = "Inbound"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "AllowDatabaseInboundTraffic"
      priority = 110
      direction = "Inbound"
      source_address_prefix = "10.1.2.0/24"
      destination_address_prefix = "10.1.3.0/24"
    }
  ]
}