# Multi Subscription Hub/Spoke Deployment

This is a demo environment to setup a baseline to deploy a multi-subscription hub-spoke infrastructure on Azure.

## How to use
- go to ```${repo_root}/terraform/infra/``` 
- copy the ```terraform.tfvars.example``` to ```terraform.tfvars```
- edit/add the correct values in ```terraform.tfvars``` file
- ensure you're logged into your Azure account (```az login```)
- run ```terraform```
	- ``` terraform init && terraform plan -out tfplan && terraform apply tfplan```

## Jumpbox configs
```${repo_root}/terraform/infra/modules/jumpbox/```

- Jumpbox Azure VM Configs ```${repo_root}/terraform/infra/modules/jumpbox/main.tf```
- Jumpbox OS configs ```${repo_root}/terraform/infra/modules/jumpbox/config/jumpbox-cloud-init.yaml```
- sshd port has been changed to 2022 not default 22
- xrdp port has been changed to 2023 not default 3389
- NSG:
	- http/https ports 80/443 are open on NSG and used to get letsencrypt TLS certificates (allow all inbound from internet)
	- ssh/xrdp ports (2022/2023) have been locked down to your deployment machine's publicIP address using ```https://api.ipify.org``` to determine your Public IP address

Notes:
- User Assigned Managed Identity: The Jumpbox is assigned a User MSI that has contributor rights over the initial resource groups (hub, spoke1, spoke2, spoke3)

### Setting up XRDP
xrdp is installed by default (see Jumpbox OS Configs above).  However you still need to enter a password for your default user account or create one that can login via password as XRDP requires password auth for the GUI session.  To do so ```ssh``` into your your jumpbox in the hub network. run:

```bash
## Example Only
ssh -p 2022 -i ${path.module}/certs/${terraform.workspace}/global/id_rsa ${local.admin_username}@${module.hub.jumpbox.ip_address}

## You can get this command as it's been added to Terraform outputs for convenience
terraform output

## Output result example:
hub = {
  "jumpbox" = {
    "fqdn" = "abcde.azureregion.cloudapp.azure.com"
    "ip_address" = "52.xxx.xxx.102"
  }
  "ssh" = "ssh -p 2022 -i ./certs/default/global/id_rsa admin_username@52.xxx.xxx.102"
  "xrdp_tunnel" = "ssh -L 3389:localhost:3389 -p 2022 -i ./certs/default/global/id_rsa admin_username@52.xxx.xxx.102"
}
```