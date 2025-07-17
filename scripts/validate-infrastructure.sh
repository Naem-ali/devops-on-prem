#!/bin/bash
set -e

echo "Validating infrastructure recovery..."

# Check node status
kubectl get nodes -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' | grep -q "True"

# Verify core namespaces
NAMESPACES=("vault" "monitoring" "infrastructure" "argocd")
for ns in "${NAMESPACES[@]}"; do
    kubectl get namespace "$ns" -o jsonpath='{.status.phase}' | grep -q "Active"
done

# Check critical services
kubectl -n vault wait --for=condition=Ready pod -l app.kubernetes.io/name=vault --timeout=300s
kubectl -n monitoring wait --for=condition=Ready pod -l app=prometheus --timeout=300s
kubectl -n infrastructure wait --for=condition=Ready pod -l app=harbor --timeout=300s

# Verify storage
kubectl get storageclass local-path -o jsonpath='{.metadata.name}'

# Check networking
kubectl -n infrastructure get svc harbor -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

echo "Infrastructure validation complete!"

# Validate infrastructure values
echo "Validating infrastructure values..."
yq eval . infrastructure/values.infrastructure.yaml >/dev/null

# Validate Terraform configuration
echo "Validating Terraform configuration..."
cd terraform
terraform validate

# Check for required tools
echo "Checking required tools..."
command -v kubectl >/dev/null 2>&1 || { echo "kubectl required but not installed"; exit 1; }
command -v helm >/dev/null 2>&1 || { echo "helm required but not installed"; exit 1; }

# Check cluster connectivity
echo "Checking cluster connectivity..."
kubectl cluster-info >/dev/null 2>&1 || { echo "Cannot connect to cluster"; exit 1; }

echo "Validation complete!"
