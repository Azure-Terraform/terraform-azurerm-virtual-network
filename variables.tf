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
  description = "Subnet types and lists of CIDRs. format: { [0-9][0-9]-<subnet_type> = cidr }) (increment from 01, cannot be reordered)"
  type        = map(list(string))
  default     = {}
}

variable "enable_nsg" {
  description = "Toggle on/off the use of a network security group. This well need to be turned off for a private link endpoint"
  type        = bool
  default     = true
}
