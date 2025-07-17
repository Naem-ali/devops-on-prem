# Backup Configuration

Backup and disaster recovery configurations.

## Components
- etcd Snapshots
- MinIO State Backups
- Velero Cluster Backups
- Configuration Backups

## Backup Schedule
```yaml
etcd:
  schedule: "0 */6 * * *"    # Every 6 hours
  retention: "168h"          # 7 days

terraform:
  schedule: "0 */12 * * *"   # Twice daily
  retention: "720h"          # 30 days

cluster:
  schedule: "0 0 * * *"      # Daily
  retention: "168h"          # 7 days
```

## Recovery Procedures
1. **etcd Recovery**
   ```bash
   ./scripts/restore-etcd.sh <snapshot-name>
   ```

2. **State Recovery**
   ```bash
   ./scripts/restore-state.sh <backup-date>
   ```

3. **Cluster Recovery**
   ```bash
   ./scripts/restore-cluster.sh <backup-name>
   ```

## Important Notes
- Test restores regularly
- Keep offline copies
- Document changes
- Verify backup integrity
