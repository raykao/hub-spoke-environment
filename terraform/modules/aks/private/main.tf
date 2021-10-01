variable "prefix" {
	type = string
}

variable "resource_group" {
}


variable "region" {
	type = string
}

variable "subnet_id" {
	type = string
}

variable "type" {
	type = string
	default = "private"
}

variable "private_dns_zone_id" {
	type = string
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-example-identity"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
}

resource "azurerm_role_assignment" "aks" {
  scope                = var.private_dns_zone_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "time_sleep" "wait_for_role_assignment" {
  depends_on = [
    azurerm_role_assignment.aks,
  ]

  create_duration = "30s"
}

resource azurerm_kubernetes_cluster default {
	depends_on = [
    time_sleep.wait_for_role_assignment
  ]

	name                = "${var.prefix}-${var.region}-${var.type}-cluster"
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name
	
	dns_prefix = "${var.prefix}-${var.region}-${var.type}-aks"
	# dns_prefix_private_cluster = "${var.prefix}-${var.region}-${var.type}-aks"
	private_cluster_enabled = true
	private_dns_zone_id     = var.private_dns_zone_id

	default_node_pool {
		name                = "defaultnp"
		vm_size             = "Standard_D4s_v3"
		vnet_subnet_id      = var.subnet_id
		node_count = 3
	}

	identity {
		type = "UserAssigned"
		user_assigned_identity_id = azurerm_user_assigned_identity.aks.id
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
