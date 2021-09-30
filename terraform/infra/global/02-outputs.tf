output "prefix" {
	value = var.prefix
}

output "resource_group" {
	value = azurerm_resource_group.global
}

output "contributor_msi" {
	value = azurerm_user_assigned_identity.contributor
}

output "public_key" {
	value = local_file.id_rsa-pub.content
}

output "private_dns_zone" {
	value = azurerm_private_dns_zone.global
}

output "admin_email" {
	value = var.admin_email
}