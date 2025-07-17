#!/bin/bash

# Load configuration
source "$(dirname "$0")/config.sh"

# Install MinIO client
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/

# Configure MinIO client
mc alias set minio http://${storage_minio_endpoint}:9000 ${storage_minio_access_key} ${storage_minio_secret_key}

# Create bucket for Terraform state
mc mb minio/terraform-state

# Set bucket policy for versioning
mc version enable minio/terraform-state

echo "✅ MinIO setup completed for Terraform state storage"
