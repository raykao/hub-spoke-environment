resource "azurerm_resource_group" "spoke1" {
	provider = azurerm.sub1
  	name = "${local.prefix}spoke1-rg"
  	location = var.location1
}

resource "azurerm_virtual_network" "spoke1" {
	provider = azurerm.sub1
	name = "${local.prefix}spoke1-vnet"
	resource_group_name = azurerm_resource_group.spoke1.name
	location = azurerm_resource_group.spoke1.location
	address_space       = [var.spoke1_address_space]
}

resource azurerm_subnet aks {
	provider = azurerm.sub1
	name = "AksSubnet"
	resource_group_name  = azurerm_resource_group.spoke1.name
	virtual_network_name = azurerm_virtual_network.spoke1.name
	address_prefixes     = [cidrsubnet(azurerm_virtual_network.spoke1.address_space[0], 6, 0)]
}

resource "azurerm_virtual_network_peering" "spoke1tohub" {
	provider = azurerm.sub1
	name                      = "spoke1tohub"
	resource_group_name       = azurerm_resource_group.spoke1.name
	virtual_network_name      = azurerm_virtual_network.spoke1.name
	remote_virtual_network_id = azurerm_virtual_network.hub.id
}

resource azurerm_kubernetes_cluster spoke1 {
	provider = azurerm.sub1
	name                = "${local.prefix}spoke1cluster"
	location            = azurerm_resource_group.spoke1.location
	resource_group_name = azurerm_resource_group.spoke1.name
	
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

resource "azurerm_dns_zone" "spoke1" {
	provider = azurerm.sub1
	name                = "spoke1.${var.domain}"
	resource_group_name = azurerm_resource_group.spoke1.name
}