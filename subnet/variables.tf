variable "resource_group_name"{
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

variable "naming_rules" {
  description = "naming conventions yaml file"
  type        = string
  default     = ""
}

variable "enforce_subnet_names" {
  description = "enforce subnet naming rules"
  type        = bool
  default     = false
}

# Networking
variable "virtual_network_name" {
  description = "virtual network name"
  type        = string
}

variable "subnet_type" {
  description = "subnet type"
  type        = string
}

variable "cidrs" {
  description = "CIDRs for subnet"
  type        = list(string)
}

variable "create_network_security_group" {
  description = "Create/associate network security group"
  type        = bool
  default     = true
}

variable "configure_nsg_rules" {
  description = "Configure network security group rules"
  type        = bool
  default     = false
}

variable "allow_internet_outbound" {
  description = "allow outbound traffic to internet"
  type        = bool
  default     = false
}

variable "allow_lb_inbound" {
  description = "allow inbound traffic from Azure Load Balancer"
  type        = bool
  default     = false
}

variable "allow_vnet_inbound" {
  description = "allow all inbound from virtual network"
  type        = bool
  default     = false
}

variable "allow_vnet_outbound" {
  description = "allow all outbound from virtual network"
  type        = bool
  default     = false
}

# Subnet Options
variable "enforce_private_link_endpoint_network_policies" {
  description = "enable network policies for the private link endpoint on the subnet"
  type        = bool
  default     = false
}

variable "enforce_private_link_service_network_policies" {
  description = "enable network policies for the private link service on the subnet"
  type        = bool
  default     = false
}

variable "service_endpoints" {
  description = "service endpoints to associate with the subnet"
  type        = list(string)
  default     = []
}

variable "delegations" {
  description = "delegation blocks for services"
  type        = map(object({
                  name    = string
                  actions = list(string)
                }))
  default     = {}
}