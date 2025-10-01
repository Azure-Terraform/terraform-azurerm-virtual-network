terraform {
  required_version = ">= 0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-vnet-basic-example"
  location = "East US"
}

module "virtual_network" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]

  names = {
    product_name        = "basic"
    product_group       = "networking"
    subscription_type   = "dev"
    location            = "eastus"
    resource_group_type = "rg" # Add missing required field
  }

  tags = {
    Environment = "Development"
    Project     = "Basic VNet Example"
    Owner       = "Platform Team"
  }

  # Basic subnet configuration
  subnets = {
    web = {
      cidrs                   = ["10.0.1.0/24"]
      allow_internet_outbound = true
      allow_vnet_inbound      = true
      allow_vnet_outbound     = true
    }
    app = {
      cidrs               = ["10.0.2.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    data = {
      cidrs               = ["10.0.3.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
  }

  # Route table example
  route_tables = {
    web = {
      bgp_route_propagation_enabled = false
      use_inline_routes             = true
      routes = {
        default = {
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      }
    }
  }

  # Subnet defaults override
  subnet_defaults = {
    cidrs                                         = []
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = []
    delegations                                   = {}
    create_network_security_group                 = true
    security_group_prefix                         = null
    configure_nsg_rules                           = true
    allow_internet_outbound                       = false
    allow_lb_inbound                              = false
    allow_vnet_inbound                            = false
    allow_vnet_outbound                           = false
    route_table_association                       = "web" # Associate web subnet with web route table
    ip_address_pool                               = null
    number_of_ip_addresses                        = null
  }
}

# Outputs
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = module.virtual_network.vnet.id
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.virtual_network.vnet.name
}

output "subnets" {
  description = "Information about created subnets"
  value       = module.virtual_network.subnets
}

output "route_tables" {
  description = "Information about route tables"
  value       = module.virtual_network.route_tables
}

output "vnet_ipam_allocation" {
  description = "VNet IPAM allocation (should be null)"
  value       = module.virtual_network.vnet_ipam_allocation
}

output "subnet_ipam_allocations" {
  description = "Subnet IPAM allocations (should be empty)"
  value       = module.virtual_network.subnet_ipam_allocations
}