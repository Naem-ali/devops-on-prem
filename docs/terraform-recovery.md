# Infrastructure Recovery via Terraform

## Prerequisites
- MinIO credentials
- DNS configuration
- Network access
- SSL certificates

## Recovery Steps

1. **Infrastructure State Recovery**
```bash
# Set up MinIO credentials
export AWS_ACCESS_KEY_ID=<minio-access-key>
export AWS_SECRET_ACCESS_KEY=<minio-secret-key>

# Recover latest state
aws s3 cp s3://terraform-state/infrastructure/terraform.tfstate . \
  --endpoint-url http://minio.infrastructure:9000

# Verify state
terraform show
```

2. **Infrastructure Provisioning**
```bash
# Initialize Terraform
terraform init

# Verify plan
terraform plan

# Apply infrastructure
terraform apply -auto-approve
```

3. **Post-Recovery Tasks**
```bash
# Verify core components
kubectl get nodes
kubectl get ns

# Check infrastructure services
kubectl get pods -n infrastructure
kubectl get pods -n vault
kubectl get pods -n monitoring
```

## Component Recovery Order

1. **Base Infrastructure**
```hcl
module "k3s_cluster" {
  # Basic cluster setup
}

module "networking" {
  # Network configuration
}
```

2. **Core Services**
```hcl
module "storage" {
  # MinIO and persistent volumes
}

module "vault" {
  # Secret management
}
```

3. **Support Services**
```hcl
module "monitoring" {
  # Prometheus, Grafana, Loki
}

module "registry" {
  # Harbor container registry
}
```

4. **Application Platform**
```hcl
module "argocd" {
  # GitOps deployment
}

module "cert_manager" {
  # Certificate management
}
```

## Validation Steps

1. **Infrastructure Validation**
- Network connectivity
- Storage provisioning
- Node health

2. **Service Validation**
- Vault unsealed and accessible
- Registry operational
- Monitoring stack functional

3. **Application Validation**
- ArgoCD synced
- Applications deployed
- Ingress functional

## Common Issues

1. **State Corruption**
```bash
# Recover from backup
aws s3 cp s3://terraform-state/backups/terraform-<timestamp>.tfstate terraform.tfstate \
  --endpoint-url http://minio.infrastructure:9000
```

2. **Resource Dependencies**
```hcl
depends_on = [
  module.k3s_cluster,
  module.networking
]
```

3. **Provider Configuration**
```bash
# Verify provider access
terraform providers

# Reinitialize if needed
terraform init -reconfigure
```

## Recovery Time Estimation

| Component          | Time    | Dependencies |
|-------------------|---------|--------------|
| Base Infrastructure| 15-20m  | None         |
| Core Services     | 10-15m  | Base         |
| Support Services  | 15-20m  | Core         |
| Applications      | 20-30m  | All          |

Total Recovery: 60-85 minutes


## Recovery Checklist

- [ ] State recovered
- [ ] Infrastructure provisioned
- [ ] Core services running
- [ ] Support services operational
- [ ] Applications deployed
- [ ] Monitoring functional
- [ ] Backups resumed
