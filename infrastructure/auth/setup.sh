#!/bin/bash
set -e

# Add Helm repos
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Create namespace
kubectl create namespace auth

# Install Keycloak
helm install keycloak bitnami/keycloak \
  --namespace auth \
  -f keycloak-values.yaml

# Wait for Keycloak to be ready
kubectl wait --for=condition=available --timeout=300s deployment/keycloak -n auth

# Apply RBAC configuration
kubectl apply -f k8s-rbac.yaml

# Create realm configuration
kubectl apply -f realm-config.yaml

# Add local domain to /etc/hosts
echo "127.0.0.1 auth.local" | sudo tee -a /etc/hosts

echo "Authentication infrastructure setup complete!"
