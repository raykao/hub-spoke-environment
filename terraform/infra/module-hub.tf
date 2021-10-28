module hub {
	source = "./hub"

	providers = {
		azurerm = azurerm.sub1
	}
	prefix = "${local.prefix}hub"
	location = "centralus"
	contributor_msi = module.global.contributor_msi
	admin_username = local.admin_username
	ssh_key = module.global.public_key
	address_space = cidrsubnet(var.global_address_space, 8, 0)
	global_address_space = var.global_address_space
	domain = var.domain
	admin_email = var.admin_email
}

resource "azurerm_virtual_hub_connection" "hub" {
	provider = azurerm.sub1
  name                      = "canadacentral-hub-vhub"
  virtual_hub_id            = module.global.virtual_hubs["canadacentral"].id
  remote_virtual_network_id = module.hub.vnet.id
	internet_security_enabled = false
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [
		module.hub
	]

  create_duration = "60s"
}

resource "null_resource" "upload-id_rsa" {
  depends_on =  [ 
		time_sleep.wait_60_seconds
	]
  
  provisioner "local-exec" {
      command = "scp -P 2022 -o StrictHostKeyChecking=no -q -i ${path.module}/certs/${terraform.workspace}/global/id_rsa ${path.module}/certs/${terraform.workspace}/global/id_rsa ${local.admin_username}@${module.hub.jumpbox.ip_address}:~/.ssh"
  }
}