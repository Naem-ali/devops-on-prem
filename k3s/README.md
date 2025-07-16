# K3s Setup Guide

This directory contains scripts for setting up a local K3s cluster with Traefik and ArgoCD.

## Prerequisites

- Linux-based system (Ubuntu/Debian recommended)
- sudo access
- At least 2GB RAM
- 2 CPU cores

## Installation

1. Make the script executable:
```bash
chmod +x setup.sh
```

2. Run the setup script:
```bash
./setup.sh
```

## Verification

1. Check all pods are running:
```bash
kubectl get pods -A
```

2. Test Traefik ingress:
```bash
curl -H "Host: argocd.local" http://localhost
```

3. Access ArgoCD UI:
- URL: http://argocd.local
- Username: admin
- Password: (printed during installation)

## Components Installed

- K3s (minimal Kubernetes)
- Traefik (ingress controller)
- ArgoCD (GitOps deployment)
- Helm 3

## Troubleshooting

1. If pods are pending:
```bash
kubectl describe pod <pod-name> -n <namespace>
```

2. View Traefik logs:
```bash
kubectl logs -l app.kubernetes.io/name=traefik -n default
```

3. Reset K3s:
```bash
k3s-uninstall.sh
./setup.sh
```
