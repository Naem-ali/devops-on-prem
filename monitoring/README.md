# Monitoring Storage Configuration

## Storage Overview
- Prometheus: 50Gi for TSDB
- Loki: 50Gi for logs
- Grafana: 10Gi for dashboards

## Retention Policies
- Prometheus: 15 days, 45GB max
- Loki: 15 days default, 30 days for production
- Grafana: Daily backups

## Local Storage Setup
```bash
# Apply storage class
kubectl apply -f infrastructure/storage/local-storage.yaml

# Verify storage class
kubectl get storageclass
```

## Maintenance

### Volume Cleanup
```bash
# Check volume usage
kubectl -n monitoring get pv

# Cleanup old data
kubectl -n monitoring exec -it prometheus-0 -- promtool tsdb clean
```

### Backup Volumes
```bash
# Backup Grafana
kubectl -n monitoring exec -it grafana-0 -- grafana-cli admin data-migration backup

# Backup Prometheus
kubectl -n monitoring exec -it prometheus-0 -- promtool tsdb snapshot
```

### Restore Data
```bash
# Restore Grafana
kubectl cp backup.tar.gz monitoring/grafana-0:/var/lib/grafana/backup.tar.gz
kubectl -n monitoring exec -it grafana-0 -- grafana-cli admin data-migration restore

# Restore Prometheus
kubectl -n monitoring exec -it prometheus-0 -- promtool tsdb snapshot restore
```
