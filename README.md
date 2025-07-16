# Enterprise Kubernetes Infrastructure Project

## 🛠️ Tools & Technologies

### Core Infrastructure
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![K3s](https://img.shields.io/badge/k3s-%23FFC61C.svg?style=for-the-badge&logo=k3s&logoColor=black)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![CRI-O](https://img.shields.io/badge/cri--o-%23294172.svg?style=for-the-badge&logo=crio&logoColor=white)

### CI/CD & GitOps
![GitLab](https://img.shields.io/badge/gitlab-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white)
![ArgoCD](https://img.shields.io/badge/argo%20cd-%23EF7B4D.svg?style=for-the-badge&logo=argo&logoColor=white)
![Helm](https://img.shields.io/badge/helm-%23277A9F.svg?style=for-the-badge&logo=helm&logoColor=white)

### Security & Secrets
![Vault](https://img.shields.io/badge/vault-%23000000.svg?style=for-the-badge&logo=vault&logoColor=white)
![cert-manager](https://img.shields.io/badge/cert--manager-%23ED2B88.svg?style=for-the-badge&logo=cert-manager&logoColor=white)
![Trivy](https://img.shields.io/badge/trivy-%232496ED.svg?style=for-the-badge&logo=aquasec&logoColor=white)

### Monitoring & Logging
![Prometheus](https://img.shields.io/badge/prometheus-%23E6522C.svg?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)
![Loki](https://img.shields.io/badge/loki-%232496ED.svg?style=for-the-badge&logo=grafana&logoColor=white)

### Storage & Registry
![MinIO](https://img.shields.io/badge/minio-%23C72E49.svg?style=for-the-badge&logo=minio&logoColor=white)
![Harbor](https://img.shields.io/badge/harbor-%2360B932.svg?style=for-the-badge&logo=harbor&logoColor=white)

## 🏗️ Architecture

### System Architecture
```mermaid
graph TB
    subgraph External
        Dev[Developer] --> Git[GitLab]
        User[End User] --> Ingress[Traefik Ingress]
    end

    subgraph K3s Cluster
        direction TB
        Ingress --> Front[Frontend App]
        
        subgraph Core Services
            Harbor[Harbor Registry]
            Vault[HashiCorp Vault]
            MinIO[MinIO Storage]
        end
        
        subgraph GitOps
            ArgoCD --> Front
            Git --> ArgoCD
        end
        
        subgraph Monitoring
            direction LR
            Prometheus --> Grafana
            Loki --> Grafana
            Front --> Prometheus
            Front --> Loki
        end
        
        subgraph Security
            CertManager[Cert Manager]
            Keycloak
            CertManager --> Front
            Keycloak --> Front
        end
    end

    subgraph CI/CD
        Git --> |Trigger| Pipeline[GitLab CI]
        Pipeline --> Harbor
        Pipeline --> ArgoCD
    end
```

### Security Flow
```mermaid
graph TB
    subgraph Security Components
        direction TB
        Vault[HashiCorp Vault] --> |Secrets| Apps
        Keycloak --> |Auth| Apps
        CertManager --> |TLS| Ingress
        
        subgraph Policies
            NetworkPolicies[Network Policies]
            PodSecurity[Pod Security]
            RBAC[RBAC Policies]
        end
    end
    
    subgraph CI/CD Security
        Trivy[Trivy Scanner] --> Images[Container Images]
        Images --> Registry[Harbor Registry]
        Registry --> |Signed| Apps
    end
    
    subgraph Monitoring
        Prometheus --> |Metrics| AlertManager
        Loki --> |Logs| AlertManager
        AlertManager --> |Alerts| Team[Security Team]
    end
```

### Data Flow
```mermaid
graph LR
    subgraph Storage Layer
        MinIO --> |Artifacts| GitLab
        MinIO --> |Backups| Vault
        MinIO --> |Images| Harbor
    end
    
    subgraph Application Layer
        Frontend --> |Read| Vault
        Frontend --> |Pull| Harbor
        Frontend --> |Store| MinIO
    end
    
    subgraph Monitoring Layer
        Prometheus --> |Query| Grafana
        Loki --> |Query| Grafana
        Apps --> |Metrics| Prometheus
        Apps --> |Logs| Loki
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
    
    subgraph Data Layer
        Vault1[Vault 1] <--> Vault2[Vault 2]
        Vault2 <--> Vault3[Vault 3]
        Vault3 <--> Vault1
    end
    
    subgraph Storage Layer
        MinIO1[MinIO 1] <--> MinIO2[MinIO 2]
        MinIO2 <--> MinIO3[MinIO 3]
        MinIO3 <--> MinIO1
    end
    
    Master1 <--> Master2
    Master2 <--> Master3
    Master3 <--> Master1
```

## 📂 Project Structure

```plaintext
/devops/
├── infrastructure/        # Core infrastructure configuration
│   ├── auth/            # Keycloak & RBAC
│   ├── cert-manager/    # Certificate management
│   ├── registry/        # Harbor registry
│   ├── storage/        # MinIO configuration
│   └── vault/          # HashiCorp Vault
├── monitoring/          # Monitoring stack
│   ├── prometheus/     # Prometheus configuration
│   ├── grafana/       # Grafana dashboards
│   └── loki/          # Log aggregation
├── backup/             # Backup configurations
├── k3s/               # K3s cluster setup
├── helm/              # Helm charts
└── terraform/         # IaC configurations
```

## 🚀 Quick Start

### Prerequisites
- Linux/Unix environment
- Docker 20.10+
- kubectl 1.21+
- Helm 3.8+
- Terraform 1.0+

### 1. Infrastructure Setup
```bash
# Clone repository
git clone https://gitlab.local/devops-infrastructure.git
cd devops

# Initialize Terraform
cd terraform
terraform init
terraform apply

# Install K3s with CRI-O
cd ../k3s
./setup.sh
```

### 2. Core Services Deployment
```bash
# Deploy Vault
cd ../infrastructure/vault
./setup.sh

# Deploy Harbor Registry
cd ../registry
./setup.sh

# Deploy Monitoring Stack
cd ../../monitoring
./setup.sh
```

### 3. Application Platform
```bash
# Configure ArgoCD
cd ../argocd
./setup.sh

# Deploy Sample Application
kubectl apply -f applicationset.yaml
```

## 🔒 Security Features

1. **Authentication & Authorization**
   - Keycloak integration
   - RBAC policies
   - Service accounts

2. **Secret Management**
   - Vault for secrets
   - Automated rotation
   - Audit logging

3. **Container Security**
   - Trivy scanning
   - SecurityContext
   - Network policies

## 📊 Monitoring & Logging

1. **Metrics**
   - Node metrics
   - Container metrics
   - Custom application metrics

2. **Logging**
   - Centralized logging with Loki
   - Log retention policies
   - Structured logging

3. **Alerting**
   - PrometheusRules
   - Alert routing
   - Notification channels

## 🔄 Backup & Recovery

1. **Component Backups**
   - Vault snapshots
   - etcd backups
   - MinIO backups

2. **Disaster Recovery**
   - Terraform state recovery
   - Full cluster recovery
   - Component restoration

## 📚 Documentation

- [Architecture Guide](docs/architecture.md)
- [Security Guide](docs/security.md)
- [Operations Guide](docs/operations.md)
- [Disaster Recovery](docs/disaster-recovery.md)

## 🔧 Maintenance

### Regular Tasks
1. Certificate rotation
2. Secret rotation
3. Backup verification
4. Security scanning

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

## 📞 Support

- Infrastructure Team: infra@company.com
- Security Team: security@company.com
- Emergency: +1-555-0123

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Create merge request

## 📄 License

Copyright (c) 2023 Your Company Name
