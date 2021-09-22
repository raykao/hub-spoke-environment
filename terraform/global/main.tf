terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.70.0"
		}
	}
}

output "jumpbox_msi" {
	value = azurerm_user_assigned_identity.jumpbox.id
}