# Important Note About IPAM Pool Usage

## Current Azure/Terraform Limitation

You correctly identified that logically, IPAM pools should eliminate the need for traditional CIDR blocks. However, there's currently a limitation in the Azure provider and Azure's implementation:

### The Issue
- **Azure Subnet Resource**: Still requires `address_prefixes` even when using IPAM pools
- **Terraform Provider**: Doesn't yet have full IPAM pool resource support
- **IPAM Workflow**: Currently requires external tools for actual IP allocation

### Current Implementation
```hcl
# What we'd ideally want (logical):
subnet = {
  ip_address_pool        = "/subscriptions/.../ipamPools/pool"
  number_of_ip_addresses = 100
  # No cidrs needed - allocated from pool
}

# What currently works (with limitation):
subnet = {
  cidrs                  = ["10.0.1.0/24"]  # Still required for Azure subnet resource
  ip_address_pool        = "/subscriptions/.../ipamPools/pool"
  number_of_ip_addresses = 100              # Additional IP management via IPAM
}
```

### Future State
When Azure provider adds full IPAM pool support:
- `azurerm_network_manager_ipam_pool_static_cidr` resource
- Dynamic CIDR allocation from pools
- No need for manual CIDR specification

### Current Workaround
1. **Base Subnet**: Use minimal CIDR for Azure subnet resource
2. **IPAM Pool**: Handle additional IP allocation externally
3. **Configuration Storage**: Module stores IPAM settings for external tools

This is why the examples still include CIDRs - it's a current technical limitation, not a design choice.