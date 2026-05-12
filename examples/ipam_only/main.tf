terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Example showing IPAM pool usage without traditional CIDRs
# This demonstrates the optional nature of CIDRs when using IPAM pools

resource "azurerm_resource_group" "example" {
  name     = "rg-ipam-only-example"
  location = "East US"
}

# Note: This requires an existing Network Manager with IPAM pool
# In a real scenario, you would reference an existing IPAM pool resource ID
locals {
  example_ipam_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network-manager/providers/Microsoft.Network/networkManagers/nm-example/ipamPools/pool-example"
}

module "virtual_network" {
  source = "../../"

  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Required naming configuration
  names = {
    environment = "dev"
    location    = "eus"
    product     = "ipam"
  }

  # VNet-level IPAM configuration
  ip_address_pool        = local.example_ipam_pool_id
  number_of_ip_addresses = 256 # /24 equivalent

  # When using IPAM pools, address_space will be dynamically allocated
  # This placeholder is required by current Azure provider limitations
  address_space = ["0.0.0.0/8"] # Placeholder - will be replaced by IPAM allocation

  subnets = {
    # Subnet using only IPAM pool (no CIDRs specified)
    web = {
      # No cidrs specified - will use IPAM pool allocation
      ip_address_pool        = local.example_ipam_pool_id
      number_of_ip_addresses = 64 # /26 equivalent
    }

    # Traditional subnet with explicit CIDRs (still supported)
    database = {
      cidrs = ["10.0.2.0/24"]
    }

    # Mixed: both CIDRs and IPAM pool can coexist
    app = {
      cidrs                  = ["10.0.3.0/24"]
      ip_address_pool        = local.example_ipam_pool_id
      number_of_ip_addresses = 32 # Additional IPAM allocation
    }
  }

  tags = {
    environment = "example"
    purpose     = "ipam-only-demo"
  }
}

output "virtual_network_id" {
  description = "The virtual network ID"
  value       = module.virtual_network.vnet.id
}

output "ipam_allocations" {
  description = "IPAM pool allocations"
  value       = module.virtual_network.vnet_ipam_allocation
}

output "subnet_ipam_allocations" {
  description = "Per-subnet IPAM allocations"
  value       = module.virtual_network.subnet_ipam_allocations
}