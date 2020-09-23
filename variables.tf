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
  description = "Subnet types and lists of CIDRs, policies, endpoints and delegations"
  type        = map(object({
                      cidrs = list(string)
                      enforce_private_link_endpoint_network_policies = bool
                      enforce_private_link_service_network_policies  = bool
                      service_endpoints                              = list(string)
                      delegations                                    = map(object({
                                                                          name    = string
                                                                          actions = list(string)
                                                                       }))
                }))
  default     = {}
}
