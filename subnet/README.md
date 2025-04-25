# Azure - Subnet

## Introduction

This module will create a new subnet in a pre-existing Azure Virtual Network.
<br /><br />

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_internet\_outbound | allow outbound traffic to internet | `bool` | `false` | no |
| allow\_lb\_inbound | allow inbound traffic from Azure Load Balancer | `bool` | `false` | no |
| allow\_vnet\_inbound | allow all inbound from virtual network | `bool` | `false` | no |
| allow\_vnet\_outbound | allow all outbound from virtual network | `bool` | `false` | no |
| cidrs | CIDRs for subnet | `list(string)` | n/a | yes |
| configure\_nsg\_rules | Configure network security group rules | `bool` | `false` | no |
| create\_network\_security\_group | Create/associate network security group | `bool` | `true` | no |
| delegations | delegation blocks for services | <pre>map(object({<br>    name    = string<br>    actions = list(string)<br>  }))</pre> | `{}` | no |
| enforce\_subnet\_names | enforce subnet naming rules | `bool` | `false` | no |
| location | Azure Region | `string` | n/a | yes |
| names | names to be applied to resources | `map(string)` | n/a | yes |
| naming\_rules | naming conventions yaml file | `string` | `""` | no |
| private\_endpoint\_network\_policies | Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. | `string` | `"Disabled"` | no |
| private\_link\_service\_network\_policies\_enabled | Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. | `bool` | `true` | no |
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
| network\_security\_group\_id | network security group id |
| network\_security\_group\_name | network security group name |
| subnet | subnet data object |

<!--- END_TF_DOCS --->

<br />
For a full list of details provided in the output please view:<br />
- Subnet - https://www.terraform.io/docs/providers/azurerm/r/subnet.html<br />
- Network Security Group - https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html<br />
<br />

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_internet_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_lb_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_vnet_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_vnet_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.deny_all_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.deny_all_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.subnet_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_internet_outbound"></a> [allow\_internet\_outbound](#input\_allow\_internet\_outbound) | allow outbound traffic to internet | `bool` | `false` | no |
| <a name="input_allow_lb_inbound"></a> [allow\_lb\_inbound](#input\_allow\_lb\_inbound) | allow inbound traffic from Azure Load Balancer | `bool` | `false` | no |
| <a name="input_allow_vnet_inbound"></a> [allow\_vnet\_inbound](#input\_allow\_vnet\_inbound) | allow all inbound from virtual network | `bool` | `false` | no |
| <a name="input_allow_vnet_outbound"></a> [allow\_vnet\_outbound](#input\_allow\_vnet\_outbound) | allow all outbound from virtual network | `bool` | `false` | no |
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | CIDRs for subnet | `list(string)` | n/a | yes |
| <a name="input_configure_nsg_rules"></a> [configure\_nsg\_rules](#input\_configure\_nsg\_rules) | Configure network security group rules | `bool` | `false` | no |
| <a name="input_create_network_security_group"></a> [create\_network\_security\_group](#input\_create\_network\_security\_group) | Create/associate network security group | `bool` | `true` | no |
| <a name="input_delegations"></a> [delegations](#input\_delegations) | delegation blocks for services | <pre>map(object({<br/>    name    = string<br/>    actions = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enforce_subnet_names"></a> [enforce\_subnet\_names](#input\_enforce\_subnet\_names) | enforce subnet naming rules | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Region | `string` | n/a | yes |
| <a name="input_names"></a> [names](#input\_names) | names to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_naming_rules"></a> [naming\_rules](#input\_naming\_rules) | naming conventions yaml file | `string` | `""` | no |
| <a name="input_network_security_group_name"></a> [network\_security\_group\_name](#input\_network\_security\_group\_name) | name of the network security group | `string` | `null` | no |
| <a name="input_private_endpoint_network_policies"></a> [private\_endpoint\_network\_policies](#input\_private\_endpoint\_network\_policies) | Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. | `string` | `"Disabled"` | no |
| <a name="input_private_link_service_network_policies_enabled"></a> [private\_link\_service\_network\_policies\_enabled](#input\_private\_link\_service\_network\_policies\_enabled) | Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | service endpoints to associate with the subnet | `list(string)` | `[]` | no |
| <a name="input_subnet_type"></a> [subnet\_type](#input\_subnet\_type) | subnet type | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | virtual network name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | subnet id |
| <a name="output_name"></a> [name](#output\_name) | subnet name |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | network security group id |
| <a name="output_network_security_group_name"></a> [network\_security\_group\_name](#output\_network\_security\_group\_name) | network security group name |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | subnet data object |
<!-- END_TF_DOCS -->