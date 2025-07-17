#!/bin/bash

set -e

# Configuration
INFRASTRUCTURE_VALUES="infrastructure/values.infrastructure.yaml"
TERRAFORM_DIR="terraform"

# Validate values file
if [ ! -f "$INFRASTRUCTURE_VALUES" ]; then
    echo "Error: values.infrastructure.yaml not found"
    exit 1
fi

# Generate Terraform variables
echo "Generating Terraform variables..."
./scripts/generate-terraform-vars.sh

# Initialize Terraform
echo "Initializing Terraform..."
cd "$TERRAFORM_DIR"
terraform init

# Plan changes
echo "Planning infrastructure changes..."
terraform plan -out=tfplan

# Prompt for confirmation
read -p "Do you want to apply these changes? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Apply changes
    echo "Applying infrastructure changes..."
    terraform apply tfplan
    
    # Verify deployment
    echo "Verifying deployment..."
    kubectl get nodes
    kubectl get pods -A
    
    echo "Infrastructure deployment complete!"
else
    echo "Deployment cancelled"
    exit 0
fi
