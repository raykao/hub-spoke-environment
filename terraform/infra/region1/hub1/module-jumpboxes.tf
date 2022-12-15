resource "azurerm_firewall_policy_rule_collection_group" "jumpbox" {
	name               = "jumpbox-fwpolicy-rcg"
	firewall_policy_id = var.firewall_policy_id
  	# firewall_policy_id = azurerm_firewall_policy.hub.id
  	priority           = 200
	
	network_rule_collection {
		name = "allow-jumpbox-all-outbound"
		priority = 100
		action = "Allow"

		rule {
			name = "all"
			protocols = ["Any"]
			source_addresses = [
				azurerm_subnet.jumpbox.address_prefixes[0]
			]
			destination_ports = ["*"]
			destination_addresses = ["*"]
		} 
	}
}

module "win11jumpbox" {
  source = "../../modules/jumpbox/windows"

  prefix = local.prefix

  sku = "Standard_D4s_v3"

  subnet_id      = azurerm_subnet.jumpbox.id
  resource_group = azurerm_resource_group.hub

  admin_username = var.admin_username
}

resource "azurerm_firewall_policy_rule_collection_group" "windowsjumpbox" {
	name               = "windows-jumpbox-fwpolicy-rcg"
  	firewall_policy_id = var.firewall_policy_id
	# firewall_policy_id = azurerm_firewall_policy.hub.id
  	priority           = 300
	

	nat_rule_collection {
		name     = "jumpbox-rdp"
		priority = 300
		action   = "Dnat"
		rule {
			name                = "rdp"
			protocols           = ["TCP"]
			source_addresses    = [
                local.myip
            ]
			destination_address = var.firewall_ip
			destination_ports   = [
                "53389"
            ]
			translated_address  = module.win11jumpbox.private_ip_address
			translated_port     = "3389"
		}
	}
}

module "jumpbox" {	
	source = "../../modules/jumpbox/linux"
	prefix = local.name
	resource_group = azurerm_resource_group.hub
	subnet_id = azurerm_subnet.jumpbox.id
	admin_username = var.admin_username
	admin_email = var.admin_email
	public_key = var.public_key
	vm_size = "Standard_F16s_v2"
}

resource "azurerm_firewall_policy_rule_collection_group" "linuxjumpbox" {
	name               = "linux-jumpbox-fwpolicy-rcg"
  	firewall_policy_id = var.firewall_policy_id
	# firewall_policy_id = azurerm_firewall_policy.hub.id
  	priority           = 301
	

	nat_rule_collection {
		name     = "jumpbox-ssh"
		priority = 300
		action   = "Dnat"
		rule {
			name                = "ssh"
			protocols           = ["TCP"]
			source_addresses    = [
                local.myip
            ]
			destination_address = var.firewall_ip
			destination_ports   = [
                "52022"
            ]
			translated_address  = module.jumpbox.private_ip_address
			translated_port     = "22"
		}
	}
}
