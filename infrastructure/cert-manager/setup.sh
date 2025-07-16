#!/bin/bash
set -e

# Add cert-manager repository
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Create namespace
kubectl create namespace cert-manager

# Install cert-manager
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.12.0 \
  -f values.yaml

# Wait for cert-manager to be ready
kubectl wait --for=condition=available --timeout=300s deployment/cert-manager -n cert-manager
kubectl wait --for=condition=available --timeout=300s deployment/cert-manager-webhook -n cert-manager

# Create cluster issuers
kubectl apply -f issuer.yaml

# Install trust bundle in nodes
echo "Installing CA certificate in nodes..."
kubectl get secret internal-ca-key-pair -n cert-manager -o jsonpath='{.data.ca\.crt}' | base64 -d > /usr/local/share/ca-certificates/internal-ca.crt
update-ca-certificates

echo "cert-manager setup complete!"
