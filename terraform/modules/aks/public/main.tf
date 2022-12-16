resource azurerm_kubernetes_cluster spoke1 {
	name                = "${local.prefix}spoke1cluster"
	location            = azurerm_resource_group.spoke.location
	resource_group_name = azurerm_resource_group.spoke.name
	
	dns_prefix          = "${local.prefix}spoke1cluster"

	default_node_pool {
		name                = "defaultnp"
		vm_size             = "Standard_D4s_v3"
		vnet_subnet_id      = azurerm_subnet.aks.id
		node_count = 3
	}

	identity {
		type = "SystemAssigned"
	}


	network_profile {
		network_plugin     = "azure"
		network_policy     = "calico"
		load_balancer_sku  = "standard"
		service_cidr       = "192.168.0.0/24"
		dns_service_ip     = "192.168.0.10"
		docker_bridge_cidr = "172.17.0.1/16"
	}

	addon_profile {
		kube_dashboard {
		enabled = false
		}
	}
}
