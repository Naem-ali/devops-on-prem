# ArgoCD Configuration

GitOps deployment management using ArgoCD.

## Components
- ArgoCD Server
- Application Controller
- Repo Server
- Application Sets
- Notifications Controller

## Configuration
```yaml
server:
  ingress:
    enabled: true
    hostname: argocd.company.com
    tls: true

rbac:
  defaultPolicy: 'role:readonly'
  scopes: '[groups]'

notifications:
  enabled: true
  slack:
    enabled: true
```

## Applications Structure
```plaintext
.
├── applicationsets/    # ApplicationSet manifests
├── projects/          # Project definitions
└── applications/      # Individual applications
```

## Usage
```bash
# Install ArgoCD
./setup.sh

# Access UI
echo "ArgoCD URL: https://$(kubectl get ingress -n argocd argocd-server -o jsonpath='{.spec.rules[0].host}')"
echo "Initial admin password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
```

## Best Practices
- Use Projects for team isolation
- Enable auto-sync with prune
- Configure notifications
- Use RBAC for access control
