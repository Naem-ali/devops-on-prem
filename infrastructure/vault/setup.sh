#!/bin/bash
set -e

# Add HashiCorp helm repo
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# Create namespace
kubectl create namespace vault

# Install Vault
helm install vault hashicorp/vault \
  --namespace vault \
  -f values.yaml

# Wait for Vault pods
kubectl -n vault wait --for=condition=Ready pod/vault-0
kubectl -n vault wait --for=condition=Ready pod/vault-1
kubectl -n vault wait --for=condition=Ready pod/vault-2

# Initialize Vault
kubectl -n vault exec vault-0 -- vault operator init \
  -key-shares=5 \
  -key-threshold=3 \
  -format=json > vault-keys.json

# Store keys securely and unseal Vault
VAULT_KEYS=$(cat vault-keys.json | jq -r '.unseal_keys_b64[]')
VAULT_ROOT_TOKEN=$(cat vault-keys.json | jq -r '.root_token')

# Unseal all Vault pods
for key in $VAULT_KEYS; do
  for pod in vault-0 vault-1 vault-2; do
    kubectl -n vault exec $pod -- vault operator unseal $key
  done
done

# Configure Kubernetes auth
kubectl -n vault create configmap vault-auth-config --from-file=setup.sh=auth-config.yaml
kubectl -n vault exec vault-0 -- /bin/sh /vault/config/setup.sh

# Store example secrets
kubectl -n vault exec vault-0 -- vault kv put secret/huggingface/config \
  api_key="default-api-key" \
  db_password="default-password"

echo "Vault setup complete!"
