#!/bin/bash

set -e

# Function to check and install Docker
install_docker() {
    echo "Installing Docker..."
    
    # Update package index and install prerequisites
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the stable Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Enable and start Docker
    sudo systemctl enable docker
    sudo systemctl start docker

    echo "Docker installed successfully."
}

# Function to install and run Rancher using Docker
install_rancher() {
    echo "Installing and starting Rancher..."
    
    # Pull Rancher image
    sudo docker pull rancher/rancher:latest

    # Run Rancher container
    sudo docker run -d --restart=unless-stopped \
        -p 80:80 -p 443:443 \
        --name rancher \
        rancher/rancher:latest

    echo "Rancher started successfully. Access it via https://<your-vm-ip>"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    install_docker
else
    echo "Docker already installed."
fi

# Install and start Rancher
install_rancher
