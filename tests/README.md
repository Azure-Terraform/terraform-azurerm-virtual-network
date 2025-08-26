# Terraform Tests

This directory contains Terraform native tests for the Azure Virtual Network module.

## Test Files

- `basic.tftest.hcl` - Basic functionality tests
- `advanced.tftest.hcl` - Complex scenarios and integrations  
- `validation.tftest.hcl` - Input validation tests

## Running Tests

```bash
# Run all tests
terraform test

# Run specific test files
terraform test -filter=tests/basic.tftest.hcl
terraform test -filter=tests/advanced.tftest.hcl
terraform test -filter=tests/validation.tftest.hcl
```

## Requirements

- Terraform 1.6+
- Azure CLI authenticated
- Azure subscription with appropriate permissions

### All Tests
```bash
# Run all tests
terraform test

# Run specific test categories
terraform test -filter=tests/basic.tftest.hcl
terraform test -filter=tests/advanced.tftest.hcl
terraform test -filter=tests/validation.tftest.hcl
```

### Individual Test Files
```bash
# Run specific test file
terraform test -filter=tests/basic.tftest.hcl

# Run with verbose output
terraform test -filter=tests/basic.tftest.hcl -verbose

# Plan only (no apply)
terraform test -filter=tests/validation.tftest.hcl -no-color
```

### Development Workflow
```bash
# Format and validate
terraform fmt -recursive .
terraform init -backend=false
terraform validate

# Run all tests
terraform test

# Clean up (manual)
# Remove .terraform directories and state files as needed
```

## Test Design Principles

### 1. **Isolation**
Each test run uses unique resource names to prevent conflicts:
```hcl
variables {
  resource_group_name = "test-vnet-basic-rg"
  # Unique naming prevents conflicts
}
```

### 2. **Comprehensive Coverage**
Tests cover:
- Happy path scenarios
- Edge cases and error conditions
- Input validation
- Resource relationships
- Configuration variations

### 3. **Fast Feedback**
- Validation tests use `command = plan` for quick feedback
- Integration tests use `command = apply` for full validation
- Tests are designed to run in parallel where possible

### 4. **Assertions**
Each test includes comprehensive assertions:
```hcl
assert {
  condition     = output.vnet.address_space[0] == "10.0.0.0/16"
  error_message = "Virtual network address space should be 10.0.0.0/16"
}
```

## Test Categories Explained

### Plan-Only Tests
These tests validate configuration without creating resources:
- Input validation
- Configuration syntax
- Variable constraints
- Naming conventions

### Apply Tests  
These tests create actual Azure resources:
- Resource creation validation
- Output verification
- Resource property validation
- Integration testing

## CI/CD Integration

### GitHub Actions
```yaml
name: Terraform Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: '1.6.0'
    - name: Run Tests
      run: make ci-test
      env:
        ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
        ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
        ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
        ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
```

### Azure DevOps
```yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: TerraformInstaller@0
  inputs:
    terraformVersion: '1.6.0'
- script: make ci-test
  env:
    ARM_CLIENT_ID: $(ARM_CLIENT_ID)
    ARM_CLIENT_SECRET: $(ARM_CLIENT_SECRET)
    ARM_TENANT_ID: $(ARM_TENANT_ID)
    ARM_SUBSCRIPTION_ID: $(ARM_SUBSCRIPTION_ID)
```

## Troubleshooting

### Common Issues

#### Authentication Errors
```
Error: building Azure client: authentication failed
```
**Solution**: Ensure Azure authentication is configured:
```bash
az login
# or set service principal environment variables
```

#### Resource Naming Conflicts
```
Error: A resource with the ID already exists
```
**Solution**: Tests use unique naming, but if conflicts occur:
- Clean up previous test runs
- Check for stuck resources in Azure portal

#### Test Timeouts
```
Error: timeout while waiting for state
```
**Solution**: 
- Check Azure service status
- Verify subscription limits
- Review resource dependencies

### Debug Mode
Enable verbose output for troubleshooting:
```bash
terraform test -filter=tests/basic.tftest.hcl -verbose
```

### Manual Cleanup
If tests fail to clean up resources:
```bash
# List test resource groups
az group list --query "[?contains(name, 'test-')].name" -o table

# Delete specific resource group
az group delete --name "test-vnet-basic-rg" --yes --no-wait
```

## Best Practices

### 1. **Test Naming**
- Use descriptive test names
- Include the scenario being tested
- Group related tests logically

### 2. **Resource Naming**
- Use consistent prefixes for test resources
- Include test type in resource names
- Ensure uniqueness across parallel runs

### 3. **Assertions**
- Test both positive and negative scenarios
- Validate all critical outputs
- Include meaningful error messages

### 4. **Test Organization**
- Group related tests in the same file
- Keep test files focused and manageable
- Document complex test scenarios

### 5. **Maintenance**
- Update tests when module changes
- Remove obsolete test scenarios
- Keep test data current

## Contributing

When adding new tests:

1. **Follow naming conventions**
2. **Include comprehensive assertions**
3. **Add documentation for complex scenarios**
4. **Test both success and failure cases**
5. **Ensure tests can run independently**

## Resources

- [Terraform Testing](https://developer.hashicorp.com/terraform/language/tests)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Assert Functions](https://developer.hashicorp.com/terraform/language/functions)
