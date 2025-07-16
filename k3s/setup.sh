#!/bin/bash
set -e

echo "Setting up K3s cluster..."

# Install CRI-O
OS=xUbuntu_22.04
VERSION=1.24

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

apt-get update
apt-get install -y cri-o cri-o-runc

# Configure CRI-O
mkdir -p /etc/crio/certs
mkdir -p /etc/containers
cp config/crio.conf /etc/crio/crio.conf
cp config/registries.yaml /etc/containers/registries.conf
cp config/seccomp.json /etc/crio/seccomp.json

# Start CRI-O
systemctl enable crio
systemctl start crio

# Install K3s with CRI-O
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--container-runtime-endpoint unix:///var/run/crio/crio.sock --disable=traefik" sh -

# Wait for K3s to be ready
echo "Waiting for K3s to be ready..."
sleep 10

# Set KUBECONFIG for current user
mkdir -p $HOME/.kube
sudo cat /etc/rancher/k3s/k3s.yaml > $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add required Helm repositories
helm repo add traefik https://traefik.github.io/charts
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install Traefik with custom configuration
echo "Installing Traefik..."
cat <<EOF > traefik-values.yaml
deployment:
  replicas: 1
ports:
  web:
    exposedPort: 80
  websecure:
    exposedPort: 443
ingressRoute:
  dashboard:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: traefik
dashboard:
  enabled: true
EOF

helm install traefik traefik/traefik -f traefik-values.yaml

# Install ArgoCD
echo "Installing ArgoCD..."
kubectl create namespace argocd
helm install argocd argo/argo-cd \
  --namespace argocd \
  --set server.extraArgs="{--insecure}" \
  --values - <<EOF
server:
  ingress:
    enabled: true
    hosts:
      - argocd.local
    annotations:
      kubernetes.io/ingress.class: traefik
EOF

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Get ArgoCD admin password
echo "ArgoCD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo

# Add local domain to /etc/hosts
echo "Adding local domains to /etc/hosts..."
sudo tee -a /etc/hosts <<EOF
127.0.0.1 argocd.local
127.0.0.1 huggingface.local
EOF

echo "Installation complete!"
echo "Access ArgoCD at: http://argocd.local"
echo "Username: admin"
echo "Run 'kubectl get pods -A' to check all pods are running"
