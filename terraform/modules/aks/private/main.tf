variable "prefix" {
	type = string
}

variable "resource_group" {
}

variable "subnet_id" {
	type = string
}

variable "type" {
	type = string
	default = "private"
}

variable "user_msi_id" {
  type = string
}

variable "private_dns_zone_id" {
	type = string
}

variable "suffix" {
  type = string
}

locals {
  cluster_name = "${var.prefix}-${var.type}-cluster-${var.suffix}"
}

resource azurerm_kubernetes_cluster default {

	name                = local.cluster_name
	location            = var.resource_group.location
	resource_group_name = var.resource_group.name
	
	dns_prefix = local.cluster_name
	# dns_prefix_private_cluster = "${var.prefix}-${var.type}-aks"
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
		user_assigned_identity_id = var.user_msi_id
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