output "contributor_msi" {
	value = azurerm_user_assigned_identity.contributor.principal_id
}