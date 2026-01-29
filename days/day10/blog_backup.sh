#!/bin/bash

# ==============================================================================
# Script Name:  blog_backup.sh
# Description:  Automates website backup, zips content, and syncs to a remote server.
# Why?          Ensuring data durability by offloading backups to a dedicated 
#               NB Server (Backup Server) securely via SSH.
# ==============================================================================

# Variables
SRC_DIR="/var/www/html/blog"
DEST_LOCAL="/backup"
BACKUP_NAME="xfusioncorp_blog.zip"
REMOTE_USER="tony"                   # Example user from requirement
REMOTE_HOST="nb_server_ip_or_host"   # Placeholder for NB Server
REMOTE_DEST="/backup/location"

echo "--- Starting Website Backup Process ---"

# Step 1: Create zip archive
echo "Archiving $SRC_DIR..."
# -r: recursive, -q: quiet
zip -rq "$DEST_LOCAL/$BACKUP_NAME" "$SRC_DIR"

if [ $? -eq 0 ]; then
    echo "Local archive created: $DEST_LOCAL/$BACKUP_NAME"
else
    echo "Error: Failed to create local archive."
    exit 1
fi

# Step 2: Transfer to NB Server (Remote Backup)
echo "Transferring backup to NB Server ($REMOTE_DEST)..."
# scp -p: preserves modification times/modes
# Passwordless transfer assumes SSH keys are already configured
scp -p "$DEST_LOCAL/$BACKUP_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST"

if [ $? -eq 0 ]; then
    echo "Remote transfer successful!"
else
    echo "Error: Remote transfer failed. Check SSH keys/Connectivity."
    exit 1
fi

echo "--- Backup Process Completed Successfully at $(date) ---"
