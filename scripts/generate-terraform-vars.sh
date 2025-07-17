#!/bin/bash

# Load configuration
VALUES_FILE="infrastructure/values.infrastructure.yaml"
OUTPUT_FILE="terraform/terraform.tfvars"

# Convert YAML to Terraform variables
generate_tfvars() {
    echo "# Generated from values.infrastructure.yaml" > "$OUTPUT_FILE"
    
    # Cluster variables
    yq e '.infrastructure.cluster' "$VALUES_FILE" | while IFS=": " read -r key value; do
        echo "cluster_${key} = \"${value}\"" >> "$OUTPUT_FILE"
    done
    
    # Networking variables
    yq e '.infrastructure.networking' "$VALUES_FILE" | while IFS=": " read -r key value; do
        echo "network_${key} = \"${value}\"" >> "$OUTPUT_FILE"
    done
    
    # Application variables
    yq e '.infrastructure.applications' "$VALUES_FILE" | while IFS=": " read -r key value; do
        echo "app_${key} = \"${value}\"" >> "$OUTPUT_FILE"
    done
    
    # Storage variables
    yq e '.infrastructure.storage' "$VALUES_FILE" | while IFS=": " read -r key value; do
        echo "storage_${key} = \"${value}\"" >> "$OUTPUT_FILE"
    done
}

generate_tfvars
