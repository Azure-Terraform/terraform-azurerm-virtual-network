# Advanced Virtual Network Tests

run "vnet_peering_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-peering-rg"
    location           = "South Central US"
    address_space      = ["10.4.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "scus"
      workload     = "hub"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Peering Test"
    }

    peers = {
      spoke_vnet = {
        id                           = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/spoke-rg/providers/Microsoft.Network/virtualNetworks/spoke-vnet"
        allow_virtual_network_access = true
        allow_forwarded_traffic      = true
        allow_gateway_transit        = false
        use_remote_gateways          = false
      }
    }
  }

  assert {
    condition     = output.vnet != null
    error_message = "Virtual network should be created for peering tests"
  }
}

# Test AKS Subnets Configuration
run "aks_subnets_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-aks-rg"
    location           = "East US 2"
    address_space      = ["10.5.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "eus2"
      workload     = "aks"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "AKS Test"
    }

    aks_subnets = {
      aks_nodes = {
        subnet_info = {
          cidrs = ["10.5.1.0/24"]
          create_network_security_group = true
          configure_nsg_rules           = true
          allow_vnet_inbound           = true
          allow_vnet_outbound          = true
        }
        route_table = {
          bgp_route_propagation_enabled = false
          routes = {
            to_internet = {
              address_prefix = "0.0.0.0/0"
              next_hop_type  = "Internet"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = output.aks != null
    error_message = "AKS subnet configuration should be created"
  }
}

# Test Multiple Address Spaces
run "multiple_address_spaces_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-multi-addr-rg"
    location           = "West Central US"
    address_space      = ["10.6.0.0/16", "172.16.0.0/12"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "wcus"
      workload     = "multi"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Multiple Address Spaces Test"
    }
  }

  assert {
    condition     = length(output.vnet.address_space) == 2
    error_message = "Should have 2 address spaces configured"
  }

  assert {
    condition     = contains(output.vnet.address_space, "10.6.0.0/16")
    error_message = "Should contain first address space"
  }

  assert {
    condition     = contains(output.vnet.address_space, "172.16.0.0/12")
    error_message = "Should contain second address space"
  }
}

# Test Service Endpoints
run "service_endpoints_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-endpoints-rg"
    location           = "Canada Central"
    address_space      = ["10.7.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "cac"
      workload     = "endpoints"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Service Endpoints Test"
    }

    subnets = {
      data_subnet = {
        cidrs = ["10.7.1.0/24"]
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault"
        ]
        create_network_security_group = true
        configure_nsg_rules           = true
        allow_vnet_inbound           = true
        allow_vnet_outbound          = true
      }
    }
  }

  assert {
    condition     = contains(keys(output.subnets), "data_subnet")
    error_message = "Data subnet should be created"
  }
}

# Test Subnet Delegations
run "subnet_delegations_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-delegations-rg"
    location           = "Australia East"
    address_space      = ["10.8.0.0/16"]
    
    names = {
      product_name = "test"
      environment  = "dev"
      location     = "ae"
      workload     = "delegations"
    }
    
    tags = {
      Environment = "Test"
      Purpose     = "Subnet Delegations Test"
    }

    subnets = {
      app_service_subnet = {
        cidrs = ["10.8.1.0/24"]
        delegations = {
          app_service_plan = {
            name = "Microsoft.Web/serverFarms"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action"
            ]
          }
        }
        create_network_security_group = false
      }
    }
  }

  assert {
    condition     = contains(keys(output.subnets), "app_service_subnet")
    error_message = "App Service subnet should be created"
  }
}

# Test Large Address Space
run "large_address_space_test" {
  command = apply

  variables {
    resource_group_name = "test-vnet-large-rg"
    location           = "UK South"
    address_space      = ["172.16.0.0/12"]
    
    names = {
      product_name = "test"
      environment  = "prod"
      location     = "uks"
      workload     = "enterprise"
    }
    
    tags = {
      Environment = "Production"
      Purpose     = "Large Scale Test"
      Criticality = "High"
    }

    subnets = {
      tier1 = {
        cidrs = ["172.16.1.0/24"]
      }
      tier2 = {
        cidrs = ["172.16.2.0/24"]
      }
      tier3 = {
        cidrs = ["172.16.3.0/24"]
      }
      management = {
        cidrs = ["172.16.100.0/24"]
        create_network_security_group = true
        configure_nsg_rules           = true
        allow_vnet_inbound           = true
        allow_vnet_outbound          = true
      }
    }
  }

  assert {
    condition     = length(output.subnets) == 4
    error_message = "Should create 4 subnets in large deployment"
  }

  assert {
    condition     = output.vnet.address_space[0] == "172.16.0.0/12"
    error_message = "Should use large address space"
  }
}
