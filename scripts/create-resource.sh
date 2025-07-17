#!/bin/bash

# Load configuration
source "$(dirname "$0")/config.sh"

# Parse arguments
RESOURCE_TYPE=$1
RESOURCE_NAME=$2
ENVIRONMENT=${3:-development}

# Validate inputs
if [[ -z "$RESOURCE_TYPE" || -z "$RESOURCE_NAME" ]]; then
    echo "Usage: $0 <type> <name> [environment]"
    exit 1
fi

# Create resource from template
create_resource() {
    local template_dir="infrastructure/resources/${RESOURCE_TYPE}/templates"
    local instance_dir="infrastructure/resources/${RESOURCE_TYPE}/instances/${ENVIRONMENT}"
    
    # Create directory if not exists
    mkdir -p "$instance_dir"
    
    # Copy and process template
    envsubst < "${template_dir}/base.yaml" > "${instance_dir}/${RESOURCE_NAME}.yaml"
    
    # Create ArgoCD application
    envsubst < "templates/argocd-application.yaml" > \
        "infrastructure/argocd/applications/${ENVIRONMENT}/${RESOURCE_NAME}.yaml"
}

# Main
echo "Creating ${RESOURCE_TYPE} resource: ${RESOURCE_NAME} in ${ENVIRONMENT}"
create_resource
