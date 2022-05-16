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
| azurerm | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_space | CIDRs for virtual network | `list(string)` | n/a | yes |
| aks\_subnets | AKS subnets | <pre>map(object({<br>    subnet_info = any<br>    route_table = object({<br>      disable_bgp_route_propagation = bool<br>      routes                        = map(map(string))<br>      # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br>      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br>    })<br>  }))</pre> | `null` | no |
| dns\_servers | If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver | `list(string)` | `null` | no |
| enforce\_subnet\_names | enforce subnet names based on naming\_rules variable | `bool` | `true` | no |
| location | Azure Region | `string` | n/a | yes |
| names | Names to be applied to resources | `map(string)` | n/a | yes |
| naming\_rules | naming conventions yaml file | `string` | `""` | no |
| peer\_defaults | Maps of peer arguments. | <pre>object({<br>    id                           = string<br>    allow_virtual_network_access = bool<br>    allow_forwarded_traffic      = bool<br>    allow_gateway_transit        = bool<br>    use_remote_gateways          = bool<br>  })</pre> | <pre>{<br>  "allow_forwarded_traffic": false,<br>  "allow_gateway_transit": false,<br>  "allow_virtual_network_access": true,<br>  "id": null,<br>  "use_remote_gateways": false<br>}</pre> | no |
| peers | Peer virtual networks.  Keys are names, allowed values are same as for peer\_defaults. Id value is required. | `any` | `{}` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| route\_tables | Maps of route tables | <pre>map(object({<br>    disable_bgp_route_propagation = bool<br>    use_inline_routes             = bool # Setting to true will revert any external route additions.<br>    routes                        = map(map(string))<br>    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br>    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br>  }))</pre> | `{}` | no |
| subnet\_defaults | Maps of CIDRs, policies, endpoints and delegations | <pre>object({<br>    cidrs                                          = list(string)<br>    enforce_private_link_endpoint_network_policies = bool<br>    enforce_private_link_service_network_policies  = bool<br>    service_endpoints                              = list(string)<br>    delegations = map(object({<br>      name    = string<br>      actions = list(string)<br>    }))<br>    create_network_security_group = bool # create/associate network security group with subnet<br>    configure_nsg_rules           = bool # deny ingress/egress traffic and configure nsg rules based on below parameters<br>    allow_internet_outbound       = bool # allow outbound traffic to internet (configure_nsg_rules must be set to true)<br>    allow_lb_inbound              = bool # allow inbound traffic from Azure Load Balancer (configure_nsg_rules must be set to true)<br>    allow_vnet_inbound            = bool # allow all inbound from virtual network (configure_nsg_rules must be set to true)<br>    allow_vnet_outbound           = bool # allow all outbound from virtual network (configure_nsg_rules must be set to true)<br>    route_table_association       = string<br>  })</pre> | <pre>{<br>  "allow_internet_outbound": false,<br>  "allow_lb_inbound": false,<br>  "allow_vnet_inbound": false,<br>  "allow_vnet_outbound": false,<br>  "cidrs": [],<br>  "configure_nsg_rules": true,<br>  "create_network_security_group": true,<br>  "delegations": {},<br>  "enforce_private_link_endpoint_network_policies": false,<br>  "enforce_private_link_service_network_policies": false,<br>  "route_table_association": null,<br>  "service_endpoints": []<br>}</pre> | no |
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