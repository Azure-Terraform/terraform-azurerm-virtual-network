# Azure Virtual Network with IPAM Pool Support Example

This example demonstrates how to use the Virtual Network module with Azure Network Manager IPAM pool support.

## Prerequisites

Before using this example, you need to have:

1. An Azure Network Manager instance deployed
2. An IPAM pool created in the Azure Network Manager
3. Appropriate permissions to create and manage Network Manager resources

## Resources Created

- Resource Group
- Virtual Network with IPAM pool allocation
- Multiple subnets with individual IPAM pool allocations
- Network Security Groups
- Static member associations for IPAM pool allocations

## Key Features

- **VNet-level IPAM Pool**: Allocate IP addresses from a pool for the entire virtual network
- **Subnet-level IPAM Pool**: Individual subnets can have their own pool allocations
- **Mixed Configuration**: Some subnets can use traditional CIDR blocks while others use IPAM pools
- **AKS Support**: AKS subnets also support IPAM pool allocation

## Variables

The example assumes you have:
- `network_manager_id`: The ID of your existing Azure Network Manager
- `ipam_pool_id`: The ID of your existing IPAM pool

## Usage

1. Update the variables in `terraform.tfvars` with your specific values
2. Initialize Terraform: `terraform init`
3. Plan: `terraform plan`
4. Apply: `terraform apply`

## Important Notes

- The IPAM pool must be created outside of this module
- The `ip_address_pool` parameter expects the full resource ID of the IPAM pool
- The `number_of_ip_addresses` parameter specifies how many IPs to allocate from the pool
- Both VNet and individual subnets can have IPAM pool allocations
- When using IPAM pools, traditional CIDR blocks may still be required for some subnet configurations