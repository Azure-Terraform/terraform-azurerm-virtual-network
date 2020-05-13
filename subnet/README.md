# Azure - Subnet

## Introduction

This module will create a new subnet in a pre-existing Azure Virtual Network.
<br /><br />

## Input

All inputs for this module are mandatory:
<br />

| Name | Data Type | Description |
| ------ | ------ | ------ |
| resource_group_name | string | Name of the resource group to use | 
| location | string | Azure region
| names | map(string) | names to apply to resources (see note below)|
| tags | map(string) | tags to apply to resources |
| subnet_name | string | name of subnet |
| subnet_cidr | string | CIDR for virtual network |
| enforce_private_link_endpoint_network_policies | string | enable network policies for the private link endpoint on the subnet |
| enforce_private_link_endpoint_service_policies | string | enable network policies for the private link service on the subnet |
| delegations | map(object) | service delegation block (see example) |


Note: Map of names must contain the following keys:
- product_group
- subscription_type
- resource_group_type
- product_name
- location

We reccomend using the following modules to generate these inputs.  Doing so will ensure compliance with LNRS standards.

- Names - [Metadata Module](https://gitlab.ins.risk.regn.net/azure/metadata)
- Tags - [Metadata Module](https://gitlab.ins.risk.regn.net/azure/metadata)


## Output

| Name | Data Type | Description |
| ------ | ------ | ------ |
| id | string | subnet id |
| name | string | subnet name |
| nsg_id | string | network security group id |
| nsg_name | string | network security group name |


<br />
For a full list of details provided in the output please view:<br />
- Subnet - https://www.terraform.io/docs/providers/azurerm/r/subnet.html<br />
- Network Security Group - https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html<br />
<br />

## Example

~~~~
# Subscription
## Please check this module for exact usage
module "subscription" {
  source = "git@gitlab.ins.risk.regn.net:azure/subscription.git?ref=v0.0.1"
  
  subscription_id = "aaaaaa11-11a1-111a-a1a1-1111aaa111a1"
}

# Tags
## Please check this module for exact usage
module "metadata" {
  source = "git@gitlab.ins.risk.regn.net:azure/tags.git?ref=v0.0.1"

  subscription  = module.subscription.output.display_name
  location      = "eastus2"
  environment   = "sandbox"
  product       = "example"
  project       = "example"
  business_unit = "iog"
  cost_center   = "AA11AA"
  market        = "example"
  sre_team      = "iog-core-services"
  terraform     = "true"
}

# Resource group
module "resource_group" {
  source = "git@gitlab.ins.risk.regn.net:azure/resource-group.git?ref=v0.0.1"

  subscription_id = module.subscription.output.subscription_id
  location        = module.metatdata.location
  names           = module.metadata.names
  tags            = module.metadata.tags
}

# Virtual Network
## This will create a vnet with Public, Private, Outbound and Azure Redis Cache, subnets
module "virtual_network" {
  source = "git@gitlab.ins.risk.regn.net:azure/virtual-network.git?ref=v0.0.1"
  
  meta_data           = module.metadata.names
  subscription_id     = module.subscription.output.subscription_id
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["192.168.123.0/24", "192.168.124.0/24"]

  subnets = {
    "01-iaas-private"     = "192.168.123.0/27"
    "02-iaas-public"      = "192.168.123.32/27"
    "03-iaas-outbound"    = "192.168.123.64/27"
    "04-azure-rediscache" = "192.168.124.96/
  }
}

module "subnet" {
  source = "git@gitlab.ins.risk.regn.net:azure/virtual-network.git?ref=v0.1.0"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  virtual_network_name = module.virtual_network.vnet.name

  enforce_private_link_endpoint_network_policies = true

  service_endpoints = ["Microsoft.KeyVault"]

  delegations = {
    vmware_join = { name    = "Microsoft.BareMetal/AzureVMware"
                    actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"] 
                  }
  }

  subnet_type = "azure-firewall"
  subnet_cidr = "192.168.123.96/27"
}
~~~~
