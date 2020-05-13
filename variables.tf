variable "naming_conventions_yaml_url" {
  description = "URL for naming conventions yaml file"
  type        = string
  default     = "https://raw.githubusercontent.com/openrba/python-azure-naming/master/custom.yaml" 
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
variable "address_space"{
  description = "CIDRs for virtual network"
  type        = list
}

variable "subnets" {
  description = "Subnet types and CIDRs. format: { [0-9][0-9]-<subnet_type> = cidr }) (increment from 01, cannot be reordered)"
  type        = map(string)
  default     = {}
}