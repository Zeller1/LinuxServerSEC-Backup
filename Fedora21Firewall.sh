#!/bin/bash

# Check if Firewalld is installed
if ! rpm -qa | grep -qw firewalld; then
    # Install Firewalld
    sudo dnf install firewalld -y
fi

# Start the service
sudo systemctl start firewalld

# Ensure that the service is running
sudo systemctl enable firewalld

# Set up Firewalld to block all incoming traffic except for http, imap, smtp, and pop3 services
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=imap
sudo firewall-cmd --permanent --add-service=smtp
sudo firewall-cmd --permanent --add-service=pop3
sudo firewall-cmd --permanent --remove-service=ssh

# Save all the rules so that they will work after a reboot
sudo firewall-cmd --reload