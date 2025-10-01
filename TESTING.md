# Testing Guide for Azure VNet Module

This guide explains how to test the Azure Virtual Network module with the new IPAM pool support.

## Test Structure

The module includes comprehensive tests to ensure:
- ✅ **Backward Compatibility**: Existing configurations continue to work
- ✅ **New IPAM Features**: IPAM pool configuration is stored and output correctly
- ✅ **Mixed Configuration**: Both traditional and IPAM pool features can coexist
- ✅ **Syntax Validation**: All Terraform configurations are syntactically correct

## Available Examples

### 1. Basic Example (`examples/basic/`)
- **Purpose**: Test backward compatibility
- **Features**: Traditional VNet with subnets, NSGs, and route tables
- **IPAM**: No IPAM pool features (tests that they don't interfere)
- **Key Test**: Ensures existing functionality remains unchanged

### 2. Test Example (`examples/test/`)
- **Purpose**: Test mixed configuration
- **Features**: Both traditional subnets and IPAM pool configuration
- **IPAM**: VNet and subnet-level IPAM pool configuration (placeholder IDs)
- **Key Test**: Validates that IPAM configuration is stored and output correctly

### 3. IPAM Pool Example (`examples/ipam_pool/`)
- **Purpose**: Demonstrate full IPAM pool integration
- **Features**: Complete IPAM pool usage example with documentation
- **IPAM**: Comprehensive IPAM pool configuration with data sources
- **Key Test**: Shows how to integrate with existing Network Manager resources

## Running Tests

### Automated Testing

Use the provided test script for comprehensive validation:

```bash
# Run all tests
./test_module.sh

# The script will:
# 1. Validate main module syntax
# 2. Test all examples (init, validate, format check)
# 3. Check existing example compatibility
# 4. Provide detailed results
```

### Manual Testing

#### Step 1: Main Module Validation
```bash
# In the module root directory
terraform init
terraform validate
```

#### Step 2: Test Individual Examples
```bash
# Test basic example
cd examples/basic
terraform init
terraform validate

# Test IPAM example
cd ../test
terraform init
terraform validate

# Test comprehensive IPAM example
cd ../ipam_pool
terraform init
terraform validate
```

#### Step 3: Format Validation
```bash
# Check and fix formatting
terraform fmt -recursive .
```

## Test Results

### ✅ Successful Test Results

When all tests pass, you should see:

```
[SUCCESS] All tests passed! ✅

Module Status:
  ✅ Backward compatibility maintained
  ✅ New IPAM pool features working
  ✅ All examples validate successfully
  ✅ Configuration syntax is correct
```

### Expected Outputs

#### Basic Example (No IPAM)
- `vnet_ipam_allocation`: `null`
- `subnet_ipam_allocations`: `{}`
- All traditional outputs work as before

#### Test Example (Mixed Configuration)
- `vnet_ipam_allocation`: Contains IPAM configuration object
- `subnet_ipam_allocations`: Contains subnet IPAM configurations
- Both traditional and IPAM subnets coexist

#### IPAM Pool Example
- Full IPAM configuration with data source references
- Demonstrates integration patterns
- Shows proper variable usage

## Functionality Tests

### Backward Compatibility ✅
- [x] Existing configurations work without changes
- [x] All original outputs are preserved
- [x] No breaking changes in module interface
- [x] Default values work as expected

### IPAM Pool Support ✅
- [x] VNet-level IPAM pool configuration stored
- [x] Subnet-level IPAM pool configuration stored
- [x] AKS subnet IPAM pool support
- [x] Mixed traditional/IPAM configurations work
- [x] Proper outputs for all IPAM configurations

### Error Handling ✅
- [x] Graceful handling of null IPAM values
- [x] Proper validation of variable types
- [x] Clear error messages for invalid configurations

## Integration Testing

### With Real Azure Resources

To test with actual Azure resources:

1. **Prerequisites**:
   - Azure subscription with Network Manager enabled
   - Existing Network Manager instance
   - IPAM pool created in Network Manager
   - Appropriate Azure permissions

2. **Update Examples**:
   - Replace placeholder resource IDs with real ones
   - Configure Azure provider authentication
   - Set appropriate subscription/tenant IDs

3. **Deploy and Test**:
   ```bash
   # Set Azure credentials
   az login
   
   # Test deployment
   cd examples/test
   terraform plan
   terraform apply
   
   # Verify resources
   az network vnet show --name [vnet-name] --resource-group [rg-name]
   ```

## Troubleshooting

### Common Issues

1. **Missing Names Fields**:
   ```
   Error: Missing map element "resource_group_type"
   ```
   **Solution**: Ensure names object includes all required fields

2. **IPAM Pool Resource IDs**:
   ```
   Error: Invalid resource ID format
   ```
   **Solution**: Use full Azure resource ID format for IPAM pools

3. **Provider Authentication**:
   ```
   Error: subscription ID could not be determined
   ```
   **Solution**: Set up Azure provider authentication

### Debug Commands

```bash
# Check Terraform version
terraform version

# Validate with detailed output
terraform validate -json

# Check plan with detailed logging
TF_LOG=DEBUG terraform plan
```

## Contributing Tests

When adding new features:

1. Create example in `examples/[feature-name]/`
2. Add test case to `test_module.sh`
3. Update this testing guide
4. Ensure all tests pass before submitting PR

## Next Steps

After successful testing:
1. Deploy to development environment
2. Test with real IPAM pool resources
3. Validate IP allocation workflows
4. Document integration patterns
5. Create monitoring and alerting for IPAM resources