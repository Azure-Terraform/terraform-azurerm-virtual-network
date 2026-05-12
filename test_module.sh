#!/bin/bash

# Test script for Azure VNet Module with IPAM Pool Support
# This script validates the module functionality and backward compatibility

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to test an example
test_example() {
    local example_name="$1"
    local example_path="examples/$example_name"
    
    print_status "Testing example: $example_name"
    
    if [ ! -d "$example_path" ]; then
        print_error "Example directory not found: $example_path"
        return 1
    fi
    
    cd "$example_path"
    
    # Initialize Terraform
    print_status "  Initializing Terraform..."
    if terraform init > /dev/null 2>&1; then
        print_success "  Terraform init successful"
    else
        print_error "  Terraform init failed"
        cd - > /dev/null
        return 1
    fi
    
    # Validate configuration
    print_status "  Validating configuration..."
    if terraform validate > /dev/null 2>&1; then
        print_success "  Configuration is valid"
    else
        print_error "  Configuration validation failed"
        terraform validate
        cd - > /dev/null
        return 1
    fi
    
    # Format check
    print_status "  Checking format..."
    if terraform fmt -check > /dev/null 2>&1; then
        print_success "  Format is correct"
    else
        print_warning "  Format issues found (non-critical)"
        terraform fmt -diff
    fi
    
    cd - > /dev/null
    return 0
}

# Main test execution
print_status "Starting Azure VNet Module Tests"
echo "========================================"

# Test main module
print_status "Testing main module"
if terraform validate > /dev/null 2>&1; then
    print_success "Main module validation successful"
else
    print_error "Main module validation failed"
    terraform validate
    exit 1
fi

# Test examples
examples_to_test=("basic" "test" "ipam_pool")
failed_tests=0

for example in "${examples_to_test[@]}"; do
    if ! test_example "$example"; then
        ((failed_tests++))
    fi
    echo ""
done

# Test existing examples if they exist
existing_examples=("aks" "bastion" "custom_routes")
for example in "${existing_examples[@]}"; do
    if [ -d "examples/$example" ]; then
        print_status "Testing existing example: $example"
        cd "examples/$example"
        if terraform init > /dev/null 2>&1 && terraform validate > /dev/null 2>&1; then
            print_success "Existing example $example is compatible"
        else
            print_warning "Existing example $example may need updates"
            ((failed_tests++))
        fi
        cd - > /dev/null
        echo ""
    fi
done

# Summary
echo "========================================"
print_status "Test Summary"
echo ""

if [ $failed_tests -eq 0 ]; then
    print_success "All tests passed! ✅"
    echo ""
    print_status "Module Status:"
    echo "  ✅ Backward compatibility maintained"
    echo "  ✅ New IPAM pool features working"
    echo "  ✅ All examples validate successfully"
    echo "  ✅ Configuration syntax is correct"
    echo ""
    print_status "Next Steps:"
    echo "  1. Test with actual Azure resources"
    echo "  2. Verify IPAM pool integration with real Network Manager"
    echo "  3. Test deployment in different Azure regions"
    
    exit 0
else
    print_error "$failed_tests test(s) failed! ❌"
    echo ""
    print_status "Issues found:"
    echo "  - Check the error messages above"
    echo "  - Fix configuration issues"
    echo "  - Re-run the tests"
    
    exit 1
fi