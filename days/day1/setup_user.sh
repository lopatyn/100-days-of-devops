#!/bin/bash

# ==============================================================================
# Script Name:  setup_user.sh
# Description:  Creates a non-interactive system user for service automation.
# Why?          In DevOps, many services need their own user to run, but these 
#               users should never be allowed to log in via SSH or console 
#               to minimize the attack surface (Principle of Least Privilege).
# ==============================================================================

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

USERNAME="devops_service"
SHELL_NOLOGIN="/sbin/nologin"

# Check if the shell exists (some distros use /bin/false)
if [ ! -f "$SHELL_NOLOGIN" ]; then
    SHELL_NOLOGIN="/bin/false"
fi

echo "Creating non-interactive user: $USERNAME..."

# --system: creates a system account (usually UID < 1000)
# --shell: sets the login shell to nologin/false to prevent interactive access
# --no-create-home: prevents creating a home directory if not needed (Hardening)
useradd --system --shell "$SHELL_NOLOGIN" --no-create-home "$USERNAME"

if [ $? -eq 0 ]; then
    echo "User $USERNAME created successfully with shell $SHELL_NOLOGIN."
    echo "Security Status: SUCCESS (No interactive login permitted)."
else
    echo "Failed to create user $USERNAME."
    exit 1
fi

# Verification of the user's shell
grep "$USERNAME" /etc/passwd
