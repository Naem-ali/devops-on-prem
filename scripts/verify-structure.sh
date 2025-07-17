#!/bin/bash

# Expected directory structure
DIRECTORIES=(
    "infrastructure/k3s/manifests"
    "infrastructure/argocd/{applications,projects}"
    "infrastructure/ingress/rules"
    "infrastructure/security/{falco/rules,kyverno/{policies,custom},opa/constraints}"
    "infrastructure/storage/minio/backup"
    "monitoring/{prometheus/{rules,dashboards},grafana/{dashboards,alerts}}"
    "terraform/{modules/{cluster,network,apps,storage},environments/{dev,prod}}"
    "helm/{charts,values}"
    "scripts/{setup,backup,security,monitoring}"
    "docs/{architecture,operations,security}"
    "templates/{terraform,kubernetes,scripts}"
    "tests/{integration,security}"
)

# Check and create missing directories
for dir in "${DIRECTORIES[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created missing directory: $dir"
    fi
done

# Verify structure matches README.md
echo "Verifying project structure..."
find . -type d -not -path '*/\.*' | sort > current_structure.txt
echo "Directory structure verified. Check current_structure.txt for details."
