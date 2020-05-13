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
| http | >= 1.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| address\_space | CIDRs for virtual network | `list` | n/a | yes |
| location | Azure Region | `string` | n/a | yes |
| names | Names to be applied to resources | `map(string)` | n/a | yes |
| naming\_conventions\_yaml\_url | URL for naming conventions yaml file | `string` | `"https://raw.githubusercontent.com/openrba/python-azure-naming/master/custom.yaml"` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| subnets | Subnet types and CIDRs. format: { [0-9][0-9]-<subnet\_type> = cidr }) (increment from 01, cannot be reordered) | `map(string)` | `{}` | no |
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