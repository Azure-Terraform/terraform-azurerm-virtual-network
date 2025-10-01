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

# Data sources for existing Network Manager and IPAM Pool
data "azurerm_network_manager" "existing" {
  name                = var.network_manager_name
  resource_group_name = var.network_manager_resource_group_name
}

data "azurerm_network_manager_ipam_pool" "main" {
  name               = var.ipam_pool_name
  network_manager_id = data.azurerm_network_manager.existing.id
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

module "virtual_network" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = var.address_space

  names = {
    product_name      = var.product_name
    product_group     = var.product_group
    subscription_type = var.subscription_type
    location          = var.location_short
  }

  tags = var.tags

  # VNet-level IPAM Pool allocation
  ip_address_pool        = data.azurerm_network_manager_ipam_pool.main.id
  number_of_ip_addresses = var.vnet_ip_count

  # Configure subnets with mixed IPAM pool and traditional CIDR configuration
  subnets = {
    # Subnet using IPAM pool allocation
    web = {
      cidrs                   = ["10.0.1.0/24"] # May still need CIDR for subnet creation
      ip_address_pool         = data.azurerm_network_manager_ipam_pool.main.id
      number_of_ip_addresses  = 100
      allow_internet_outbound = true
      allow_vnet_inbound      = true
      allow_vnet_outbound     = true
    }

    # Subnet using traditional CIDR only
    app = {
      cidrs               = ["10.0.2.0/24"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }

    # Another subnet with IPAM pool
    data = {
      cidrs                  = ["10.0.3.0/24"]
      ip_address_pool        = data.azurerm_network_manager_ipam_pool.main.id
      number_of_ip_addresses = 50
      allow_vnet_inbound     = true
      allow_vnet_outbound    = true
    }
  }

  # AKS subnets with IPAM pool support
  aks_subnets = var.enable_aks ? {
    aks-main = {
      subnet_info = {
        cidrs                  = ["10.0.10.0/24"]
        ip_address_pool        = data.azurerm_network_manager_ipam_pool.main.id
        number_of_ip_addresses = 200
      }
      route_table = {
        bgp_route_propagation_enabled = false
        routes = {
          default = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "Internet"
          }
        }
      }
    }
  } : null
}

# Output important information
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = module.virtual_network.vnet.id
}

output "vnet_ipam_allocation" {
  description = "VNet IPAM pool allocation information"
  value       = module.virtual_network.vnet_ipam_allocation
}

output "subnet_ipam_allocations" {
  description = "Subnet IPAM pool allocations"
  value       = module.virtual_network.subnet_ipam_allocations
}

output "aks_subnet_ipam_allocations" {
  description = "AKS subnet IPAM pool allocations"
  value       = module.virtual_network.aks_subnet_ipam_allocations
}

output "subnets" {
  description = "Information about created subnets"
  value       = module.virtual_network.subnets
}
