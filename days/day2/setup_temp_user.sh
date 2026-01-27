#!/bin/bash

# ==============================================================================
# Script Name:  setup_temp_user.sh
# Description:  Creates a temporary user account with a fixed expiration date.
# Why?          Temporary access is crucial for contractors, auditors, or 
#               short-term support. Automated expiry ensures that access is 
#               automatically revoked, preventing "zombie" accounts (Security).
# ==============================================================================

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run with root privileges."
   exit 1
fi

TEMP_USER="contractor_vlad"
# Format: YYYY-MM-DD
EXPIRY_DATE="2026-12-31"

echo "Creating temporary user: $TEMP_USER..."

# --expiredate: sets the date on which the user account will be disabled
# --comment: provides a description for the account
useradd -e "$EXPIRY_DATE" -c "Temporary Auditor Access" "$TEMP_USER"

if [ $? -eq 0 ]; then
    echo "User $TEMP_USER created successfully."
    echo "Account Expiration Date: $EXPIRY_DATE"
else
    echo "Failed to create user $TEMP_USER."
    exit 1
fi

# Verification of account details
# 'chage -l' shows password and account aging/expiration information
echo "--- Account Verification ---"
chage -l "$TEMP_USER"
