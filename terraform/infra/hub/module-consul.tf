# module "consul" {
#   depends_on = [
#     module.dns
#   ]
# 	source = "../../modules/consul"
# 	user_msi = var.contributor_msi.id
# 	prefix = local.prefix
# 	resource_group = azurerm_resource_group.hub
# 	subnet_id = azurerm_subnet.consul.id
# 	admin_username = var.admin_username
# 	ssh_key = var.ssh_key
# 	vm_size = "Standard_F4s_v2"
# 	admin_subnet = azurerm_subnet.jumpbox
# 	vm_instances = 3
# }

# resource "azurerm_private_dns_a_record" "consul" {
#   name                = "consul"
#   zone_name           = azurerm_private_dns_zone.hub.name
#   resource_group_name = azurerm_resource_group.hub.name
#   ttl                 = 300
#   records             = [module.consul.lb.frontend_ip_configuration[0].private_ip_address]
# }