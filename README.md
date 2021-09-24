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

Notes:
- User Assigned Managed Identity: The Jumpbox is assigned a User MSI that has contributor rights over the initial resource groups (hub, spoke1, spoke2, spoke3)