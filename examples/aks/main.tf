terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
  }
  required_version = "~> 1.5"
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
  source          = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = data.azurerm_subscription.current.subscription_id
}

module "naming" {
  source = "github.com/Azure-Terraform/example-naming-template.git?ref=v1.0.0"
}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.5.0"

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
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v2.0.0"

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

  address_space        = ["10.1.0.0/21"]
  enforce_subnet_names = false

  subnets = {
    iaas-public = { cidrs = ["10.1.0.0/25"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    iaas-private = { cidrs = ["10.1.0.128/25"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    GatewaySubnet = { cidrs = ["10.1.1.0/24"]
      create_network_security_group = false
    }
  }

  aks_subnets = {
    kubenet = {
      subnet_info = {
        cidrs = ["10.1.2.0/24"]
      }
      route_table = {
        bgp_route_propagation_enabled = false
        routes = {
          internet = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "Internet"
          }
          local-vnet-10-1-0-0-21 = {
            address_prefix = "10.1.0.0/21"
            next_hop_type  = "VnetLocal"
          }
        }
      }
    }
    azurecni = {
      subnet_info = {
        cidrs = ["10.1.3.0/24"]
      }
      route_table = {
        bgp_route_propagation_enabled = false
        routes = {
          internet = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "Internet"
          }
          local-vnet-10-1-0-0-21 = {
            address_prefix = "10.1.0.0/21"
            next_hop_type  = "VnetLocal"
          }
        }
      }
    }
  }
}
