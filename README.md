# Azure - Virtual Network Module

## Introduction

This module will create a new Virtual Network, associated subnets and network security groups in Azure.
<br /><br />
Naming convention for this service is as follows:
<br />
service-market-environment-location-product
<br />

<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0.0 |


## Example Usage
```hcl
variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

variable "location" {
  description = "Azure Region"
  type        = string
}

# Configure Providers
provider "azurerm" {
  version = ">=2.2.0"
  subscription_id = "00000000-0000-0000-0000-0000000"
  features {}
}

##
# Pre-Built Modules 
##

module "subscription" {
  source          = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = "00000000-0000-0000-0000-0000000"
}

module "rules" {
  source = "git@github.com:[redacted]/python-azure-naming.git?ref=tf"
}

# For tags and info see https://github.com/Azure-Terraform/terraform-azurerm-metadata 
# For naming convention see https://github.com/redacted/python-azure-naming 
module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.1.0"

  naming_rules = module.rules.yaml
  
  market              = "us"
  location            = "useast1"
  sre_team            = "alpha"
  environment         = "sandbox"
  project             = "mssql"
  business_unit       = "iog"
  product_group       = "tfe"
  product_name        = "vnet"
  subscription_id     = "00000000-0000-0000-0000-0000000"
  subscription_type   = "nonprod"
  resource_group_type = "app"
}

module "virtual_network" {
  source = "github.com/Azure-Terraform/terraform-azurerm-virtual-network.git?ref=v1.0.0"
  
  #toggle NSG
  enable_nsg   = false
  naming_rules = module.rules.yaml

  resource_group_name = "vnet-test-sandbox-eastus-01"
  location            = module.metadata.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["192.168.123.0/24"]

  subnets = {
    "01-iaas-private"     = ["192.168.123.0/27"]
    "02-iaas-public"      = ["192.168.123.32/27"]
    "03-iaas-outbound"    = ["192.168.123.64/27"]
  }
  
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address\_space | CIDRs for virtual network | `list(string)` | n/a | yes |
| location | Azure Region | `string` | n/a | yes |
| names | Names to be applied to resources | `map(string)` | n/a | yes |
| naming\_rules | naming conventions yaml file | `string` | n/a | yes |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| subnets | Subnet types and lists of CIDRs. format: { [0-9][0-9]-<subnet\_type> = cidr }) (increment from 01, cannot be reordered) | `map(list(string))` | `{}` | no |
| tags | Tags to be applied to resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| subnet | Map of subnet resources |
| subnet\_nsg\_ids | Map of subnet ids to associated network\_security\_group ids |
| subnet\_nsg\_names | Map of subnet names to associated network\_security\_group names |
| vnet | Virtual network resource |
<!--- END_TF_DOCS --->

<br />
For a full list of details provided in the output please view:<br />
- Virtual Network (vnet) - https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html<br />
- Subnet(s) - https://www.terraform.io/docs/providers/azurerm/r/subnet.html<br />
<br />
