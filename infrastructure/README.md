# Infrastructure Components

This directory contains core infrastructure configurations for the Kubernetes cluster and supporting services.

## Directory Structure
```plaintext
.
├── k3s/         # K3s cluster configuration
├── argocd/      # ArgoCD GitOps configuration
├── ingress/     # Ingress controller setup
├── security/    # Security tools and policies
└── storage/     # Storage solutions (MinIO)
```

## Prerequisites
- kubectl CLI
- helm v3+
- Access to cluster

## Usage
Each subdirectory contains its own configuration and setup scripts. Follow the order:
1. Deploy k3s
2. Configure storage
3. Set up ingress
4. Deploy ArgoCD
5. Apply security policies

## Configuration
All configurations are templated and values are sourced from `/values.yaml`
