#!/bin/bash
set -e

# Add Helm repositories
helm repo add harbor https://helm.goharbor.io
helm repo add minio https://charts.min.io/
helm repo update

# Create namespace
kubectl create namespace infrastructure

# Install Harbor
helm install harbor harbor/harbor \
  --namespace infrastructure \
  -f registry/values.yaml

# Install MinIO
helm install minio minio/minio \
  --namespace infrastructure \
  -f minio/values.yaml

# Wait for deployments
kubectl wait --for=condition=available --timeout=300s deployment/harbor-core -n infrastructure
kubectl wait --for=condition=available --timeout=300s deployment/minio -n infrastructure

# Create robot account for CI
kubectl exec -n infrastructure deploy/harbor-core -- sh -c \
  'harbor-cli robot create --name ci-push --secret changeme --push frontend/*'

# Add local domains to /etc/hosts
echo "Adding local domains to /etc/hosts..."
sudo tee -a /etc/hosts <<EOF
127.0.0.1 registry.local
127.0.0.1 artifacts.local
EOF

echo "Infrastructure setup complete!"
