variable "naming_rules" {
  description = "naming conventions yaml file" 
  type        = string
}

variable "dns_servers" {
  description = "Custom DNS servers (if applicable) ,  list of custom DNS servers to use inside your virtual network instead of the Azure-provided resolver" 
  type        = list(string)
  default     = null
}
variable "resource_group_name"{
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "names" {
  description = "Names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
}

# Networking
variable "address_space" {
  description = "CIDRs for virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets. Keys are subnet names, Allowed values are the same as for subnet_defaults."
  type        = any
  default     = {}
}

variable "subnet_defaults" {
  description = "Maps of CIDRs, policies, endpoints and delegations"
  type        = object({
                  cidrs                                          = list(string)
                  enforce_private_link_endpoint_network_policies = bool
                  enforce_private_link_service_network_policies  = bool
                  service_endpoints                              = list(string)
                  delegations                                    = map(object({
                                                                          name    = string
                                                                          actions = list(string)
                                                                       }))
                  allow_internet_outbound                        = bool   # allow outbound traffic to internet
                  allow_lb_inbound                               = bool   # allow inbound traffic from Azure Load Balancer
                  allow_vnet_inbound                             = bool   # allow all inbound from virtual network
                  allow_vnet_outbound                            = bool   # allow all outbound from virtual network
                  route_table_association                        = string
                })
  default     = { 
                  cidrs                                          = []
                  enforce_private_link_endpoint_network_policies = false
                  enforce_private_link_service_network_policies  = false
                  service_endpoints                              = []
                  delegations                                    = {}
                  allow_internet_outbound                        = false
                  allow_lb_inbound                               = false
                  allow_vnet_inbound                             = false
                  allow_vnet_outbound                            = false
                  route_table_association                        = null
                }
}

variable "route_tables" {
  description = "Maps of route tables"
  type        = map(object({
                  disable_bgp_route_propagation = bool
                  routes                        = map(map(string)) 
                  # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)
                  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route
                }))
  default     = {}
}

variable "peers" {
  description = "Peer virtual networks.  Keys are names, allowed values are same as for peer_defaults. Id value is required."
  type        = any
  default     = {}
}

variable "peer_defaults" {
  description = "Maps of peer arguments."
  type        = object({
                  id                           = string
                  allow_virtual_network_access = bool
                  allow_forwarded_traffic      = bool
                  allow_gateway_transit        = bool
                  use_remote_gateways          = bool
                })
  default     = {
                  id                           = null    # remote virtual network id
                  allow_virtual_network_access = true    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#allow_virtual_network_access
                  allow_forwarded_traffic      = false   # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#allow_forwarded_traffic
                  allow_gateway_transit        = false   # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#allow_gateway_transit
                  use_remote_gateways          = false   # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering#use_remote_gateways
                }
}

