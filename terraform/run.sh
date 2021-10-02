#! /bin/bash

CONFIG_FILE=terraform.tfvars
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else
	echo "Please update $FILE with appropirate values"
	exit 1
fi

terraform init
terraform plan -out tfplan
terraform apply tfplan

TF_OUTPUT_JSON="$(terraform output -json | jq -r . )"
SUB1="$(echo $TF_OUTPUT_JSON | jq -r .sub1SubscriptionId.value)"
echo "Set Azure Subscription to $SUB1"
az account set -s $SUB1

CLUSTER_RG_NAME="$(echo $TF_OUTPUT_JSON | jq -r .clusterRgName.value)"
CLUSTER_NAME="$(echo $TF_OUTPUT_JSON | jq -r .clusterName.value)"

echo "Get K8s credentials for cluster $CLUSTER_NAME in RG $CLUSTER_RG_NAME"
az aks get-credentials -g $CLUSTER_RG_NAME -n $CLUSTER_NAME

# Install CSI Drivers v1.6.0
curl -skSL https://raw.githubusercontent.com/kubernetes-sigs/azurefile-csi-driver/v1.6.0/deploy/install-driver.sh | bash -s v1.6.0 --
kubectl create -f https://raw.githubusercontent.com/kubernetes-sigs/azurefile-csi-driver/master/deploy/example/storageclass-azurefile-csi.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-sigs/azurefile-csi-driver/master/deploy/example/storageclass-azurefile-nfs.yaml

export STORAGE_ACCOUNT_NAME="$(echo $TF_OUTPUT_JSON | jq -r .storageAccountName.value)"
export STORAGE_ACCOUNT_ACCESS_KEY="$(echo $TF_OUTPUT_JSON | jq -r .storageAccountAccessKey.value)"
export FILESHARE_NAME="$(echo $TF_OUTPUT_JSON | jq -r .fileShareName.value)"
export STORAGE_ACCOUNT_SIZE="5120"
export UNIQUE_VOLUME_ID="azurefilecsiexampleuniqueid"

export PERSISTENT_VOLUME_NAME="pv-csi-example-name"
export PERSISENT_VOLUME_CLAIM_NAME="pvc-csi-example-claim-name"

# Create Static Credentials for PV
kubectl create secret generic azure-secret --from-literal azurestorageaccountname=$STORAGE_ACCOUNT_NAME --from-literal azurestorageaccountkey="$STORAGE_ACCOUNT_ACCESS_KEY" --type=Opaque

# Create the PV/PVC deployment by replacing values via envsubst command
envsubst \
	< ../example-files/cross-sub-pv-pvc.yaml \
	> tf-cross-sub-pv-pvc.yaml

# Apply/Deploy the PV/PVC
kubectl apply -f tf-cross-sub-pv-pvc.yaml

# Create the PV/PVC deployment by replacing values via envsubst command
envsubst \
	< ../example-files/deploy.yaml \
	> tf-deploy.yaml

# Apply/Deploy the "demo app"
kubectl apply -f tf-deploy.yaml



## Ingress Controller
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx \
		--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal"=true \
		--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-internal-subnet"=AksIlbSubnet \
		--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"=${prefix}${region}${clusterNumber} \
		--set controller.service.loadBalancerIp="10.1.4.4"

## Install Certbot
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.3 \
  --set installCRDs=true

