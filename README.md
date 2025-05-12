# Azure - Virtual Network Module

## Introduction

This module will create a new Virtual Network, associated subnets and network security groups in Azure.
<br /><br />
Naming convention for this service is as follows:
<br />
service-market-environment-location-product
<br />

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 3.18.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.18.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_space | CIDRs for virtual network | `list(string)` | n/a | yes |
| aks\_subnets | AKS subnets | <pre>map(object({<br>    subnet_info = any<br>    route_table = object({<br>      bgp_route_propagation_enabled = bool<br>      routes                        = map(map(string))<br>      # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br>      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br>    })<br>  }))</pre> | `null` | no |
| dns\_servers | If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver | `list(string)` | `null` | no |
| enforce\_subnet\_names | enforce subnet names based on naming\_rules variable | `bool` | `true` | no |
| location | Azure Region | `string` | n/a | yes |
| names | Names to be applied to resources | `map(string)` | n/a | yes |
| naming\_rules | naming conventions yaml file | `string` | `""` | no |
| peer\_defaults | Maps of peer arguments. | <pre>object({<br>    id                           = string<br>    allow_virtual_network_access = bool<br>    allow_forwarded_traffic      = bool<br>    allow_gateway_transit        = bool<br>    use_remote_gateways          = bool<br>  })</pre> | <pre>{<br>  "allow_forwarded_traffic": false,<br>  "allow_gateway_transit": false,<br>  "allow_virtual_network_access": true,<br>  "id": null,<br>  "use_remote_gateways": false<br>}</pre> | no |
| peers | Peer virtual networks.  Keys are names, allowed values are same as for peer\_defaults. Id value is required. | `any` | `{}` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| route\_tables | Maps of route tables | <pre>map(object({<br>    bgp_route_propagation_enabled = bool<br>    use_inline_routes             = bool # Setting to true will revert any external route additions.<br>    routes                        = map(map(string))<br>    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br>    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br>  }))</pre> | `{}` | no |
| subnet\_defaults | Maps of CIDRs, policies, endpoints and delegations | <pre>object({<br>    cidrs                                         = list(string)<br>    private_endpoint_network_policies             = string<br>    private_link_service_network_policies_enabled = bool<br>    service_endpoints                             = list(string)<br>    delegations = map(object({<br>      name    = string<br>      actions = list(string)<br>    }))<br>    create_network_security_group = bool # create/associate network security group with subnet<br>    configure_nsg_rules           = bool # deny ingress/egress traffic and configure nsg rules based on below parameters<br>    allow_internet_outbound       = bool # allow outbound traffic to internet (configure_nsg_rules must be set to true)<br>    allow_lb_inbound              = bool # allow inbound traffic from Azure Load Balancer (configure_nsg_rules must be set to true)<br>    allow_vnet_inbound            = bool # allow all inbound from virtual network (configure_nsg_rules must be set to true)<br>    allow_vnet_outbound           = bool # allow all outbound from virtual network (configure_nsg_rules must be set to true)<br>    route_table_association       = string<br>  })</pre> | <pre>{<br>  "allow_internet_outbound": false,<br>  "allow_lb_inbound": false,<br>  "allow_vnet_inbound": false,<br>  "allow_vnet_outbound": false,<br>  "cidrs": [],<br>  "configure_nsg_rules": true,<br>  "create_network_security_group": true,<br>  "delegations": {},<br>  "private_endpoint_network_policies": "Disabled",<br>  "private_link_service_network_policies_enabled": true,<br>  "route_table_association": null,<br>  "service_endpoints": []<br>}</pre> | no |
| subnets | Map of subnets. Keys are subnet names, Allowed values are the same as for subnet\_defaults | `any` | `{}` | no |
| tags | Tags to be applied to resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aks | Virtual network information matching AKS module input. |
| route\_tables | Maps of custom route tables. |
| subnet | Map of subnet data objects. |
| subnet\_nsg\_ids | Map of subnet ids to associated network\_security\_group ids. |
| subnet\_nsg\_names | Map of subnet names to associated network\_security\_group names. |
| subnets | Maps of subnet info. |
| vnet | Virtual network data object. |

<!--- END_TF_DOCS --->

<br />
For a full list of details provided in the output please view:<br />
- Virtual Network (vnet) - https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html<br />
- Subnet(s) - https://www.terraform.io/docs/providers/azurerm/r/subnet.html<br />
<br />
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks_subnet"></a> [aks\_subnet](#module\_aks\_subnet) | ./subnet | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ./subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_route.aks_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.non_inline_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.aks_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.peer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | CIDRs for virtual network | `list(string)` | n/a | yes |
| <a name="input_aks_subnets"></a> [aks\_subnets](#input\_aks\_subnets) | AKS subnets | <pre>map(object({<br/>    subnet_info = any<br/>    route_table = object({<br/>      bgp_route_propagation_enabled = bool<br/>      routes                        = map(map(string))<br/>      # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br/>      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br/>    })<br/>  }))</pre> | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver | `list(string)` | `null` | no |
| <a name="input_enforce_subnet_names"></a> [enforce\_subnet\_names](#input\_enforce\_subnet\_names) | enforce subnet names based on naming\_rules variable | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure Region | `string` | n/a | yes |
| <a name="input_names"></a> [names](#input\_names) | Names to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_naming_rules"></a> [naming\_rules](#input\_naming\_rules) | naming conventions yaml file | `string` | `""` | no |
| <a name="input_peer_defaults"></a> [peer\_defaults](#input\_peer\_defaults) | Maps of peer arguments. | <pre>object({<br/>    id                           = string<br/>    allow_virtual_network_access = bool<br/>    allow_forwarded_traffic      = bool<br/>    allow_gateway_transit        = bool<br/>    use_remote_gateways          = bool<br/>  })</pre> | <pre>{<br/>  "allow_forwarded_traffic": false,<br/>  "allow_gateway_transit": false,<br/>  "allow_virtual_network_access": true,<br/>  "id": null,<br/>  "use_remote_gateways": false<br/>}</pre> | no |
| <a name="input_peers"></a> [peers](#input\_peers) | Peer virtual networks.  Keys are names, allowed values are same as for peer\_defaults. Id value is required. | `any` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Maps of route tables | <pre>map(object({<br/>    bgp_route_propagation_enabled = bool<br/>    use_inline_routes             = bool # Setting to true will revert any external route additions.<br/>    routes                        = map(map(string))<br/>    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br/>    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br/>  }))</pre> | `{}` | no |
| <a name="input_subnet_defaults"></a> [subnet\_defaults](#input\_subnet\_defaults) | Maps of CIDRs, policies, endpoints and delegations | <pre>object({<br/>    cidrs                                         = list(string)<br/>    private_endpoint_network_policies             = string<br/>    private_link_service_network_policies_enabled = bool<br/>    service_endpoints                             = list(string)<br/>    delegations = map(object({<br/>      name    = string<br/>      actions = list(string)<br/>    }))<br/>    create_network_security_group = bool   # create/associate network security group with subnet<br/>    security_group_prefix         = string # prefix for network security group name<br/>    configure_nsg_rules           = bool   # deny ingress/egress traffic and configure nsg rules based on below parameters<br/>    allow_internet_outbound       = bool   # allow outbound traffic to internet (configure_nsg_rules must be set to true)<br/>    allow_lb_inbound              = bool   # allow inbound traffic from Azure Load Balancer (configure_nsg_rules must be set to true)<br/>    allow_vnet_inbound            = bool   # allow all inbound from virtual network (configure_nsg_rules must be set to true)<br/>    allow_vnet_outbound           = bool   # allow all outbound from virtual network (configure_nsg_rules must be set to true)<br/>    route_table_association       = string<br/>  })</pre> | <pre>{<br/>  "allow_internet_outbound": false,<br/>  "allow_lb_inbound": false,<br/>  "allow_vnet_inbound": false,<br/>  "allow_vnet_outbound": false,<br/>  "cidrs": [],<br/>  "configure_nsg_rules": true,<br/>  "create_network_security_group": true,<br/>  "delegations": {},<br/>  "private_endpoint_network_policies": "Disabled",<br/>  "private_link_service_network_policies_enabled": true,<br/>  "route_table_association": null,<br/>  "security_group_prefix": null,<br/>  "service_endpoints": []<br/>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets. Keys are subnet names, Allowed values are the same as for subnet\_defaults | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_use_product_name"></a> [use\_product\_name](#input\_use\_product\_name) | use product\_name as prefix for VNET resource | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks"></a> [aks](#output\_aks) | Virtual network information matching AKS module input. |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Maps of custom route tables. |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | Map of subnet data objects. |
| <a name="output_subnet_nsg_ids"></a> [subnet\_nsg\_ids](#output\_subnet\_nsg\_ids) | Map of subnet ids to associated network\_security\_group ids. |
| <a name="output_subnet_nsg_names"></a> [subnet\_nsg\_names](#output\_subnet\_nsg\_names) | Map of subnet names to associated network\_security\_group names. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Maps of subnet info. |
| <a name="output_vnet"></a> [vnet](#output\_vnet) | Virtual network data object. |
<!-- END_TF_DOCS -->