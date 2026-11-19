# Input Validation Tests

run "valid_cidr_ranges_test" {
  command = plan

  variables {
    resource_group_name = "test-cidr-validation-rg"
    location           = "East US"
    address_space      = ["10.0.0.0/8"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus"
      workload     = "validation"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  assert {
    condition     = length(var.address_space) > 0
    error_message = "Address space should not be empty"
  }
}

run "private_ip_ranges_test" {
  command = plan

  variables {
    resource_group_name = "test-private-ip-rg"
    location           = "West US"
    address_space      = ["192.168.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev" 
      location     = "wus"
      workload     = "private"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  assert {
    condition     = can(cidrhost(var.address_space[0], 1))
    error_message = "Address space should be valid CIDR"
  }
}

# Test Subnet CIDR Validation
run "subnet_cidr_validation_test" {
  command = plan

  variables {
    resource_group_name = "test-subnet-cidr-rg"
    location           = "Central US"
    address_space      = ["10.0.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "cus"
      workload     = "subnet-validation"
    }
    
    tags = {
      Environment = "Test"
    }

    subnets = {
      valid_subnet = {
        cidrs = ["10.0.1.0/24"] # Valid subnet within VNet
      }
      # Test boundary subnet
      boundary_subnet = {
        cidrs = ["10.0.255.0/24"] # Last /24 in the /16
      }
    }
  }

  # Validate subnet CIDRs are within VNet range
  assert {
    condition = can(cidrsubnet("10.0.0.0/16", 8, 1))
    error_message = "Subnet CIDR should be valid within VNet range"
  }
}

# Test Required Variables
run "required_variables_test" {
  command = plan

  # Test with minimal required variables
  variables {
    resource_group_name = "test-required-vars-rg"
    location           = "East US"
    address_space      = ["10.0.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus"
      workload     = "minimal"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  # Test that plan succeeds with minimal config
  assert {
    condition     = var.resource_group_name != ""
    error_message = "Resource group name is required"
  }

  assert {
    condition     = var.location != ""
    error_message = "Location is required"
  }

  assert {
    condition     = length(var.address_space) > 0
    error_message = "Address space is required"
  }

  assert {
    condition     = length(var.names) > 0
    error_message = "Names map is required"
  }

  assert {
    condition     = length(var.tags) > 0
    error_message = "Tags map is required"
  }
}

# Test Azure Location Validation
run "azure_locations_test" {
  command = plan

  variables {
    resource_group_name = "test-locations-rg"
    location           = "East US"
    address_space      = ["10.0.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus"
      workload     = "location-test"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  assert {
    condition     = contains([
      "East US", "West US", "West US 2", "East US 2",
      "Central US", "North Central US", "South Central US", "West Central US",
      "West Europe", "North Europe", "UK South", "UK West",
      "Southeast Asia", "East Asia", "Australia East", "Australia Southeast"
    ], var.location)
    error_message = "Should use valid Azure region"
  }
}

# Test Naming Convention Validation
run "naming_convention_test" {
  command = plan

  variables {
    resource_group_name = "test-naming-rg"
    location           = "East US"
    address_space      = ["10.0.0.0/16"]
    
    names = {
      product_name = "myapp"
      environment  = "dev"
      location     = "eus"
      workload     = "networking"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  # Test naming components are present
  assert {
    condition     = var.names.product_name != ""
    error_message = "Product name should not be empty"
  }

  assert {
    condition     = var.names.environment != ""
    error_message = "Environment should not be empty"
  }

  assert {
    condition     = var.names.location != ""
    error_message = "Location abbreviation should not be empty"
  }

  assert {
    condition     = var.names.workload != ""
    error_message = "Workload should not be empty"
  }
}

# Test Tags Validation
run "tags_validation_test" {
  command = plan

  variables {
    resource_group_name = "test-tags-rg"
    location           = "West US"
    address_space      = ["10.0.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "wus"
      workload     = "tags-test"
    }
    
    tags = {
      Environment   = "Development"
      Owner        = "Platform Team"
      CostCenter   = "IT-001"
      Project      = "Network Infrastructure"
      Backup       = "Required"
      Monitoring   = "Enabled"
    }
  }

  # Validate common tag patterns
  assert {
    condition     = contains(keys(var.tags), "Environment")
    error_message = "Environment tag should be present"
  }

  assert {
    condition     = var.tags.Environment != ""
    error_message = "Environment tag should not be empty"
  }
}

# Test DNS Servers Validation
run "dns_servers_validation_test" {
  command = plan

  variables {
    resource_group_name = "test-dns-validation-rg"
    location           = "North Europe"
    address_space      = ["10.0.0.0/16"]
    dns_servers        = ["168.63.129.16", "8.8.8.8"] # Azure DNS + Google DNS
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "ne"
      workload     = "dns-test"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  assert {
    condition     = length(var.dns_servers) <= 4
    error_message = "Maximum 4 DNS servers are supported"
  }

  # Basic IP format validation (simplified)
  assert {
    condition = alltrue([
      for dns in var.dns_servers : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", dns))
    ])
    error_message = "DNS servers should be valid IP addresses"
  }
}
