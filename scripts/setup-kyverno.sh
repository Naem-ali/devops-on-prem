#!/bin/bash

# Load configuration
source "$(dirname "$0")/config.sh"

KYVERNO_VERSION="${security_kyverno_version}"
POLICIES_PATH="${security_kyverno_policies_path}"

# Install Kyverno using Helm
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm upgrade --install kyverno kyverno/kyverno \
    --namespace security \
    --create-namespace \
    --version "${KYVERNO_VERSION}" \
    --set "excludeNamespaces={${security_kyverno_exclude_namespaces}}"

# Wait for Kyverno to be ready
kubectl wait --namespace security \
    --for=condition=ready pod \
    -l app.kubernetes.io/name=kyverno \
    --timeout=300s

# Apply default policies
if [ "${security_kyverno_default_policies_enabled}" = "true" ]; then
    echo "Applying default Kyverno policies..."
    kubectl apply -f "${POLICIES_PATH}/"
fi

# Apply custom policies if enabled
if [ "${security_kyverno_custom_policies_enabled}" = "true" ]; then
    echo "Applying custom Kyverno policies..."
    kubectl apply -f "${security_kyverno_custom_policies_path}/"
fi

echo "✅ Kyverno setup completed"
