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
  name     = "rg-vnet-test-example"
  location = "East US"
}

module "virtual_network" {
  source = "../.."

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]

  names = {
    product_name        = "test"
    product_group       = "platform"
    subscription_type   = "dev"
    location            = "eastus"
    resource_group_type = "rg" # Add missing required field
  }

  tags = {
    Environment = "Test"
    Project     = "Module Testing"
    Owner       = "Platform Team"
  }

  # Test subnets with IPAM pool configuration (configuration only, no actual allocation)
  subnets = {
    test-basic = {
      cidrs               = ["10.0.1.0/24"] # Traditional CIDR allocation
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    test-ipam = {
      # Note: CIDRs still required for Azure subnet resource, even with IPAM pools
      # This is a current limitation - IPAM pool handles additional IP management
      cidrs                  = ["10.0.2.0/24"] # Base subnet CIDR
      ip_address_pool        = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-network-manager/providers/Microsoft.Network/networkManagers/nm-test/ipamPools/pool-test"
      number_of_ip_addresses = 50 # Additional IPs from IPAM pool
      allow_vnet_inbound     = true
      allow_vnet_outbound    = true
    }
  }

  # VNet-level IPAM pool configuration (configuration only)
  ip_address_pool        = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-network-manager/providers/Microsoft.Network/networkManagers/nm-test/ipamPools/pool-test"
  number_of_ip_addresses = 1000
}

# Test outputs
output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = module.virtual_network.vnet.id
}

output "subnets" {
  description = "Information about created subnets"
  value       = module.virtual_network.subnets
}

output "vnet_ipam_allocation" {
  description = "VNet IPAM allocation configuration"
  value       = module.virtual_network.vnet_ipam_allocation
}

output "subnet_ipam_allocations" {
  description = "Subnet IPAM allocation configurations"
  value       = module.virtual_network.subnet_ipam_allocations
}
