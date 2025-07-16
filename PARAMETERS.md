# Project Parameters Guide

## Infrastructure Parameters

### K3s Cluster Configuration
```yaml
NODE_IP: "192.168.1.100"              # Replace with your node IP
K3S_TOKEN: "your-secure-token"        # Replace with secure cluster token
K3S_VERSION: "v1.27.3+k3s1"          # Replace with desired K3s version
CLUSTER_DOMAIN: "cluster.local"       # Replace with your cluster domain
```

### GitLab Configuration
```yaml
GITLAB_URL: "https://gitlab.company.com"     # Your GitLab instance URL
GITLAB_TOKEN: "glpat-xxxxxxxxxxxx"           # Your GitLab PAT
GITLAB_REPO: "your-org/your-repo"           # Your GitLab repository
```

### ArgoCD Configuration
```yaml
ARGOCD_ADMIN_PASSWORD: "secure-password"     # Initial admin password
ARGOCD_DOMAIN: "argocd.company.com"         # ArgoCD ingress domain
ARGOCD_VERSION: "v2.8.0"                    # ArgoCD version
```

## Monitoring Stack Parameters

### Prometheus Configuration
```yaml
PROMETHEUS_RETENTION: "15d"                  # Data retention period
PROMETHEUS_STORAGE_SIZE: "50Gi"             # Storage capacity
PROMETHEUS_DOMAIN: "prom.company.com"        # Prometheus ingress domain
```

### Grafana Configuration
```yaml
GRAFANA_ADMIN_PASSWORD: "secure-password"    # Admin password
GRAFANA_DOMAIN: "grafana.company.com"        # Grafana ingress domain
GRAFANA_SMTP_HOST: "smtp.company.com"        # Email server
GRAFANA_SMTP_USER: "alerts@company.com"      # Alert email address
```

## Security Tool Parameters

### Falco Configuration
```yaml
FALCO_ALERT_OUTPUT: "webhook"               # Alert output method
FALCO_WEBHOOK_URL: "https://alerts.company.com/falco" # Alert webhook
```

### OPA/Gatekeeper Configuration
```yaml
POLICY_NAMESPACE: "security"                 # Namespace for policies
EXEMPT_NAMESPACES: ["kube-system"]          # Namespaces exempt from policies
```

## Contact Information
```yaml
INFRA_TEAM_EMAIL: "infra@company.com"       # Infrastructure team contact
SECURITY_TEAM_EMAIL: "security@company.com"  # Security team contact
EMERGENCY_CONTACT: "+1-555-0123"            # Emergency contact number
ORGANIZATION_NAME: "Your Company Name"       # Your organization name
```

## Version Requirements
```yaml
KUBECTL_MIN_VERSION: "1.21.0"               # Minimum kubectl version
TERRAFORM_MIN_VERSION: "1.0.0"              # Minimum Terraform version
HELM_VERSION: "3.8.0"                       # Required Helm version
```

## Important Files Requiring Parameter Updates

### Terraform Files
- `terraform/cluster/variables.tf`
- `terraform/monitoring/variables.tf`
- `terraform/environment.tfvars`

### Kubernetes Manifests
- `infrastructure/k3s/config.yaml`
- `infrastructure/argocd/values.yaml`
- `infrastructure/security/policies/*.yaml`

### Helm Values
- `helm/values/development.yaml`
- `helm/values/production.yaml`
- `helm/values/monitoring.yaml`

## Usage Instructions

1. Copy this file to `parameters.local.md`
2. Replace all placeholder values with your actual values
3. Use `envsubst` or similar tool to apply these values to templates
4. Keep `parameters.local.md` out of version control (add to .gitignore)
