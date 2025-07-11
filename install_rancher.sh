#!/bin/bash

set -e

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
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

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo systemctl enable docker
    sudo systemctl start docker

    echo "✅ Docker installed successfully."
}

# Function to install Rancher
install_rancher() {
    echo "Installing and starting Rancher..."

    sudo docker pull rancher/rancher:latest

    sudo docker run -d --restart=unless-stopped \
        -p 80:80 -p 443:443 \
        --name rancher \
        rancher/rancher:latest

    echo "✅ Rancher started successfully. Access it via: https://<your-vm-ip>"
}

# Function to install and configure UFW
configure_firewall() {
    echo "Configuring firewall..."

    sudo apt-get install -y ufw

    sudo ufw allow OpenSSH
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp

    echo "y" | sudo ufw enable

    echo "✅ UFW enabled and configured (allowed ports: 22, 80, 443)."
}

# Main Execution
if ! command -v docker &> /dev/null; then
    install_docker
else
    echo "✅ Docker already installed."
fi

install_rancher
configure_firewall
