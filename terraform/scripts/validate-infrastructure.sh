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
