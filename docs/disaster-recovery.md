# Disaster Recovery Procedures

## Recovery Priority Order
1. Vault (certificates and secrets)
2. GitLab (source code and CI/CD)
3. Harbor Registry (container images)
4. ArgoCD (deployment state)
5. Monitoring Stack (metrics and logs)

## Vault Recovery

```bash
# 1. Stop existing Vault pods
kubectl -n vault scale statefulset vault --replicas=0

# 2. Restore snapshot from MinIO
mc cp minio/vault-backup/vault-YYYYMMDD.snap /tmp/
kubectl -n vault cp /tmp/vault-YYYYMMDD.snap vault-0:/tmp/

# 3. Restore Vault data
kubectl -n vault exec -it vault-0 -- vault operator raft snapshot restore /tmp/vault-YYYYMMDD.snap

# 4. Verify recovery
kubectl -n vault exec -it vault-0 -- vault status
kubectl -n vault exec -it vault-0 -- vault secrets list
```

## Harbor Registry Recovery

```bash
# 1. Stop Harbor components
kubectl -n infrastructure scale deployment/harbor --replicas=0

# 2. Restore from backup
velero restore create harbor-restore --from-backup harbor-YYYYMMDD

# 3. Verify images
kubectl -n infrastructure port-forward svc/harbor 8080:80
curl -k https://localhost:8080/v2/_catalog
```

## ArgoCD Recovery

```bash
# 1. Restore ArgoCD data
velero restore create argocd-restore --from-backup argocd-YYYYMMDD

# 2. Verify applications
argocd app list
argocd app get huggingface-app

# 3. Resync all applications
argocd app sync --prune huggingface-app
```

## Etcd Recovery

```bash
# 1. Stop K3s
systemctl stop k3s

# 2. Restore etcd snapshot
cp /backup/k3s-etcd-YYYYMMDD.db /var/lib/rancher/k3s/server/db/etcd/
systemctl start k3s

# 3. Verify cluster state
kubectl get nodes
kubectl get pods -A
```

## Monitoring Stack Recovery

```bash
# 1. Restore Prometheus data
velero restore create monitoring-restore \
  --from-backup monitoring-YYYYMMDD \
  --include-namespaces monitoring

# 2. Verify metrics and dashboards
kubectl -n monitoring port-forward svc/grafana 3000:3000
# Access Grafana and verify dashboards
```

## Full Cluster Recovery

In case of complete cluster failure:

1. **Infrastructure Setup**
```bash
# 1. Install K3s with CRI-O
./k3s/setup.sh

# 2. Install core components
./infrastructure/setup.sh

# 3. Restore Vault
./infrastructure/vault/restore.sh

# 4. Restore Registry
./infrastructure/harbor/restore.sh
```

2. **Application Recovery**
```bash
# 1. Restore application namespaces
velero restore create frontend-restore \
  --from-backup frontend-YYYYMMDD

# 2. Verify applications
kubectl get pods -n frontend-prod
kubectl get ingress -A
```

## Testing Recovery Procedures

Run quarterly recovery tests:

1. **Vault Recovery Test**
```bash
# Create test namespace
kubectl create ns dr-test

# Test restore in isolation
./tests/vault-recovery-test.sh
```

2. **Application Recovery Test**
```bash
# Test application restore
./tests/app-recovery-test.sh

# Verify functionality
./tests/verify-app-health.sh
```

## Recovery Time Objectives (RTO)

| Component | RTO   | RPO   |
|-----------|-------|-------|
| Vault     | 15m   | 1h    |
| GitLab    | 30m   | 24h   |
| Harbor    | 1h    | 24h   |
| ArgoCD    | 30m   | 24h   |
| Apps      | 2h    | 24h   |

## Contacts and Escalation

1. Platform Team: platform@company.com
2. Security Team: security@company.com
3. On-Call Phone: +1-555-0123

## Recovery Validation Checklist

- [ ] Vault secrets accessible
- [ ] Registry images pullable
- [ ] Applications deployed
- [ ] Ingress functioning
- [ ] Monitoring operational
- [ ] Logs flowing
- [ ] Certificates valid
