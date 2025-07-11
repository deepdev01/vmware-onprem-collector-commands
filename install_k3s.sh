#!/bin/bash

set -e

echo "🔧 Updating system packages..."
sudo apt-get update -y

echo "📦 Installing required dependencies..."
sudo apt-get install -y curl

echo "🚀 Installing K3s (latest version)..."
curl -sfL https://get.k3s.io | sh -

echo "✅ K3s installed successfully."

# Add current user to the k3s group so they can use kubectl without sudo
echo "👤 Configuring access to kubectl..."
sudo chmod +r /etc/rancher/k3s/k3s.yaml
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "📎 Exporting KUBECONFIG environment variable..."
echo "export KUBECONFIG=$HOME/.kube/config" >> ~/.bashrc
export KUBECONFIG=$HOME/.kube/config

echo "✅ You can now use kubectl to interact with your K3s cluster."
