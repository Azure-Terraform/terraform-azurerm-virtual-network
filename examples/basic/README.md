# Basic Virtual Network Example

This example demonstrates a basic usage of the Virtual Network module without any IPAM pool features. This serves as a backward compatibility test to ensure existing functionality remains intact.

## Features Demonstrated

- **Basic Virtual Network**: Standard VNet with address space
- **Multiple Subnets**: Web, app, and data tier subnets
- **Network Security Groups**: Automatic NSG creation with custom rules
- **Route Tables**: Custom route table with internet routing
- **Route Table Association**: Associating subnets with route tables
- **No IPAM Pool**: Demonstrates that IPAM features are optional

## Resources Created

- Resource Group
- Virtual Network with /16 address space
- 3 Subnets (web, app, data)
- Network Security Groups for each subnet
- Route table with internet routing
- Route table association

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Clean up resources:
   ```bash
   terraform destroy
   ```

## Key Configuration Points

- **Address Space**: Uses traditional /16 CIDR block
- **Subnets**: Each subnet has /24 CIDR blocks
- **NSG Rules**: Web tier allows internet outbound, all tiers allow VNet communication
- **Route Table**: Web subnet has custom route table for internet access
- **IPAM Pool**: Not used (all IPAM outputs should be null/empty)

## Expected Outputs

- `virtual_network_id`: Resource ID of the created VNet
- `subnets`: Information about all created subnets
- `route_tables`: Information about created route tables
- `vnet_ipam_allocation`: Should be `null` (no IPAM pool configured)
- `subnet_ipam_allocations`: Should be empty `{}` (no IPAM pool configured)

## Backward Compatibility Test

This example serves as a test to ensure:
- Existing Terraform configurations continue to work
- New IPAM pool variables don't interfere with traditional deployments
- All original outputs are preserved
- No breaking changes in the module interface