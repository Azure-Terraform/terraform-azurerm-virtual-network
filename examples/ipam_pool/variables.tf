variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-vnet-ipam-example"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "location_short" {
  description = "Short name for Azure region"
  type        = string
  default     = "eastus"
}

variable "product_name" {
  description = "Product name for resource naming"
  type        = string
  default     = "ipamexample"
}

variable "product_group" {
  description = "Product group for resource naming"
  type        = string
  default     = "networking"
}

variable "subscription_type" {
  description = "Subscription type for resource naming"
  type        = string
  default     = "dev"
}

variable "network_manager_name" {
  description = "Name of the existing Azure Network Manager"
  type        = string
}

variable "network_manager_resource_group_name" {
  description = "Resource group name where the Azure Network Manager exists"
  type        = string
}

variable "ipam_pool_name" {
  description = "Name of the existing IPAM pool"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network. When using IPAM pools, this serves as a placeholder and will be dynamically allocated."
  type        = list(string)
  default     = ["0.0.0.0/8"]  # Placeholder when using IPAM pools
}

variable "vnet_ip_count" {
  description = "Number of IP addresses to allocate from IPAM pool for the VNet"
  type        = number
  default     = 1000
}

variable "enable_aks" {
  description = "Enable AKS subnet configuration"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "IPAM Pool Example"
    Owner       = "Platform Team"
  }
}
