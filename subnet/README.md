# Azure - Subnet

## Introduction

This module will create a new subnet in a pre-existing Azure Virtual Network.
<br /><br />

<!--- BEGIN_TF_DOCS --->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cidrs | CIDRs for subnet | `list(string)` | n/a | yes |
| delegations | delegation blocks for services | <pre>map(object({<br>                  name    = string<br>                  actions = list(string)<br>                }))</pre> | `{}` | no |
| enforce\_private\_link\_endpoint\_network\_policies | enable network policies for the private link endpoint on the subnet | `bool` | `false` | no |
| enforce\_private\_link\_service\_network\_policies | enable network policies for the private link service on the subnet | `bool` | `false` | no |
| location | Azure Region | `string` | n/a | yes |
| names | names to be applied to resources | `map(string)` | n/a | yes |
| naming\_rules | naming conventions yaml file | `string` | n/a | yes |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| service\_endpoints | service endpoints to associate with the subnet | `list(string)` | `[]` | no |
| subnet\_type | subnet type | `string` | n/a | yes |
| tags | tags to be applied to resources | `map(string)` | n/a | yes |
| virtual\_network\_name | virtual network name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | subnet id |
| name | subnet name |
| nsg\_id | network security group id |
| nsg\_name | network security group name |
| subnet | subnet data object |
<!--- END_TF_DOCS --->

<br />
For a full list of details provided in the output please view:<br />
- Subnet - https://www.terraform.io/docs/providers/azurerm/r/subnet.html<br />
- Network Security Group - https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html<br />
<br />
