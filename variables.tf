variable "virtual_network_name" {
  description = "Optional override for the virtual network name. If not set, name is generated from other variables."
  type        = string
  default     = null
}
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "use_product_name" {
  description = "use product_name as prefix for VNET resource"
  type        = bool
  default     = false
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

variable "naming_rules" {
  description = "naming conventions yaml file"
  type        = string
  default     = ""
}

variable "enforce_subnet_names" {
  description = "enforce subnet names based on naming_rules variable"
  type        = bool
  default     = true
}

# Networking
variable "address_space" {
  description = "CIDRs for virtual network"
  type        = list(string)
  
  validation {
    condition = length(var.address_space) > 0
    error_message = "Address space cannot be empty."
  }
  
  validation {
    condition = alltrue([
      for cidr in var.address_space : can(cidrhost(cidr, 0))
    ])
    error_message = "All address spaces must be valid CIDR blocks."
  }
}

variable "dns_servers" {
  description = "If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver"
  type        = list(string)
  default     = null
  
  validation {
    condition = var.dns_servers == null || length(var.dns_servers) <= 4
    error_message = "Maximum of 4 DNS servers are supported."
  }
  
  validation {
    condition = var.dns_servers == null || alltrue([
      for dns in var.dns_servers : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", dns))
    ])
    error_message = "DNS servers must be valid IP addresses."
  }
}

variable "subnets" {
  description = "Map of subnets. Keys are subnet names, Allowed values are the same as for subnet_defaults"
  type        = any
  default     = {}

  validation {
    condition = (length(compact([for subnet in var.subnets : (!lookup(subnet, "configure_nsg_rules", true) &&
      (contains(keys(subnet), "allow_internet_outbound") ||
        contains(keys(subnet), "allow_lb_inbound") ||
        contains(keys(subnet), "allow_vnet_inbound") ||
      contains(keys(subnet), "allow_vnet_outbound")) ?
    "invalid" : "")])) == 0)
    error_message = "Subnet rules not allowed when configure_nsg_rules is set to \"false\"."
  }
}

variable "aks_subnets" {
  description = "AKS subnets"
  type = map(object({
    subnet_info = any
    route_table = object({
      bgp_route_propagation_enabled = bool
      routes                        = map(map(string))
    })
  }))
  default = null
}

variable "subnet_defaults" {
  description = "Maps of CIDRs, policies, endpoints and delegations"
  type = object({
    cidrs                                         = list(string)
    private_endpoint_network_policies             = string
    private_link_service_network_policies_enabled = bool
    service_endpoints                             = list(string)
    delegations = map(object({
      name    = string
      actions = list(string)
    }))
    create_network_security_group = bool
    security_group_prefix         = string
    configure_nsg_rules           = bool
    allow_internet_outbound       = bool
    allow_lb_inbound              = bool
    allow_vnet_inbound            = bool
    allow_vnet_outbound           = bool
    route_table_association       = string
  })
  default = {
    cidrs                                         = []
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = []
    delegations                                   = {}
    create_network_security_group                 = true
    security_group_prefix                         = null
    configure_nsg_rules                           = true
    allow_internet_outbound                       = false
    allow_lb_inbound                              = false
    allow_vnet_inbound                            = false
    allow_vnet_outbound                           = false
    route_table_association                       = null
  }
}

variable "route_tables" {
  description = "Maps of route tables"
  type = map(object({
    bgp_route_propagation_enabled = bool
    use_inline_routes             = bool
    routes                        = map(map(string))
  }))
  default = {}
}

variable "peers" {
  description = "Peer virtual networks.  Keys are names, allowed values are same as for peer_defaults. Id value is required."
  type        = any
  default     = {}
}

variable "peer_defaults" {
  description = "Maps of peer arguments."
  type = object({
    id                           = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  })
  default = {
    id                           = null
    allow_virtual_network_access = true
    allow_forwarded_traffic      = false
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}
