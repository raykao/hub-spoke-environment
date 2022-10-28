locals {
  cluster_name = "${var.prefix}-prom-${var.suffix}"
}

resource azurerm_kubernetes_cluster default {

	name                = local.cluster_name
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name
	
	dns_prefix = local.cluster_name

	private_cluster_enabled = true
	private_dns_zone_id     = var.private_dns_zone_id

	default_node_pool {
		name                = "defaultnp"
		vm_size             = var.vm_size
		vnet_subnet_id      = var.subnet_id
		node_count = 3
	}

	identity {
		type = "UserAssigned"
		identity_ids = [
			var.user_msi_id
		]
	}

	role_based_access_control_enabled = true

	azure_active_directory_role_based_access_control {
	  managed = true
	  azure_rbac_enabled = true
	  admin_group_object_ids = var.admin_group_object_ids
	}

	linux_profile {
		admin_username = var.admin_username
		ssh_key {
		key_data = file(var.admin_public_key)
		}
	}

	oms_agent {
		log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
	}

	network_profile {
		network_plugin     = "azure"
		network_policy     = "calico"
		load_balancer_sku  = "standard"
		service_cidr       = "192.168.0.0/24"
		dns_service_ip     = "192.168.0.10"
		docker_bridge_cidr = "172.17.0.1/16"
	}

	lifecycle {
	  ignore_changes = [
		kubernetes_version
	  ]
	}
}