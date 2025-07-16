#!/bin/bash
set -e

echo "Starting application recovery test..."

# Create test namespace
kubectl create ns app-test

# Deploy test application
helm install test-app ../helm/huggingface-app \
  --namespace app-test \
  -f ../helm/huggingface-app/values-test.yaml

# Create test data
kubectl -n app-test create configmap test-data --from-literal=test=data

# Create backup
velero backup create app-test-backup \
  --include-namespaces app-test

# Simulate failure
kubectl delete ns app-test

# Restore from backup
velero restore create app-test-restore \
  --from-backup app-test-backup

# Verify restoration
kubectl -n app-test wait --for=condition=Available deployment/test-app
TEST_DATA=$(kubectl -n app-test get configmap test-data -o jsonpath='{.data.test}')

if [ "$TEST_DATA" = "data" ]; then
    echo "Application recovery test successful!"
else
    echo "Application recovery test failed!"
    exit 1
fi

# Cleanup
kubectl delete ns app-test
