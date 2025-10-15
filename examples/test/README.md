# Test Example for VNet Module

This example tests both traditional VNet functionality and the new IPAM pool configuration features.

## Purpose

This example serves as a comprehensive test to ensure:
- Traditional VNet and subnet functionality works
- New IPAM pool configuration is stored correctly
- Both features can coexist without conflicts
- All outputs are generated properly

## Features Tested

- **Basic Subnet**: Traditional CIDR-only subnet configuration
- **IPAM Pool Subnet**: Subnet with IPAM pool configuration
- **VNet IPAM Pool**: VNet-level IPAM pool configuration
- **Mixed Configuration**: Both traditional and IPAM pool configurations in the same VNet

## Important Notes

- This example uses placeholder IPAM pool resource IDs
- No actual IP allocation occurs (configuration storage only)
- Real IPAM pool IDs would need to be provided for actual deployment
- The example demonstrates the module's ability to store and output IPAM configurations

## Expected Behavior

1. **Basic Subnet**: Should work exactly as before
2. **IPAM Pool Configurations**: Should be stored in locals and output correctly
3. **No Errors**: Module should handle mixed configurations without issues
4. **Outputs**: All IPAM-related outputs should contain the configuration data

## Usage

This is primarily for testing and validation. To use with real resources:

1. Replace placeholder resource IDs with actual IPAM pool IDs
2. Ensure you have permissions to the Network Manager resources
3. Use external tooling for actual IP allocation from the pools