# creating Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.virtual_network_address_prefix
}

resource "azurerm_subnet" "all_subnet" {
  count                = "${length(var.mysubnets)}"
  name                 = "${lookup(element(var.mysubnets, count.index), "name")}"
  address_prefixes     = ["${lookup(element(var.mysubnets, count.index), "ip_range")}"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# Creating NSG for all subnet
resource "azurerm_network_security_group" "all_nsg" {
  name                = var.all_nsg[count.index]
  count               = "${length(var.all_nsg)}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Adding NSG rule for frontend subnet
resource "azurerm_network_security_rule" "allow_frontend" {
  count                       = "${length(var.allow_frontend)}"
  name                        = "${lookup(element(var.allow_frontend, count.index), "name")}"
  priority                    = "${lookup(element(var.allow_frontend, count.index), "priority")}"
  direction                   = "${lookup(element(var.deny_vnet_to_vnet_frontend_backend, count.index), "direction")}"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${lookup(element(var.allow_frontend, count.index), "destination_port_range")}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.all_nsg[0]
}

# Adding NSG rules association with frontend subnet
resource "azurerm_subnet_network_security_group_association" "nsg_frontend_rule_association" {
  subnet_id                 = azurerm_subnet.all_subnet[0]
  network_security_group_id = var.all_nsg_id[0]
}


# Adding NSG rule for backend subnet
resource "azurerm_network_security_rule" "all_allow_frontend_backend" {
  count                       = "${length(var.allow_frontend_backend)}"
  name                        = "${lookup(element(var.allow_frontend_backend, count.index), "name")}"
  priority                    = "${lookup(element(var.allow_frontend_backend, count.index), "priority")}"
  direction                   = "${lookup(element(var.deny_vnet_to_vnet_frontend_backend, count.index), "direction")}"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "${lookup(element(var.allow_frontend_backend, count.index), "destination_port_range")}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.all_nsg[1]
}

resource "azurerm_network_security_rule" "all_deny_vnet_to_vnet_frontend_backend" {
  count                       = "${length(var.deny_vnet_to_vnet_frontend_backend)}"
  name                        = "${lookup(element(var.deny_vnet_to_vnet_frontend_backend, count.index), "name")}"
  priority                    = 4096
  direction                   = "${lookup(element(var.deny_vnet_to_vnet_frontend_backend, count.index), "direction")}"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.all_nsg[1]
}

# resource "azurerm_network_security_rule" "deny_internet_outbound_backend" {
#   name                        = "DenyOutboundInternetBackend"
#   priority                    = 200
#   direction                   = "Outbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "Internet"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.nsg_backend.name
# }

# Adding NSG rules association with backend subnet
resource "azurerm_subnet_network_security_group_association" "nsg_frontend_backend_rule_association" {
  subnet_id                 = azurerm_subnet.subnet_backend.id
  network_security_group_id = azurerm_network_security_group.all_nsg[1].id
}

# Adding NSG rule for database subnet
resource "azurerm_network_security_rule" "allow_database" {
  count = "${length(var.all_allow_database)}"
  name                        = "${lookup(element(var.all_allow_database, count.index), "name")}"
  priority                    = "${lookup(element(var.all_allow_database, count.index), "priority")}"
  direction                   = "${lookup(element(var.all_allow_database, count.index), "direction")}"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${lookup(element(var.all_allow_database, count.index), "source_address_prefix")}"
  destination_address_prefix  = "${lookup(element(var.all_allow_database, count.index), "destination_address_prefix")}"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.all_nsg[2]
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

resource "azurerm_network_security_rule" "allow_database_outbound" {
  name                        = "AllowOutboundBackendTraffic"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["8080", "8081", "8082", "8083"]
  source_address_prefix       = "10.1.3.0/24"
  destination_address_prefix  = "10.1.2.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_database.name
}

resource "azurerm_network_security_rule" "deny_vnet-vnet_inbound_database" {
  name                        = "DenyVnetToVnetInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_database.name
}

resource "azurerm_network_security_rule" "deny_vnet-vnet_outbound_database" {
  name                        = "DenyVnetToVnetOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_database.name
}

# # resource "azurerm_network_security_rule" "deny_internet_outbound" {
# #   name                        = "DenyOutboundInternet"
# #   priority                    = 200
# #   direction                   = "Outbound"
# #   access                      = "Deny"
# #   protocol                    = "*"
# #   source_port_range           = "*"
# #   destination_port_range      = "*"
# #   source_address_prefix       = "*"
# #   destination_address_prefix  = "Internet"
# #   resource_group_name         = var.resource_group_name
# #   network_security_group_name = azurerm_network_security_group.nsg_database.name
# # }

# # Adding NSG rules association with database subnet

# resource "azurerm_subnet_network_security_group_association" "nsg_database_rule_association" {
#   subnet_id                 = azurerm_subnet.subnet_database.id
#   network_security_group_id = azurerm_network_security_group.nsg_database.id
# }

# # NAT Gateway configuration

# # NAT public IP

# # resource "azurerm_public_ip" "nat_publicIP" {
# #   name                = "nat_publicIP"
# #   location            = var.location
# #   resource_group_name = var.resource_group_name
# #   allocation_method   = "Static"
# #   sku                 = "Standard"
# # }

# # # NAT gateway

# # resource "azurerm_nat_gateway" "nat_gatway" {
# #   name                = "nat-gateway"
# #   location            = var.location
# #   resource_group_name = var.resource_group_name
# #   sku_name            = "Standard"
# # }

# # # Associate NAT gateway with public IP

# # resource "azurerm_nat_gateway_public_ip_association" "nat_ip_association" {
# #   nat_gateway_id       = azurerm_nat_gateway.nat_gatway.id
# #   public_ip_address_id = azurerm_public_ip.nat_publicIP.id
# # }

# # # Route Table from subnet_backend to NAT gateway

# # resource "azurerm_route_table" "route_table_privatesubnet1" {
# #   name                = "route-table-privatesubnet1"
# #   resource_group_name = var.resource_group_name
# #   location            = var.location
# # }

# # # Associate route table with subnet backend

# # resource "azurerm_subnet_route_table_association" "route_association_privatesubnet1" {
# #   subnet_id      = azurerm_subnet.subnet_backend.id
# #   route_table_id = azurerm_route_table.route_table_privatesubnet1.id
# # }

# # # Adding route inside created route table for subnet_backend to NAT

# # resource "azurerm_route" "route_to_nat_privatesubnet1" {
# #   name                = "route-to-nat"
# #   resource_group_name = var.resource_group_name
# #   route_table_name    = azurerm_route_table.route_table_privatesubnet1.name

# #   address_prefix = "0.0.0.0/0"
# #   next_hop_type  = "VirtualAppliance"
# #   next_hop_in_ip_address = azurerm_public_ip.nat_publicIP.ip_address  # Assuming NAT Gateway has one IP configuration
# # }