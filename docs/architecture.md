# Architecture Documentation

## High-Level Architecture
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

## Networking Architecture
```mermaid
graph LR
    subgraph External Network
        Internet
        DNS[DNS Server]
    end
    
    subgraph K3s Network
        Ingress[Traefik] --> |TLS| App[Applications]
        App --> |Metrics| Monitoring
        App --> |Logs| Logging
        
        subgraph Service Mesh
            Ingress --> |443| Frontend
            Frontend --> |8200| Vault
            Frontend --> |5000| Registry
            Frontend --> |9000| Storage
        end
    end
    
    Internet --> |443| Ingress
    DNS --> |53| K3s Network
```

## Security Architecture
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

## Data Flow Architecture
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

## Backup & Recovery Architecture
```mermaid
graph TB
    subgraph Backup Sources
        Vault --> |Snapshots| Storage
        ETCD --> |Snapshots| Storage
        Registry --> |Images| Storage
        Configs --> |YAML| Storage
    end
    
    subgraph Storage
        MinIO{MinIO}
    end
    
    subgraph Recovery
        MinIO --> |Restore| NewVault[New Vault]
        MinIO --> |Restore| NewETCD[New ETCD]
        MinIO --> |Restore| NewRegistry[New Registry]
        MinIO --> |Apply| NewConfigs[New Configs]
    end
    
    subgraph Verification
        Monitor[Monitoring]
        Alerts[Alerts]
        NewVault --> Monitor
        NewETCD --> Monitor
        NewRegistry --> Monitor
        Monitor --> Alerts
    end
```

## Component Dependencies
```mermaid
graph TD
    K3s --> CRI[CRI-O Runtime]
    K3s --> Traefik
    
    Traefik --> CertManager
    CertManager --> Vault
    
    ArgoCD --> Vault
    ArgoCD --> Harbor
    
    Apps --> Vault
    Apps --> Harbor
    Apps --> MinIO
    
    Monitoring --> Prometheus
    Monitoring --> Loki
    Monitoring --> Grafana
    
    Backup --> MinIO
    Backup --> Velero
```

## High Availability Design
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

## Scaling Architecture
```mermaid
graph LR
    subgraph Horizontal Scaling
        HPA[HPA] --> Pods
        Pods --> Metrics[Metrics Server]
        Metrics --> HPA
    end
    
    subgraph Vertical Scaling
        VPA[VPA] --> Resources
        Resources --> Monitoring
        Monitoring --> VPA
    end
    
    subgraph Storage Scaling
        PVC[PVC] --> StorageClass
        StorageClass --> Provisioner
        Provisioner --> Storage
    end
```
