variable "naming_rules" {
  description = "naming conventions yaml file" 
  type        = string
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
  type        = map
  default     = {}
}

variable "subnet_defaults" {
  description = "lists of CIDRs, policies, endpoints and delegations"
  type        = object({
                  cidrs = list(string)
                  enforce_private_link_endpoint_network_policies = bool
                  enforce_private_link_service_network_policies  = bool
                  service_endpoints                              = list(string)
                  delegations                                    = map(object({
                                                                          name    = string
                                                                          actions = list(string)
                                                                       }))
                  deny_all_ingress                               = bool
                  deny_all_egress                                = bool
                })
  default     = { 
                  cidrs                                          = []
                  enforce_private_link_endpoint_network_policies = false
                  enforce_private_link_service_network_policies  = false
                  service_endpoints                              = []
                  delegations                                    = {}
                  deny_all_ingress                               = true
                  deny_all_egress                                = true
                }
}
