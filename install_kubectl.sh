#!/bin/bash

set -e

echo "🔧 Installing kubectl (latest stable version)..."

# Download the latest release
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make it executable
chmod +x kubectl

# Move to system path
sudo mv kubectl /usr/local/bin/

# Verify installation
echo "✅ kubectl installed successfully. Version:"
kubectl version --client --output=yaml
