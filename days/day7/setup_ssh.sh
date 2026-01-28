#!/bin/bash

# ==============================================================================
# Script Name:  setup_ssh.sh
# Description:  Automates SSH key generation and sets secure permissions.
# Why?          SSH keys are significantly more secure than passwords. 
#               Proper permissions (700 for .ssh, 600 for keys) are mandatory 
#               for SSH to function and to prevent private key theft.
# ==============================================================================

USER_HOME=$(eval echo ~$USER)
SSH_DIR="$USER_HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"

echo "--- SSH Security Hardening ---"

# Step 1: Create .ssh directory if it doesn't exist
if [ ! -d "$SSH_DIR" ]; then
    echo "Creating $SSH_DIR..."
    mkdir -p "$SSH_DIR"
fi

# Step 2: Generate Ed25519 key pair (modern, faster, more secure than RSA)
# -t: type, -f: filename, -N: passphrase (empty for automation demo)
if [ ! -f "$KEY_FILE" ]; then
    echo "Generating new Ed25519 key pair..."
    ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -q
    echo "Key pair generated: $KEY_FILE"
else
    echo "Key pair already exists. Skipping generation."
fi

# Step 3: Enforce Secure Permissions (Crucial for SSH)
echo "Enforcing permissions..."
# 700: rwx for owner only
chmod 700 "$SSH_DIR"
# 600: rw for owner only
chmod 600 "$KEY_FILE"
# Ensure the public key is readable
chmod 644 "${KEY_FILE}.pub"

echo "--- Verification ---"
ls -ld "$SSH_DIR"
ls -l "$KEY_FILE"*

echo -e "\nSetup Complete. Next Step: Add the content of ${KEY_FILE}.pub to your server's authorized_keys."
