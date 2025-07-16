#!/bin/bash
set -e

echo "Starting Vault recovery test..."

# Create test namespace
kubectl create ns vault-test

# Deploy test Vault instance
helm install vault-test hashicorp/vault \
  --namespace vault-test \
  -f ../infrastructure/vault/values.yaml

# Wait for Vault
kubectl -n vault-test wait --for=condition=Ready pod/vault-test-0

# Create test data
kubectl -n vault-test exec vault-test-0 -- vault kv put secret/test-data \
  key1=value1 \
  key2=value2

# Create snapshot
kubectl -n vault-test exec vault-test-0 -- vault operator raft snapshot save /tmp/test-snapshot.snap

# Simulate failure
kubectl -n vault-test delete pod vault-test-0
kubectl -n vault-test delete pvc data-vault-test-0

# Restore from snapshot
kubectl -n vault-test cp /tmp/test-snapshot.snap vault-test-0:/tmp/
kubectl -n vault-test exec vault-test-0 -- vault operator raft snapshot restore /tmp/test-snapshot.snap

# Verify data
TEST_VALUE=$(kubectl -n vault-test exec vault-test-0 -- vault kv get -field=key1 secret/test-data)
if [ "$TEST_VALUE" = "value1" ]; then
    echo "Recovery test successful!"
else
    echo "Recovery test failed!"
    exit 1
fi

# Cleanup
kubectl delete ns vault-test
