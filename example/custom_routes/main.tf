terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.44.0"
    }
  }
  required_version = "=0.14.7"
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  number  = false
  special = false
}

module "subscription" {
  source = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = data.azurerm_subscription.current.subscription_id
}

module "naming" {
  source = "github.com/Azure-Terraform/example-naming-template.git?ref=v1.0.0"
}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.1.0"

  naming_rules = module.naming.yaml

  market              = "us"
  project             = "https://github.com/Azure-Terraform/terraform-azurerm-virtual-network/tree/master/example/bastion"
  location            = "eastus2"
  environment         = "sandbox"
  product_name        = random_string.random.result
  business_unit       = "infra"
  product_group       = "contoso"
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = "dev"
  resource_group_type = "app"
}

module "resource_group" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v1.0.0"

  location = module.metadata.location
  names    = module.metadata.names
  tags     = module.metadata.tags
}

module "virtual_network" {
  source = "../../"

  naming_rules = module.naming.yaml

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["10.1.0.0/22"]

  subnets = {
    "iaas-public"   = { cidrs               = ["10.1.0.0/24"]
                        allow_vnet_inbound  = true
                        allow_vnet_outbound = true
                      }
    "iaas-private"   = { cidrs              = ["10.1.1.0/24"]
                        allow_vnet_inbound  = true
                        allow_vnet_outbound = true
                      }
    "iaas-outbound"   = { cidrs = ["10.1.2.0/24"]
                        allow_vnet_inbound      = true
                        allow_vnet_outbound     = true
                        route_table_association = "default"
                      }
  }

  route_tables = {
    default = {
      disable_bgp_route_propagation = true
      routes = {
        internet = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
        }
        internal-1 = { 
          address_prefix         = "10.0.0.0/8"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "1.1.1.1"
        }
        internal-2 = {
          address_prefix         = "172.16.0.0/12"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "1.1.1.1"
        }
        internal-3 = {
          address_prefix         = "192.168.0.0/16"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "1.1.1.1"
        }
        local-vnet = {
          address_prefix         = "8.8.8.0/24"
          next_hop_type          = "vnetlocal"
        }
      }
    }
  }
}
