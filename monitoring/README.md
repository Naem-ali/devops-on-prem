# Monitoring Stack

Monitoring infrastructure based on Prometheus and Grafana.

## Components
- Prometheus: Metrics collection and storage
- Grafana: Visualization and alerting
- AlertManager: Alert routing and notification

## Directory Structure
```plaintext
.
├── prometheus/
│   ├── rules/       # Alert rules
│   └── values.yaml  # Prometheus configuration
└── grafana/
    ├── dashboards/  # Custom dashboards
    └── values.yaml  # Grafana configuration
```

## Default Dashboards
- Cluster Overview
- Node Metrics
- Security Insights
- Application Metrics

## Alert Rules
- High CPU/Memory Usage
- Pod Restarts
- Security Violations
- Certificate Expiration
