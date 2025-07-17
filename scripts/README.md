# Utility Scripts

## Overview
Collection of automation scripts for managing the infrastructure, security, and monitoring components.

## Scripts
```plaintext
.
├── update-configs.sh     # Update configuration from templates
├── setup-kyverno.sh      # Initialize Kyverno policies
├── setup-minio.sh        # Configure MinIO storage
├── trivy-scan.sh        # Security scanning
├── dependency-check.sh   # Dependency vulnerability checks
├── backup/
│   ├── backup-etcd.sh    # etcd snapshots
│   └── backup-state.sh   # Terraform state backup
└── monitoring/
    ├── setup-prometheus.sh
    └── setup-grafana.sh
```

## Prerequisites
```bash
# Required tools
jq       # JSON processing
yq       # YAML processing
kubectl  # Kubernetes CLI
helm     # Package manager
docker   # Container operations
mc       # MinIO client
```

## Common Operations
```bash
# Update all configurations
./update-configs.sh

# Full security scan
./trivy-scan.sh && ./dependency-check.sh

# Backup critical components
./backup/backup-etcd.sh
./backup/backup-state.sh
```

## Script Development
- Use shellcheck for validation
- Add help messages (-h flag)
- Include error handling
- Add logging
- Version control safe

## Environment Variables
```bash
# Required environment variables
KUBECTL_VERSION      # Kubernetes version
TERRAFORM_VERSION   # Terraform version
HELM_VERSION        # Helm version
MINIO_ACCESS_KEY    # MinIO access
MINIO_SECRET_KEY    # MinIO secret
```

## Best Practices
1. Always use configuration templates
2. Test in development first
3. Add proper error handling
4. Include cleanup functions
5. Document dependencies

## Troubleshooting
```bash
# Enable debug mode
export DEBUG=true
./script-name.sh

# Check logs
tail -f /var/log/script-name.log

# Validate configuration
./update-configs.sh --dry-run
```
