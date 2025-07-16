#!/bin/bash

# Load values from values.yaml
VALUES_FILE="$(dirname "$0")/../values.yaml"
if [ ! -f "$VALUES_FILE" ]; then
    echo "Error: values.yaml not found"
    exit 1
fi

# Function to update configuration files
update_configs() {
    # Update Terraform variables
    envsubst < templates/terraform.tfvars.template > terraform/environment.tfvars
    
    # Update K3s config
    envsubst < templates/k3s-config.yaml.template > infrastructure/k3s/config.yaml
    
    # Update ArgoCD values
    envsubst < templates/argocd-values.yaml.template > infrastructure/argocd/values.yaml
    
    # Update Helm values
    envsubst < templates/helm-values.yaml.template > helm/values/production.yaml
    
    echo "Configuration files updated successfully!"
}

# Export values as environment variables
eval $(yq e -o=shell values.yaml)

# Update all configuration files
update_configs
