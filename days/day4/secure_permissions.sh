#!/bin/bash

# ==============================================================================
# Script Name:  secure_permissions.sh
# Description:  Demonstrates and applies secure file permissions for scripts.
# Why?          Automated scripts often contain sensitive logic or API keys. 
#               Leaving them with 777 (world-readable/writable) permissions is 
#               a major security risk (Insecure Direct Object Reference).
# ==============================================================================

TARGET_SCRIPT="secret_deploy_logic.sh"

# Create a dummy sensitive script
echo "#!/bin/bash" > "$TARGET_SCRIPT"
echo "echo 'Deploying with TOP SECRET keys...'" >> "$TARGET_SCRIPT"

echo "Current permissions for $TARGET_SCRIPT:"
ls -l "$TARGET_SCRIPT"

echo "--- Hardening Process ---"

# Step 1: Change ownership to the current user (Hardening)
# In production, this would often be a service user (e.g., jenkins or www-data)
chown $USER:$USER "$TARGET_SCRIPT"
echo "Owner set to: $USER"

# Step 2: Set restrictive permissions (700 = Only owner can read, write, and execute)
# Why 700? Because no one else on the system should even read our deployment logic.
chmod 700 "$TARGET_SCRIPT"

echo "Final permissions for $TARGET_SCRIPT:"
ls -l "$TARGET_SCRIPT"

echo "--- Security Verification ---"
# Check if the file is readable by 'others' (it should not be)
if [[ $(stat -c "%a" "$TARGET_SCRIPT") == "700" ]]; then
    echo "SUCCESS: File is hardened. Only the owner has access."
else
    echo "WARNING: Permissions are not restrictive enough!"
fi
