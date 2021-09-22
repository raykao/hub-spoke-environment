output sub1SubscriptionId {
	value = var.sub1SubscriptionId
}

output sub2SubscriptionId {
	value = var.sub2SubscriptionId
}

output hub {
	value = {
		jumpboxip = module.hub-jumpbox.ip
		jumpboxfqdn = module.hub-jumpbox.fqdn
		ssh	= "ssh -p 2022 ${local.admin_username}@${module.hub-jumpbox.ip}"
	}
}

output spoke1 {
	value = {
		aksCluster = {
			clusterName = azurerm_kubernetes_cluster.spoke1.name
			clusterRgName = azurerm_resource_group.spoke1.name
		}
	}
}

output spoke2 {
	value = {
		storageAccountName = azurerm_storage_account.spoke2.name
		fileShareName = azurerm_storage_share.spoke2.name
		# storageAccountAccessKey = {
		# 	value = azurerm_storage_account.spoke2.primary_access_key
		# 	sensitive = true
		# }
		storageServerFQDN = azurerm_private_endpoint.storage-spoke2.private_dns_zone_configs[0].record_sets[0].fqdn
	}
}

output spoke4 {
	value = {
		jumpboxip = module.spoke4-jumpbox.ip
		jumpboxfqdn = module.spoke4-jumpbox.fqdn
		ssh	= "ssh -p 2022 ${local.admin_username}@${module.spoke4-jumpbox.ip}"
	}
}