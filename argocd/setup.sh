#!/bin/bash
set -e

# Create ArgoCD namespace if not exists
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Create GitLab access token secret
kubectl create secret generic gitlab-access \
  --from-literal=token=${GITLAB_TOKEN} \
  -n argocd

# Create webhook secret
kubectl create secret generic webhook-secret \
  --from-literal=secret=${WEBHOOK_SECRET} \
  -n argocd

# Apply ApplicationSet
kubectl apply -f applicationset.yaml

# Apply GitLab repository credentials
kubectl apply -f gitlab-secret.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

echo "ArgoCD GitLab integration complete!"
