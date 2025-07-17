# Helm Charts

Application Helm charts and values for different environments.

## Directory Structure
```plaintext
.
├── charts/    # Application Helm charts
└── values/    # Environment-specific values
    ├── development.yaml
    ├── production.yaml
    └── monitoring.yaml
```

## Usage
```bash
# Install with environment values
helm install -f values/production.yaml app ./charts/app

# Template validation
helm template -f values/development.yaml app ./charts/app
```

## Value Precedence
1. CLI overrides
2. Environment values
3. Default values.yaml
4. Chart defaults
