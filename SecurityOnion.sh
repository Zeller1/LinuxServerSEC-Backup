#!/bin/bash

# Check if firewalld is installed
if ! command -v firewalld &> /dev/null; then
    echo "Firewalld is not installed. Installing..."
    sudo yum install firewalld -y
fi

# Start firewalld service
echo "Starting firewalld service..."
sudo systemctl start firewalld

# Enable firewalld service to start on boot
sudo systemctl enable firewalld

# Stop and disable SSH service
echo "Stopping and disabling SSH service..."
sudo systemctl stop sshd
sudo systemctl disable sshd

# Stop and disable Cockpit service
echo "Stopping and disabling Cockpit service..."
sudo systemctl stop cockpit.socket
sudo systemctl disable cockpit.socket

# Stop and disable dhcp6-client service
echo "Stopping and disabling dhcp6-client service..."
sudo systemctl stop dhcp6-client
sudo systemctl disable dhcp6-client

# Configure firewalld for Security Onion
echo "Configuring firewalld for Security Onion..."

# Block SSH port
sudo firewall-cmd --permanent --remove-service=ssh

# Block Cockpit port
sudo firewall-cmd --permanent --remove-service=cockpit

# Block DHCPv6 client port
sudo firewall-cmd --permanent --remove-service=dhcpv6-client

# Allow Security Onion services (adjust ports as needed)
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
#sudo firewall-cmd --permanent --add-port=514/tcp
#sudo firewall-cmd --permanent --add-port=514/udp
#sudo firewall-cmd --permanent --add-port=1514/tcp
#sudo firewall-cmd --permanent --add-port=1514/udp
#sudo firewall-cmd --permanent --add-port=3306/tcp
#sudo firewall-cmd --permanent --add-port=27017/tcp

# Reload firewalld to apply changes
echo "Reloading firewalld..."
sudo firewall-cmd --reload

echo "Firewalld configured for Security Onion."