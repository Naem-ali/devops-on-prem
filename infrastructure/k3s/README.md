# K3s Cluster Configuration

## Prerequisites
- At least 2 CPU cores
- 2GB RAM per node
- Proper network connectivity between nodes
- Required ports open (6443, 8472, 10250)

## Directory Structure
```plaintext
.
├── config.yaml          # K3s configuration
├── manifests/          # Auto-deployed manifests
│   ├── network/        # CNI configuration
│   └── storage/        # Storage class definitions
└── scripts/            # Installation scripts
```

## Installation
```bash
# Single node setup
./scripts/install-k3s.sh --single-node

# HA cluster setup
./scripts/install-k3s.sh --ha \
    --node-ip=<IP> \
    --token=<TOKEN> \
    --master-nodes="10.0.1.1,10.0.1.2,10.0.1.3"
```

## Post-Installation
1. Verify cluster health
2. Install base components
3. Configure monitoring
4. Apply security policies
