# Virtual Network Module Tests

run "basic_vnet_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-basic-rg"
    location           = "East US"
    address_space      = ["10.0.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus"
      workload     = "vnet"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Basic VNet Test"
    }
  }

  assert {
    condition     = output.vnet.address_space[0] == "10.0.0.0/16"
    error_message = "Virtual network address space should be 10.0.0.0/16"
  }

  assert {
    condition     = output.vnet.location == "East US"
    error_message = "Virtual network should be created in East US"
  }

  assert {
    condition     = length(output.vnet.name) > 0
    error_message = "Virtual network name should not be empty"
  }
}

run "vnet_with_subnets_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-subnets-rg"
    location           = "West US 2"
    address_space      = ["10.1.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "wus2"
      workload     = "vnet"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Subnet Test"
    }

    subnets = {
      web = {
        cidrs                         = ["10.1.1.0/24"]
        create_network_security_group = true
        configure_nsg_rules           = true
        allow_internet_outbound       = true
        allow_vnet_inbound           = true
      }
      app = {
        cidrs                         = ["10.1.2.0/24"]
        create_network_security_group = true
        configure_nsg_rules           = true
        allow_vnet_inbound           = true
        allow_vnet_outbound          = true
      }
    }
  }

  assert {
    condition     = length(output.subnets) == 2
    error_message = "Should create exactly 2 subnets"
  }

  assert {
    condition     = contains(keys(output.subnets), "web")
    error_message = "Web subnet should be created"
  }

  assert {
    condition     = contains(keys(output.subnets), "app")
    error_message = "App subnet should be created"
  }

  assert {
    condition     = output.subnets["web"].address_prefixes[0] == "10.1.1.0/24"
    error_message = "Web subnet should have correct CIDR range"
  }

  assert {
    condition     = output.subnets["app"].address_prefixes[0] == "10.1.2.0/24"
    error_message = "App subnet should have correct CIDR range"
  }

  assert {
    condition     = length(output.subnet_nsg_ids) == 2
    error_message = "Both subnets should have NSG associations"
  }
}

run "vnet_with_route_tables_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-routes-rg"
    location           = "Central US"
    address_space      = ["10.2.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "cus"
      workload     = "vnet"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Route Table Test"
    }

    route_tables = {
      custom_routes = {
        bgp_route_propagation_enabled = false
        use_inline_routes             = true
        routes = {
          to_firewall = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "VirtualAppliance"
            next_hop_in_ip_address = "10.2.100.4"
          }
        }
      }
    }

    subnets = {
      protected = {
        cidrs                   = ["10.2.1.0/24"]
        route_table_association = "custom_routes"
      }
    }
  }

  assert {
    condition     = length(output.route_tables) == 1
    error_message = "Should create exactly 1 route table"
  }

  assert {
    condition     = contains(keys(output.route_tables), "custom_routes")
    error_message = "Custom route table should be created"
  }
}

run "invalid_cidr_test" {
  command = plan

  variables {
    resource_group_name = "test-invalid-cidr-rg"
    location           = "East US"
    address_space      = ["10.0.0.0/33"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus"
      workload     = "vnet"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  expect_failures = [
    var.address_space
  ]
}

run "empty_address_space_test" {
  command = plan

  variables {
    resource_group_name = "test-empty-space-rg"
    location           = "East US"
    address_space      = []
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus"
      workload     = "vnet"
    }
    
    tags = {
      Environment = "Test"
    }
  }

  expect_failures = [
    var.address_space
  ]
}

run "dns_servers_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-dns-rg"
    location           = "North Central US"
    address_space      = ["10.3.0.0/16"]
    dns_servers        = ["8.8.8.8", "8.8.4.4"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "ncus"
      workload     = "vnet"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "DNS Test"
    }
  }

  assert {
    condition     = length(output.vnet.dns_servers) == 2
    error_message = "Should have 2 DNS servers configured"
  }

  assert {
    condition     = contains(output.vnet.dns_servers, "8.8.8.8")
    error_message = "Should contain primary DNS server"
  }

  assert {
    condition     = contains(output.vnet.dns_servers, "8.8.4.4")
    error_message = "Should contain secondary DNS server"
  }
}
