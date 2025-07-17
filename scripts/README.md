# Utility Scripts

Collection of automation and management scripts.

## Available Scripts
- **update-configs.sh**: Update configuration files from templates
- **setup-kyverno.sh**: Initialize Kyverno policies
- **trivy-scan.sh**: Run security scans
- **dependency-check.sh**: Check dependencies for vulnerabilities
- **setup-minio.sh**: Configure MinIO storage

## Usage
All scripts source configuration from `values.yaml`:
```bash
# Update configurations
./update-configs.sh

# Run security scan
./trivy-scan.sh
```

## Requirements
- bash 4+
- yq
- kubectl
- docker (for scans)
