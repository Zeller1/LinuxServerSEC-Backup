#!/bin/bash

# Check if UFW is installed
if ! command -v ufw &> /dev/null; then
    echo "UFW is not installed. Installing..."
    sudo apt update
    sudo apt install ufw -y
fi

# Enable UFW
echo "Enabling UFW..."
sudo ufw enable

# Allow SSH traffic
echo "Allowing SSH traffic..."
sudo ufw allow ssh

# Allow Snipe-IT service (adjust port as needed)
echo "Allowing Snipe-IT service..."
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Deny all other incoming traffic
echo "Denying all other incoming traffic..."
sudo ufw default deny incoming

# Allow all outgoing traffic
echo "Allowing all outgoing traffic..."
sudo ufw default allow outgoing

# Reload UFW to apply changes
echo "Reloading UFW..."
sudo ufw reload

echo "UFW configured for Snipe-IT."
