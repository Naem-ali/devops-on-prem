# Security Configuration

This directory contains security tools and policies for the Kubernetes cluster.

## Components
- **Falco**: Runtime security monitoring
- **Kyverno**: Policy management and admission control
- **OPA/Gatekeeper**: Policy enforcement
- **Network Policies**: Network security

## Default Policies
- Non-root container enforcement
- Resource limits requirement
- Privileged container prevention
- Image registry restrictions
- Required labels
- Latest tag prevention

## Usage
```bash
# Apply all security policies
kubectl apply -f kyverno/policies/

# Monitor security events
kubectl logs -n security -l app=falco
```

## Policy Testing
Test your workloads against policies:
```bash
kubectl describe clusterpolicy require-labels
```
