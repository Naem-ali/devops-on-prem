#!/bin/bash
set -e

# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Install Node Exporter
helm install node-exporter prometheus-community/prometheus-node-exporter \
  --namespace monitoring \
  -f node-exporter-values.yaml

# Install Kube State Metrics
helm install kube-state-metrics prometheus-community/kube-state-metrics \
  --namespace monitoring \
  -f kube-state-metrics-values.yaml

# Install Prometheus stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  -f prometheus-values.yaml

# Install Loki stack
helm upgrade --install loki grafana/loki-stack \
  --namespace monitoring \
  -f loki-values.yaml

# Install Promtail
helm upgrade --install promtail grafana/promtail \
  --namespace monitoring \
  -f promtail-values.yaml

# Install Fluent Bit
helm upgrade --install fluent-bit fluent/fluent-bit \
  --namespace monitoring \
  -f fluent-bit-values.yaml

# Wait for deployments
kubectl -n monitoring wait --for=condition=available --timeout=300s deployment/kube-state-metrics
kubectl -n monitoring wait --for=condition=complete --timeout=300s job/prometheus-node-exporter
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n monitoring
kubectl wait --for=condition=available --timeout=300s deployment/loki -n monitoring
kubectl rollout status daemonset/promtail -n monitoring
kubectl rollout status daemonset/fluent-bit -n monitoring

# Add local domain to /etc/hosts
echo "127.0.0.1 monitoring.local" | sudo tee -a /etc/hosts

echo "Monitoring components installed successfully!"
echo "Access Grafana at: http://monitoring.local"
echo "Default credentials: admin / admin-password-here"
echo "Logging infrastructure setup complete!"
