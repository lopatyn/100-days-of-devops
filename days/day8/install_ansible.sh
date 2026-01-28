#!/bin/bash

# ==============================================================================
# Script Name:  install_ansible.sh
# Description:  Globally installs Ansible using pip3 and ensures binary access.
# Why?          Ansible is the industry standard for Configuration Management. 
#               A global installation ensures that all system users and 
#               automated services can leverage Ansible for IaC.
# ==============================================================================

# Ensure the script is run as root for global installation
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root (use sudo)."
   exit 1
fi

echo "--- Ansible Global Installation ---"

# Step 1: Update package list and install pip3 if missing
echo "Updating apt and installing python3-pip..."
apt-get update -y -q
apt-get install -y -q python3-pip

# Step 2: Global installation via pip3
# Using 'sudo pip3' ensures binaries go to /usr/local/bin
echo "Installing Ansible globally..."
pip3 install ansible

# Step 3: Verification
echo "Verifying installation..."
if command -v ansible >/dev/null 2>&1; then
    ANSIBLE_PATH=$(which ansible)
    ANSIBLE_VERSION=$(ansible --version | head -n 1)
    echo "SUCCESS: Ansible is installed at $ANSIBLE_PATH"
    echo "Version: $ANSIBLE_VERSION"
    
    # Check if accessible by others (binary permissions)
    ls -l "$ANSIBLE_PATH"
else
    echo "ERROR: Ansible installation failed or is not in the PATH."
    exit 1
fi

echo -e "\nSetup Complete. You can now use 'ansible' globally."
