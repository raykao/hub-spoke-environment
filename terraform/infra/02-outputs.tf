output subId1 {
	value = var.subId1
}

output subId2 {
	value = var.subId2
}

output hub {
	value = {
		jumpbox = module.hub.jumpbox
	}
}

# output spoke1 {
# 	value = {
# 		aksCluster = {
# 			clusterName = azurerm_kubernetes_cluster.spoke1.name
# 			clusterRgName = azurerm_resource_group.spoke1.name
# 		}
# 	}
# }

# output spoke2 {
# 	value = {
# 		storageAccountName = azurerm_storage_account.spoke2.name
# 		fileShareName = azurerm_storage_share.spoke2.name
# 		# storageAccountAccessKey = {
# 		# 	value = azurerm_storage_account.spoke2.primary_access_key
# 		# 	sensitive = true
# 		# }
# 		storageServerFQDN = azurerm_private_endpoint.storage-spoke2.private_dns_zone_configs[0].record_sets[0].fqdn
# 	}
# }

# output spoke4 {
# 	value = {
# 		jumpboxip = module.spoke4-jumpbox.ip
# 		jumpboxfqdn = module.spoke4-jumpbox.fqdn
# 		ssh	= "ssh -p 2022 ${local.admin_username}@${module.spoke4-jumpbox.ip}"
# 	}
# }