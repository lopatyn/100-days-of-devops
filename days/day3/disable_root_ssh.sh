#!/bin/bash

# ==============================================================================
# Script Name:  disable_root_ssh.sh
# Description:  Disables direct root login via SSH for security hardening.
# Why?          Root is a known target for brute-force attacks. Disabling direct 
#               root login forces users to log in as a standard user and use 
#               'sudo', providing an audit trail.
# ==============================================================================

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root."
   exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_CONFIG="/etc/ssh/sshd_config.bak.$(date +%F_%T)"

echo "Backing up SSH config to $BACKUP_CONFIG..."
cp "$SSHD_CONFIG" "$BACKUP_CONFIG"

echo "Disabling PermitRootLogin in $SSHD_CONFIG..."

# Use sed to find 'PermitRootLogin' (commented or not) and set it to 'no'
if grep -q "^#*PermitRootLogin" "$SSHD_CONFIG"; then
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
else
    echo "PermitRootLogin no" >> "$SSHD_CONFIG"
fi

# Verification of the config change
if grep -q "^PermitRootLogin no" "$SSHD_CONFIG"; then
    echo "Configuration updated successfully."
else
    echo "Failed to update configuration. Reverting..."
    mv "$BACKUP_CONFIG" "$SSHD_CONFIG"
    exit 1
fi

echo "Restarting SSH service..."
systemctl restart sshd

if [ $? -eq 0 ]; then
    echo "SSH service restarted. Root login is now DISABLED."
else
    echo "Failed to restart SSH service. Please check manually."
    exit 1
fi
