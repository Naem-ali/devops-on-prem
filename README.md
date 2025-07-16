# Enterprise Kubernetes Infrastructure Project

## 🛠️ Tools & Technologies

### Core Infrastructure
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![K3s](https://img.shields.io/badge/k3s-%23FFC61C.svg?style=for-the-badge&logo=k3s&logoColor=black)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

### CI/CD & GitOps
![GitLab](https://img.shields.io/badge/gitlab-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white)
![ArgoCD](https://img.shields.io/badge/argo%20cd-%23EF7B4D.svg?style=for-the-badge&logo=argo&logoColor=white)
![Helm](https://img.shields.io/badge/helm-%23277A9F.svg?style=for-the-badge&logo=helm&logoColor=white)

### Security Tools
![Falco](https://img.shields.io/badge/falco-%232C3E50.svg?style=for-the-badge&logo=falco&logoColor=white)
![Kyverno](https://img.shields.io/badge/kyverno-%23326CE5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![OPA](https://img.shields.io/badge/opa-%23000000.svg?style=for-the-badge&logo=openpolicyagent&logoColor=white)
![Gatekeeper](https://img.shields.io/badge/gatekeeper-%23326CE5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

### Monitoring & Logging
![Prometheus](https://img.shields.io/badge/prometheus-%23E6522C.svg?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

## 🏗️ Architecture

### System Architecture
```mermaid
graph TB
    subgraph External
        Dev[Developer] --> Git[GitLab]
        User[End User] --> Ingress[Ingress Controller]
    end

    subgraph K3s Cluster
        direction TB
        Ingress --> Apps[Applications]
        
        subgraph GitOps
            ArgoCD --> Apps
            Git --> ArgoCD
            HelmCharts[Helm Charts] --> ArgoCD
        end
        
        subgraph Security
            direction LR
            Falco --> Apps
            OPA[OPA/Gatekeeper] --> Apps
            Kyverno --> Apps
        end
        
        subgraph Monitoring
            direction LR
            Prometheus --> Grafana
            Apps --> Prometheus
        end
    end

    subgraph CI/CD
        Git --> |Trigger| Pipeline[GitLab CI]
        Pipeline --> |Build Charts| HelmCharts
        Pipeline --> |Sync| ArgoCD
    end
```

### Data Flow
```mermaid
graph LR
    subgraph Development
        Git --> |Trigger| Pipeline
        Pipeline --> |Build| HelmCharts[Helm Charts]
        HelmCharts --> |Package| ArgoCD
    end
    
    subgraph Runtime
        ArgoCD --> |Deploy| Apps[Applications]
        Falco --> |Monitor| Apps
        OPA --> |Policy Check| Apps
        Kyverno --> |Validate| Apps
    end
    
    subgraph Monitoring Layer
        Prometheus --> |Query| Grafana
        Apps --> |Metrics| Prometheus
    end
```

### High Availability
```mermaid
graph TB
    subgraph Control Plane
        Master1[K3s Master 1]
        Master2[K3s Master 2]
        Master3[K3s Master 3]
    end
    
    Master1 <--> Master2
    Master2 <--> Master3
    Master3 <--> Master1
```

## 📂 Project Structure

```plaintext
/devops-on-prem/
├── infrastructure/        # Core infrastructure configuration
│   ├── k3s/             # K3s cluster setup
│   ├── argocd/          # ArgoCD configuration
│   ├── ingress/         # Ingress controller setup
│   └── security/        # Security tools configuration
│       ├── falco/       # Falco runtime security
│       ├── kyverno/     # Policy management
│       └── opa/         # Open Policy Agent/Gatekeeper
├── monitoring/           # Monitoring stack
│   ├── prometheus/      # Prometheus configuration
│   └── grafana/         # Grafana dashboards
├── helm/                # Helm charts
│   ├── charts/         # Application Helm charts
│   └── values/         # Environment-specific values
└── terraform/           # IaC configurations
    ├── cluster/        # K3s cluster resources
    └── monitoring/     # Monitoring resources
```

## 🚀 Quick Start

### Prerequisites
- Linux/Unix environment
- kubectl 1.21+
- Terraform 1.0+

### 1. Infrastructure Setup
```bash
# Clone repository
git clone https://gitlab.local/devops-infrastructure.git
cd devops-on-prem

# Initialize Terraform
cd terraform
terraform init
terraform apply

# Install K3s
cd ../infrastructure/k3s
./setup.sh
```

### 2. Core Services Deployment
```bash
# Configure ArgoCD
cd ../argocd
./setup.sh

# Deploy Monitoring Stack
cd ../../monitoring
./setup.sh
```

### 3. Application Platform
```bash
# Deploy Sample Application
kubectl apply -f applicationset.yaml
```

## 🔒 Security Features

1. **Authentication & Authorization**
   - RBAC policies
   - Service accounts

2. **Secret Management**
   - Automated rotation
   - Audit logging

3. **Container Security**
   - SecurityContext
   - Network policies

## 📊 Monitoring & Logging

1. **Metrics**
   - Node metrics
   - Container metrics
   - Custom application metrics

2. **Logging**
   - Centralized logging
   - Log retention policies
   - Structured logging

3. **Alerting**
   - PrometheusRules
   - Alert routing
   - Notification channels

## 🔄 Backup & Recovery

1. **Component Backups**
   - etcd backups

2. **Disaster Recovery**
   - Terraform state recovery
   - Full cluster recovery


## 🔧 Maintenance

### Regular Tasks
1. Certificate rotation
2. Backup verification
3. Security scanning

### Monitoring
1. Resource utilization
2. Security events
3. Application health
4. Backup status

## 🚨 Troubleshooting

### Common Issues
1. Certificate expiration
2. Storage pressure
3. Network connectivity
4. Authentication failures

### Debug Commands
```bash
# Check cluster health
kubectl get nodes
kubectl get pods -A

# View logs
kubectl logs -n <namespace> <pod-name>

# Check certificates
kubectl get certificates -A
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Create merge request

## 📄 License

Copyright@2025devopshound
