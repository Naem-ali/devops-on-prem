#!/bin/bash

# Load configuration
source "$(dirname "$0")/../../../scripts/config.sh"

# Default values
INSTALL_TYPE="single"
NODE_IP=""
K3S_TOKEN=""
MASTER_NODES=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --single-node)
            INSTALL_TYPE="single"
            shift
            ;;
        --ha)
            INSTALL_TYPE="ha"
            shift
            ;;
        --node-ip=*)
            NODE_IP="${1#*=}"
            shift
            ;;
        --token=*)
            K3S_TOKEN="${1#*=}"
            shift
            ;;
        --master-nodes=*)
            MASTER_NODES="${1#*=}"
            shift
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

# Install K3s
if [ "$INSTALL_TYPE" == "single" ]; then
    curl -sfL https://get.k3s.io | sh -s - \
        --write-kubeconfig-mode 644 \
        --config /etc/rancher/k3s/config.yaml
else
    curl -sfL https://get.k3s.io | sh -s - server \
        --token "$K3S_TOKEN" \
        --node-ip "$NODE_IP" \
        --cluster-init \
        --config /etc/rancher/k3s/config.yaml
fi

# Verify installation
kubectl get nodes
