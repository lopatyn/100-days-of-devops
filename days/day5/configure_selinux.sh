#!/bin/bash

# ==============================================================================
# Script Name:  configure_selinux.sh
# Description:  Tools for managing and verifying SELinux security policies.
# Why?          SELinux (Mandatory Access Control) is a critical layer of 
#               defense-in-depth. It prevents compromised services from 
#               accessing files they shouldn't, even if they have root rights.
# ==============================================================================

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root."
   exit 1
fi

echo "--- SELinux Status Check ---"
# sestatus: the definitive tool for checking SELinux state
if command -v sestatus >/dev/null 2>&1; then
    sestatus
else
    echo "SELinux tools not found. Are you on a RHEL/CentOS/Fedora system?"
    exit 1
fi

echo -e "\n--- Current Mode Control ---"
CURRENT_MODE=$(getenforce)
echo "Current Mode: $CURRENT_MODE"

# Function to toggle modes safely
# Note: setenforce only changes it for the current session (runtime)
toggle_mode() {
    if [[ "$CURRENT_MODE" == "Enforcing" ]]; then
        echo "Switching to Permissive (Logging only, no blocking)..."
        setenforce 0
    else
        echo "Switching to Enforcing (Full protection)..."
        setenforce 1
    fi
}

echo -e "\n--- File Context Verification ---"
TEST_FILE="/tmp/selinux_test.txt"
touch "$TEST_FILE"

# ls -Z: shows the SELinux security context (User:Role:Type:Level)
echo "Security context for $TEST_FILE:"
ls -Z "$TEST_FILE"

# restorecon: resets file context to default based on policy
echo "Resetting context with restorecon..."
restorecon -v "$TEST_FILE"

rm "$TEST_FILE"
echo -e "\nSELinux check complete."
