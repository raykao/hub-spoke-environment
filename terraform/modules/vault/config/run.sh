#! /bin/bash

export IP_ADDRESS=$(hostname -I)
export VAULT_API_ADDR="https://$IP_ADDRESS:8200"

vault server -config=/opt/vault/config/server.hcl