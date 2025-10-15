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

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../"

  resource_group_name = azurerm_resource_group.test.name
  location           = azurerm_resource_group.test.location
  address_space      = var.address_space
  names              = var.names
  tags               = var.tags
  subnets            = var.subnets
}
