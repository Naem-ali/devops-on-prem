#!/bin/bash
set -e

# Install Velero with MinIO backend
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.4.0 \
  --bucket backups \
  --secret-file ./credentials \
  --use-volume-snapshots=true \
  --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://minio.infrastructure:9000

# Create backup storage
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: backup-store
  namespace: kube-system
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 50Gi
EOF

# Create RBAC for Helm backup
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: helm-backup
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: helm-backup-role
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: helm-backup-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: helm-backup-role
subjects:
- kind: ServiceAccount
  name: helm-backup
  namespace: kube-system
EOF

# Apply backup jobs
kubectl apply -f k3s-backup.yaml
kubectl apply -f helm-backup.yaml
kubectl apply -f gitlab-runner-backup.yaml
kubectl apply -f pv-backup.yaml

echo "Backup infrastructure setup complete!"
